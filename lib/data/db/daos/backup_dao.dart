part of '../app_database.dart';

/// Export/import (FR-02) — gzipped JSON handled by ImportExportService.
/// Secrets are stripped on export (NFR-02): email passwords and secret variables.
@DriftAccessor(tables: [
  Nodes,
  Links,
  Notes,
  Emails,
  Subscriptions,
  Platforms,
  Variables,
  Alerts,
  OpenLogs,
])
class BackupDao extends DatabaseAccessor<AppDatabase> with _$BackupDaoMixin {
  BackupDao(super.db);

  Future<Map<String, dynamic>> exportJson() async {
    String? dt(DateTime? d) => d?.toIso8601String();
    final ns = await (select(nodes)..where((n) => n.deletedAt.isNull())).get();
    final ls = await (select(links)..where((l) => l.deletedAt.isNull())).get();
    final nts = await (select(notes)..where((n) => n.deletedAt.isNull())).get();
    final es = await (select(emails)..where((e) => e.deletedAt.isNull())).get();
    final ss =
        await (select(subscriptions)..where((s) => s.deletedAt.isNull())).get();
    final ps =
        await (select(platforms)..where((p) => p.deletedAt.isNull())).get();
    final vs = await (select(variables)
          ..where((v) => v.deletedAt.isNull() & v.isSecret.equals(false)))
        .get();
    final as = await (select(alerts)..where((a) => a.deletedAt.isNull())).get();

    return {
      'schemaVersion': AppConstants.exportSchemaVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'nodes': [
        for (final n in ns)
          {
            'id': n.id,
            'parentId': n.parentId,
            'name': n.name,
            'type': n.type.name,
            'template': n.template?.name,
            'icon': n.icon,
            'status': n.status.name,
            'sortIndex': n.sortIndex,
            'createdAt': dt(n.createdAt),
          },
      ],
      'links': [
        for (final l in ls)
          {
            'nodeId': l.nodeId,
            'title': l.title,
            'url': l.url,
            'category': l.category.name,
          },
      ],
      'notes': [
        for (final n in nts)
          {
            'nodeId': n.nodeId,
            'title': n.title,
            'content': n.content,
            'createdAt': dt(n.createdAt),
          },
      ],
      // password intentionally stripped (NFR-02)
      'emails': [
        for (final e in es)
          {
            'nodeId': e.nodeId,
            'label': e.label,
            'address': e.address,
          },
      ],
      'subscriptions': [
        for (final s in ss)
          {
            'nodeId': s.nodeId,
            'serviceName': s.serviceName,
            'plan': s.plan,
            'price': s.price,
            'cycle': s.cycle.name,
            'renewsAt': dt(s.renewsAt),
            'status': s.status.name,
          },
      ],
      'platforms': [
        for (final p in ps)
          {
            'nodeId': p.nodeId,
            'platformName': p.platformName,
            'account': p.account,
            'url': p.url,
          },
      ],
      // secret variables excluded entirely (NFR-02)
      'variables': [
        for (final v in vs)
          {
            'nodeId': v.nodeId,
            'varKey': v.varKey,
            'varValue': v.varValue,
            'isSecret': false,
          },
      ],
      'alerts': [
        for (final a in as)
          {
            'nodeId': a.nodeId,
            'title': a.title,
            'fireAt': dt(a.fireAt),
            'reminderMinutesBefore': a.reminderMinutesBefore,
            'enabled': a.enabled,
          },
      ],
    };
  }

