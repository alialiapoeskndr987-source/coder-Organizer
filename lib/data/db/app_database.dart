import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/category_catalog.dart';
import '../../core/models/enums.dart';
import 'tables.dart';

part 'app_database.g.dart';
part 'daos/nodes_dao.dart';
part 'daos/elements_dao.dart';
part 'daos/backup_dao.dart';

@DriftDatabase(
  tables: [
    Nodes,
    Profiles,
    Categories,
    Links,
    Notes,
    Emails,
    Subscriptions,
    Platforms,
    Variables,
    Alerts,
    OpenLogs,
    AppSettings,
  ],
  daos: [NodesDao, ElementsDao, BackupDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// In-memory constructor for tests.
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await _seedV2();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v2.0 (D-021/D-023): profiles + category catalog.
            await m.createTable(profiles);
            await m.createTable(categories);
            await m.addColumn(nodes, nodes.profileId);
            await m.addColumn(nodes, nodes.categoryId);
            // Single-user data becomes the default profile (#1).
            await into(profiles).insert(
              ProfilesCompanion.insert(name: 'Default'),
            );
            await customStatement(
                'UPDATE nodes SET profile_id = 1 WHERE profile_id IS NULL');
            await _seedCategories();
          }
        },
      );

  Future<void> _seedV2() async {
    await into(profiles).insert(ProfilesCompanion.insert(name: 'Default'));
    await _seedCategories();
  }

  /// Seeds the 50-entry catalog: 40 fixed global rows (profileId = null) +
  /// 10 editable rows for profile #1. New profiles seed their own 10.
  Future<void> _seedCategories() async {
    for (var i = 1; i <= CategoryCatalog.fixedCount; i++) {
      await into(categories).insert(
        CategoriesCompanion.insert(
          profileId: const Value(null),
          number: i,
          name: Value(CategoryCatalog.fixed[i - 1].$1),
          isEditable: const Value(false),
        ),
      );
    }
    await seedEditableCategories(1);
  }

  /// v2.0 — the 10 editable catalog entries (41..50) for one profile.
  Future<void> seedEditableCategories(int profileId) async {
    for (var i = CategoryCatalog.fixedCount + 1; i <= CategoryCatalog.totalCount; i++) {
      await into(categories).insert(
        CategoriesCompanion.insert(
          profileId: Value(profileId),
          number: i,
          isEditable: const Value(true),
        ),
      );
    }
  }

  // ── Settings ────────────────────────────────────────────────────────
  Future<String?> getSetting(String key) async {
    final row = await (select(appSettings)..where((s) => s.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> setSetting(String key, String value) =>
      into(appSettings).insertOnConflictUpdate(
        AppSettingsCompanion.insert(key: key, value: value),
      );

  Stream<String?> watchSetting(String key) =>
      (select(appSettings)..where((s) => s.key.equals(key)))
          .watchSingleOrNull()
          .map((r) => r?.value);

  // ── Profiles (D-021/D-024) ──────────────────────────────────────────
  Stream<List<Profile>> watchProfiles({bool includeDeleted = false}) {
    final q = select(profiles);
    if (!includeDeleted) q.where((pr) => pr.deletedAt.isNull());
    q.orderBy([
      (pr) => OrderingTerm.asc(pr.sortIndex),
      (pr) => OrderingTerm.asc(pr.id),
    ]);
    return q.watch();
  }

  Future<List<Profile>> trashedProfiles() =>
      (select(profiles)..where((pr) => pr.deletedAt.isNotNull())).get();

  Future<int> activeProfileCount() async {
    final rows = await (select(profiles)
          ..where((pr) => pr.deletedAt.isNull()))
        .get();
    return rows.length;
  }

  Future<Profile?> getProfile(int id) =>
      (select(profiles)..where((pr) => pr.id.equals(id))).getSingleOrNull();

  Future<int> createProfile(String name) async {
    final id = await into(profiles).insert(
      ProfilesCompanion.insert(name: name),
    );
    await seedEditableCategories(id);
    return id;
  }

  Future<void> renameProfile(int id, String name) =>
      (update(profiles)..where((pr) => pr.id.equals(id)))
          .write(ProfilesCompanion(name: Value(name)));

  /// v2.0 — renames the seeded 'Default' profile to the device language,
  /// exactly once (called from main() bootstrap).
  Future<void> renameDefaultProfileIfNeeded(String localized) async {
    final named = await getSetting('default_profile_named');
    if (named == '1') return;
    final p = await getProfile(1);
    if (p != null && p.name == 'Default' && localized.isNotEmpty) {
      await renameProfile(1, localized);
    }
    await setSetting('default_profile_named', '1');
  }

  /// Soft-delete a profile + all its nodes/elements (profile trash, D-024).
  Future<void> softDeleteProfile(int id) async {
    final now = DateTime.now();
    await (update(profiles)..where((pr) => pr.id.equals(id)))
        .write(ProfilesCompanion(deletedAt: Value(now)));
    final nodeIds = await (select(nodes)
          ..where((n) => n.profileId.equals(id)))
        .map((n) => n.id)
        .get();
    if (nodeIds.isEmpty) return;
    await (update(nodes)..where((n) => n.id.isIn(nodeIds)))
        .write(NodesCompanion(deletedAt: Value(now)));
    await (update(links)..where((l) => l.nodeId.isIn(nodeIds)))
        .write(LinksCompanion(deletedAt: Value(now)));
    await (update(notes)..where((n) => n.nodeId.isIn(nodeIds)))
        .write(NotesCompanion(deletedAt: Value(now)));
    await (update(emails)..where((e) => e.nodeId.isIn(nodeIds)))
        .write(EmailsCompanion(deletedAt: Value(now)));
    await (update(subscriptions)..where((s) => s.nodeId.isIn(nodeIds)))
        .write(SubscriptionsCompanion(deletedAt: Value(now)));
    await (update(platforms)..where((p) => p.nodeId.isIn(nodeIds)))
        .write(PlatformsCompanion(deletedAt: Value(now)));
    await (update(variables)..where((v) => v.nodeId.isIn(nodeIds)))
        .write(VariablesCompanion(deletedAt: Value(now)));
    await (update(alerts)..where((a) => a.nodeId.isIn(nodeIds)))
        .write(AlertsCompanion(deletedAt: Value(now)));
  }

  /// Restore a soft-deleted profile and its content.
  Future<void> restoreProfile(int id) async {
    await (update(profiles)..where((pr) => pr.id.equals(id)))
        .write(ProfilesCompanion(deletedAt: const Value<DateTime?>(null)));
    final nodeIds = await (select(nodes)
          ..where((n) => n.profileId.equals(id)))
        .map((n) => n.id)
        .get();
    if (nodeIds.isEmpty) return;
    await (update(nodes)..where((n) => n.id.isIn(nodeIds)))
        .write(NodesCompanion(deletedAt: const Value<DateTime?>(null)));
    await (update(links)..where((l) => l.nodeId.isIn(nodeIds)))
        .write(LinksCompanion(deletedAt: const Value<DateTime?>(null)));
    await (update(notes)..where((n) => n.nodeId.isIn(nodeIds)))
        .write(NotesCompanion(deletedAt: const Value<DateTime?>(null)));
    await (update(emails)..where((e) => e.nodeId.isIn(nodeIds)))
        .write(EmailsCompanion(deletedAt: const Value<DateTime?>(null)));
    await (update(subscriptions)..where((s) => s.nodeId.isIn(nodeIds)))
        .write(SubscriptionsCompanion(deletedAt: const Value<DateTime?>(null)));
    await (update(platforms)..where((p) => p.nodeId.isIn(nodeIds)))
        .write(PlatformsCompanion(deletedAt: const Value<DateTime?>(null)));
    await (update(variables)..where((v) => v.nodeId.isIn(nodeIds)))
        .write(VariablesCompanion(deletedAt: const Value<DateTime?>(null)));
    await (update(alerts)..where((a) => a.nodeId.isIn(nodeIds)))
        .write(AlertsCompanion(deletedAt: const Value<DateTime?>(null)));
  }

  /// Permanent removal: purge nodes (with elements), its catalog entries
  /// and the profile row itself.
  Future<void> permanentlyDeleteProfile(int id) async {
    final nodeIds = await (select(nodes)
          ..where((n) => n.profileId.equals(id)))
        .map((n) => n.id)
        .get();
    if (nodeIds.isNotEmpty) await nodesDao.permanentlyDeleteNodes(nodeIds);
    await (delete(categories)..where((c) => c.profileId.equals(id))).go();
    await (delete(profiles)..where((pr) => pr.id.equals(id))).go();
  }

  // ── Categories (D-023) ──────────────────────────────────────────────
  /// Fixed global entries (profileId null) + this profile's editable rows.
  Stream<List<CategoryRow>> watchCategories(int profileId) {
    final q = select(categories)
      ..where((c) => c.profileId.isNull() | c.profileId.equals(profileId));
    q.orderBy([(c) => OrderingTerm.asc(c.number)]);
    return q.watch();
  }

  Future<List<CategoryRow>> categoriesForProfile(int profileId) {
    final q = select(categories)
      ..where((c) => c.profileId.isNull() | c.profileId.equals(profileId));
    q.orderBy([(c) => OrderingTerm.asc(c.number)]);
    return q.get();
  }

  Future<void> renameCategory(int id, String name) =>
      (update(categories)..where((c) => c.id.equals(id)))
          .write(CategoriesCompanion(name: Value(name)));

  /// Resolves an imported category number (1..50) to a local row id,
  /// preferring the current profile's editable row for 41..50.
  Future<int?> categoryIdByNumber(int number, int profileId) async {
    final q = select(categories)
      ..where((c) =>
          c.number.equals(number) &
          (c.profileId.isNull() | c.profileId.equals(profileId)))
      ..limit(1);
    final row = await q.getSingleOrNull();
    return row?.id;
  }

  // ── Open logs (FR-05) ───────────────────────────────────────────────
  Future<void> logOpen(int nodeId) => into(openLogs).insert(
        OpenLogsCompanion.insert(nodeId: nodeId, openedAt: Value(DateTime.now())),
      );

  Future<void> touchOpened(int nodeId) =>
      (update(nodes)..where((n) => n.id.equals(nodeId))).write(
        NodesCompanion(lastOpenedAt: Value(DateTime.now())),
      );

  Future<Map<int, int>> visitCountsSince(DateTime since) async {
    final rows = await (select(openLogs)
          ..where((l) => l.openedAt.isBiggerThanValue(since)))
        .get();
    final counts = <int, int>{};
    for (final r in rows) {
      counts[r.nodeId] = (counts[r.nodeId] ?? 0) + 1;
    }
    return counts;
  }

  Future<void> pruneOpenLogs({int keepDays = 14}) async {
    final cutoff = DateTime.now().subtract(Duration(days: keepDays));
    await (delete(openLogs)..where((l) => l.openedAt.isSmallerThanValue(cutoff)))
        .go();
  }
}

/// Snapshot captured when soft-deleting a subtree — enables instant undo (D-010).
class DeleteSnapshot {
  final List<int> nodeIds;
  final DateTime deletedAt;
  const DeleteSnapshot({required this.nodeIds, required this.deletedAt});
}

LazyDatabase _openConnection() => LazyDatabase(() async {
      final dir = await getApplicationDocumentsDirectory();
      await Directory(dir.path).create(recursive: true);
      final file = File(p.join(dir.path, 'coder_organizer.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
