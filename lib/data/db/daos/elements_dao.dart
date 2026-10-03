part of '../app_database.dart';

/// CRUD for the 7 element types attached to nodes (FR-06 + templates).
@DriftAccessor(tables: [
  Links,
  Notes,
  Emails,
  Subscriptions,
  Platforms,
  Variables,
  Alerts,
])
class ElementsDao extends DatabaseAccessor<AppDatabase>
    with _$ElementsDaoMixin {
  ElementsDao(super.db);

  // ── Links ──────────────────────────────────────────────────────────
  Stream<List<Link>> watchLinks(int nodeId) =>
      (select(links)..where((l) => l.nodeId.equals(nodeId) & l.deletedAt.isNull()))
          .watch();

  Future<int> addLink(LinksCompanion e) => into(links).insert(e);

  Future<void> updateLink(int id, LinksCompanion e) =>
      (update(links)..where((l) => l.id.equals(id))).write(e);

  Future<void> softDeleteLink(int id) =>
      (update(links)..where((l) => l.id.equals(id)))
          .write(LinksCompanion(deletedAt: Value(DateTime.now())));

  Future<void> restoreLink(int id) =>
      (update(links)..where((l) => l.id.equals(id)))
          .write(LinksCompanion(deletedAt: const Value<DateTime?>(null)));

  // ── Notes (max 50 per node — D-007) ────────────────────────────────
  Stream<List<Note>> watchNotes(int nodeId) =>
      (select(notes)..where((n) => n.nodeId.equals(nodeId) & n.deletedAt.isNull()))
          .watch();

  Future<int> countNotes(int nodeId) async {
    final expr = notes.id.count();
    final q = selectOnly(notes)
      ..where(notes.nodeId.equals(nodeId) & notes.deletedAt.isNull())
      ..addColumns([expr]);
    final row = await q.getSingle();
    return row.read(expr) ?? 0;
  }

  Future<int> addNote(NotesCompanion e) => into(notes).insert(e);

  Future<void> updateNote(int id, NotesCompanion e) =>
      (update(notes)..where((n) => n.id.equals(id))).write(e);

  Future<void> softDeleteNote(int id) =>
      (update(notes)..where((n) => n.id.equals(id)))
          .write(NotesCompanion(deletedAt: Value(DateTime.now())));

  Future<void> restoreNote(int id) =>
      (update(notes)..where((n) => n.id.equals(id)))
          .write(NotesCompanion(deletedAt: const Value<DateTime?>(null)));

  // ── Registered emails ──────────────────────────────────────────────
  Stream<List<Email>> watchEmails(int nodeId) =>
      (select(emails)..where((e) => e.nodeId.equals(nodeId) & e.deletedAt.isNull()))
          .watch();

  Future<int> addEmail(EmailsCompanion e) => into(emails).insert(e);

  Future<void> updateEmail(int id, EmailsCompanion e) =>
      (update(emails)..where((e) => e.id.equals(id))).write(e);

  Future<void> softDeleteEmail(int id) =>
      (update(emails)..where((e) => e.id.equals(id)))
          .write(EmailsCompanion(deletedAt: Value(DateTime.now())));

  Future<void> restoreEmail(int id) =>
      (update(emails)..where((e) => e.id.equals(id)))
          .write(EmailsCompanion(deletedAt: const Value<DateTime?>(null)));

  // ── Subscriptions ──────────────────────────────────────────────────
  Stream<List<Subscription>> watchSubscriptions(int nodeId) =>
      (select(subscriptions)
            ..where((s) => s.nodeId.equals(nodeId) & s.deletedAt.isNull()))
          .watch();

  Future<int> addSubscription(SubscriptionsCompanion e) =>
      into(subscriptions).insert(e);

  Future<void> updateSubscription(int id, SubscriptionsCompanion e) =>
      (update(subscriptions)..where((s) => s.id.equals(id))).write(e);

  Future<void> softDeleteSubscription(int id) =>
      (update(subscriptions)..where((s) => s.id.equals(id)))
          .write(SubscriptionsCompanion(deletedAt: Value(DateTime.now())));

  Future<void> restoreSubscription(int id) =>
      (update(subscriptions)..where((s) => s.id.equals(id)))
          .write(SubscriptionsCompanion(deletedAt: const Value<DateTime?>(null)));

  // ── Publishing platforms ───────────────────────────────────────────
  Stream<List<PlatformRow>> watchPlatforms(int nodeId) =>
      (select(platforms)
            ..where((p) => p.nodeId.equals(nodeId) & p.deletedAt.isNull()))
          .watch();

  Future<int> addPlatform(PlatformsCompanion e) => into(platforms).insert(e);

  Future<void> updatePlatform(int id, PlatformsCompanion e) =>
      (update(platforms)..where((p) => p.id.equals(id))).write(e);

  Future<void> softDeletePlatform(int id) =>
      (update(platforms)..where((p) => p.id.equals(id)))
          .write(PlatformsCompanion(deletedAt: Value(DateTime.now())));

  Future<void> restorePlatform(int id) =>
      (update(platforms)..where((p) => p.id.equals(id)))
          .write(PlatformsCompanion(deletedAt: const Value<DateTime?>(null)));

  // ── Variables ──────────────────────────────────────────────────────
  Stream<List<VariableRow>> watchVariables(int nodeId) =>
      (select(variables)
            ..where((v) => v.nodeId.equals(nodeId) & v.deletedAt.isNull()))
          .watch();

  Future<int> addVariable(VariablesCompanion e) => into(variables).insert(e);

  Future<void> updateVariable(int id, VariablesCompanion e) =>
      (update(variables)..where((v) => v.id.equals(id))).write(e);

  Future<void> softDeleteVariable(int id) =>
      (update(variables)..where((v) => v.id.equals(id)))
          .write(VariablesCompanion(deletedAt: Value(DateTime.now())));

  Future<void> restoreVariable(int id) =>
      (update(variables)..where((v) => v.id.equals(id)))
          .write(VariablesCompanion(deletedAt: const Value<DateTime?>(null)));

  // ── Alerts ─────────────────────────────────────────────────────────
  Stream<List<Alert>> watchAlerts(int nodeId) =>
      (select(alerts)..where((a) => a.nodeId.equals(nodeId) & a.deletedAt.isNull()))
          .watch();

  Stream<List<Alert>> watchAllAlerts() =>
      (select(alerts)..where((a) => a.deletedAt.isNull())).watch();

  Future<List<Alert>> allEnabledAlerts() =>
      (select(alerts)..where((a) => a.enabled.equals(true) & a.deletedAt.isNull()))
          .get();

  Future<Alert?> getAlert(int id) =>
      (select(alerts)..where((a) => a.id.equals(id))).getSingleOrNull();

  Future<int> addAlert(AlertsCompanion e) => into(alerts).insert(e);

  Future<void> updateAlert(int id, AlertsCompanion e) =>
      (update(alerts)..where((a) => a.id.equals(id))).write(e);

  Future<void> softDeleteAlert(int id) =>
      (update(alerts)..where((a) => a.id.equals(id)))
          .write(AlertsCompanion(deletedAt: Value(DateTime.now())));

  Future<void> restoreAlert(int id) =>
      (update(alerts)..where((a) => a.id.equals(id)))
          .write(AlertsCompanion(deletedAt: const Value<DateTime?>(null)));

  Future<void> markNotified(int id) =>
      (update(alerts)..where((a) => a.id.equals(id)))
          .write(AlertsCompanion(notified: const Value(true)));
}