  /// Import with id remapping. [ImportStrategy.replace] wipes data first
  /// (settings such as theme/trial/purchase are preserved either way).
  Future<void> importJson(
    Map<String, dynamic> data,
    ImportStrategy strategy,
  ) {
    return transaction(() async {
      if (strategy == ImportStrategy.replace) await deleteAllData();

      List<Map<String, dynamic>> listOf(String key) =>
          (data[key] as List?)?.cast<Map<String, dynamic>>() ?? const [];

      final idMap = <int, int>{};
      final nodeList = listOf('nodes');

      for (final n in nodeList) {
        final newId = await into(nodes).insert(
          NodesCompanion.insert(
            name: n['name'] as String,
            type: NodeType.values.byName(n['type'] as String),
            template: n['template'] == null
                ? const Value<NodeTemplate?>(null)
                : Value(NodeTemplate.values.byName(n['template'] as String)),
            icon: Value((n['icon'] as String?) ?? 'folder'),
            status: n['status'] == null
                ? const Value(NodeStatus.active)
                : Value(NodeStatus.values.byName(n['status'] as String)),
            sortIndex: Value((n['sortIndex'] as num?)?.toInt() ?? 0),
            createdAt: Value(
                DateTime.tryParse(n['createdAt'] as String? ?? '') ??
                    DateTime.now()),
          ),
        );
        idMap[(n['id'] as num).toInt()] = newId;
      }

      // second pass — resolve parent links
      for (final n in nodeList) {
        final oldParent = (n['parentId'] as num?)?.toInt();
        final oldId = (n['id'] as num).toInt();
        if (oldParent != null && idMap.containsKey(oldParent)) {
          await (update(nodes)..where((x) => x.id.equals(idMap[oldId]!)))
              .write(NodesCompanion(parentId: Value(idMap[oldParent]!)));
        }
      }

      int? map(int? oldId) => oldId == null ? null : idMap[oldId];

      for (final l in listOf('links')) {
        final nodeId = map((l['nodeId'] as num).toInt());
        if (nodeId == null) continue;
        await into(links).insert(
          LinksCompanion.insert(
            nodeId: nodeId,
            title: l['title'] as String,
            url: l['url'] as String,
            category: l['category'] == null
                ? LinkCategory.other
                : LinkCategory.values.byName(l['category'] as String),
          ),
        );
      }

      for (final n in listOf('notes')) {
        final nodeId = map((n['nodeId'] as num).toInt());
        if (nodeId == null) continue;
        await into(notes).insert(
          NotesCompanion.insert(
            nodeId: nodeId,
            title: Value(n['title'] as String?),
            content: Value((n['content'] as String?) ?? ''),
          ),
        );
      }

      for (final e in listOf('emails')) {
        final nodeId = map((e['nodeId'] as num).toInt());
        if (nodeId == null) continue;
        await into(emails).insert(
          EmailsCompanion.insert(
            nodeId: nodeId,
            label: e['label'] as String,
            address: e['address'] as String,
          ),
        );
      }

      for (final s in listOf('subscriptions')) {
        final nodeId = map((s['nodeId'] as num).toInt());
        if (nodeId == null) continue;
        await into(subscriptions).insert(
          SubscriptionsCompanion.insert(
            nodeId: nodeId,
            serviceName: s['serviceName'] as String,
            plan: Value(s['plan'] as String?),
            price: Value(s['price'] as String?),
            cycle: s['cycle'] == null
                ? const Value(BillingCycle.monthly)
                : Value(BillingCycle.values.byName(s['cycle'] as String)),
            renewsAt: Value(DateTime.tryParse(s['renewsAt'] as String? ?? '')),
            status: s['status'] == null
                ? const Value(SubStatus.active)
                : Value(SubStatus.values.byName(s['status'] as String)),
          ),
        );
      }

      for (final p in listOf('platforms')) {
        final nodeId = map((p['nodeId'] as num).toInt());
        if (nodeId == null) continue;
        await into(platforms).insert(
          PlatformsCompanion.insert(
            nodeId: nodeId,
            platformName: p['platformName'] as String,
            account: Value(p['account'] as String?),
            url: Value(p['url'] as String?),
          ),
        );
      }

      for (final v in listOf('variables')) {
        final nodeId = map((v['nodeId'] as num).toInt());
        if (nodeId == null) continue;
        await into(variables).insert(
          VariablesCompanion.insert(
            nodeId: nodeId,
            varKey: v['varKey'] as String,
            varValue: Value((v['varValue'] as String?) ?? ''),
            isSecret: Value((v['isSecret'] as bool?) ?? false),
          ),
        );
      }

      for (final a in listOf('alerts')) {
        final nodeId = map((a['nodeId'] as num).toInt());
        if (nodeId == null) continue;
        await into(alerts).insert(
          AlertsCompanion.insert(
            nodeId: nodeId,
            title: a['title'] as String,
            fireAt:
                DateTime.tryParse(a['fireAt'] as String? ?? '') ?? DateTime.now(),
            reminderMinutesBefore:
                Value((a['reminderMinutesBefore'] as num?)?.toInt() ?? 15),
            enabled: Value((a['enabled'] as bool?) ?? true),
          ),
        );
      }
    });
  }

  Future<void> deleteAllData() async {
    await delete(openLogs).go();
    await delete(links).go();
    await delete(notes).go();
    await delete(emails).go();
    await delete(subscriptions).go();
    await delete(platforms).go();
    await delete(variables).go();
    await delete(alerts).go();
    await delete(nodes).go();
  }
}
