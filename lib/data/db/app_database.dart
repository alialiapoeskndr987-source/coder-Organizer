import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/models/enums.dart';
import 'tables.dart';

part 'app_database.g.dart';
part 'daos/nodes_dao.dart';
part 'daos/elements_dao.dart';
part 'daos/backup_dao.dart';

@DriftDatabase(
  tables: [
    Nodes,
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
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
      );

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
