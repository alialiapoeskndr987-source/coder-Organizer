import 'dart:convert';

import 'package:coder_organizer/core/models/enums.dart';
import 'package:coder_organizer/data/db/app_database.dart';
import 'package:coder_organizer/providers/tree_providers.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('hierarchy: subtree soft-delete + instant undo (D-010)', () async {
    final tab = await db.nodesDao
        .addNode(NodesCompanion.insert(name: 'Tab', type: NodeType.mainTab));
    final sub = await db.nodesDao.addNode(NodesCompanion.insert(
        name: 'Sub', type: NodeType.subTab, parentId: Value(tab)));
    final proj = await db.nodesDao.addNode(NodesCompanion.insert(
        name: 'Proj', type: NodeType.project, parentId: Value(sub)));
    await db.elementsDao.addLink(LinksCompanion.insert(
        nodeId: proj,
        title: 'Repo',
        url: 'https://github.com/x/y',
        category: LinkCategory.repository));

    final snapshot = await db.nodesDao.softDeleteSubtree(tab);
    expect(snapshot.nodeIds.length, 3);
    expect((await db.nodesDao.trashedNodes()).length, 3);
    expect((await db.nodesDao.watchNodes().first).isEmpty, isTrue);

    await db.nodesDao.restoreSubtree(snapshot.nodeIds);
    final alive = await db.nodesDao.watchNodes().first;
    expect(alive.length, 3);
    expect((await db.elementsDao.watchLinks(proj).first).length, 1);
  });

  test('notes limit: exactly 50 per node accepted (D-007)', () async {
    final tab = await db.nodesDao
        .addNode(NodesCompanion.insert(name: 'T', type: NodeType.mainTab));
    for (var i = 0; i < 50; i++) {
      await db.elementsDao.addNote(NotesCompanion.insert(
          nodeId: tab, title: const Value(null), content: Value('note $i')));
    }
    expect(await db.elementsDao.countNotes(tab), 50);
  });

  test('export strips secrets (NFR-02)', () async {
    final tab = await db.nodesDao
        .addNode(NodesCompanion.insert(name: 'T', type: NodeType.mainTab));
    await db.elementsDao.addEmail(EmailsCompanion.insert(
        nodeId: tab,
        label: 'client mail',
        address: 'a@b.c',
        password: Value('SECRET123')));
    await db.elementsDao.addVariable(VariablesCompanion.insert(
        nodeId: tab,
        varKey: 'API_KEY',
        varValue: Value('v-999'),
        isSecret: const Value(true)));

    final data = await db.backupDao.exportJson();
    final encoded = jsonEncode(data);
    expect(encoded.contains('SECRET123'), isFalse);
    expect(encoded.contains('v-999'), isFalse);
    expect(((data['emails'] as List).first as Map).containsKey('password'),
        isFalse);
    expect((data['variables'] as List).isEmpty, isTrue);
  });

  test('import merge remaps parent/child ids (FR-02)', () async {
    final data = {
      'schemaVersion': 1,
      'nodes': [
        {'id': 1, 'parentId': null, 'name': 'Parent', 'type': 'mainTab', 'icon': 'layers', 'status': 'active', 'sortIndex': 0, 'createdAt': '2026-01-01T00:00:00.000'},
        {'id': 2, 'parentId': 1, 'name': 'Child', 'type': 'subTab', 'icon': 'folder', 'status': 'active', 'sortIndex': 0, 'createdAt': '2026-01-01T00:00:00.000'},
      ],
      'links': [],
      'notes': [],
      'emails': [],
      'subscriptions': [],
      'platforms': [],
      'variables': [],
      'alerts': [],
    };
    await db.backupDao.importJson(data, ImportStrategy.merge);

    final nodes = await db.nodesDao.watchNodes().first;
    expect(nodes.length, 2);
    final parent = nodes.firstWhere((n) => n.name == 'Parent');
    final child = nodes.firstWhere((n) => n.name == 'Child');
    expect(child.parentId, parent.id);
  });

  test('trash purge removes only past retention (D-010)', () async {
    final a = await db.nodesDao
        .addNode(NodesCompanion.insert(name: 'Old', type: NodeType.mainTab));
    final b = await db.nodesDao
        .addNode(NodesCompanion.insert(name: 'New', type: NodeType.mainTab));
    // simulate old deletion
    await (db.update(db.nodes)..where((n) => n.id.equals(a))).write(
        NodesCompanion(
            deletedAt: Value(DateTime.now()
                .subtract(const Duration(days: 40)))));
    await db.nodesDao.softDeleteSubtree(b);

    final purged = await db.nodesDao.purgeOldTrash(30);
    expect(purged, [a]);
    final alive = await db.nodesDao.trashedNodes();
    expect(alive.map((n) => n.id), [b]);
  });

  test('TreeState.search structural filters (FR-04)', () {
    Node node(int id, int? parent, String name, NodeType type) => Node(
        id: id,
        parentId: parent,
        name: name,
        type: type,
        icon: 'folder',
        status: NodeStatus.active,
        sortIndex: 0,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026));
    final state = TreeState([
      node(1, null, 'Work', NodeType.mainTab),
      node(2, 1, 'Client A', NodeType.subTab),
      node(3, 2, 'Apps', NodeType.section),
      node(4, 3, 'Website', NodeType.project),
      node(5, null, 'Personal', NodeType.mainTab),
    ]);
    expect(state.rootTabs.length, 2);
    expect(state.projectCount(1), 1);
    expect(state.descendantIds(1).length, 3);
    expect(state.breadcrumbOf(4).map((n) => n.name).toList(),
        ['Work', 'Client A', 'Apps', 'Website']);
    final filtered = state.search(
        tabId: 1, type: NodeType.project, query: 'web');
    expect(filtered.map((n) => n.id), [4]);
  });
}
