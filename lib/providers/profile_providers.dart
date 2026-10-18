import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/app_database.dart';
import 'core_providers.dart';

// ── v2.0 profiles (D-021/D-024) ─────────────────────────────────────────

/// The active workspace. Overridden in main() with the persisted value so
/// the very first frame already renders the right profile's data.
class CurrentProfileController extends StateNotifier<int> {
  final AppDatabase _db;
  CurrentProfileController(this._db, int initial) : super(initial);

  Future<void> switchTo(int id) async {
    state = id;
    await _db.setSetting('current_profile_id', '$id');
  }
}

final currentProfileIdProvider =
    StateNotifierProvider<CurrentProfileController, int>((ref) {
  return CurrentProfileController(ref.watch(appDatabaseProvider), 1);
});

final profilesProvider = StreamProvider<List<Profile>>((ref) {
  return ref.watch(appDatabaseProvider).watchProfiles();
});

/// v2.0 (D-023) — the 50-entry catalog for one profile:
/// 40 fixed global rows + this profile's 10 editable rows.
final categoriesProvider =
    StreamProvider.family<List<CategoryRow>, int>((ref, profileId) {
  return ref.watch(appDatabaseProvider).watchCategories(profileId);
});

final trashedProfilesProvider = FutureProvider<List<Profile>>((ref) async {
  // Rebuilt on demand via ref.invalidateSelf from the trash UI.
  return ref.watch(appDatabaseProvider).trashedProfiles();
});

class ProfileActions {
  final Ref _ref;
  ProfileActions(this._ref);

  AppDatabase get _db => _ref.read(appDatabaseProvider);
  int get currentId => _ref.read(currentProfileIdProvider);

  Future<int> create(String name) async {
    final id = await _db.createProfile(name);
    return id;
  }

  Future<void> rename(int id, String name) => _db.renameProfile(id, name);

  /// Delete to the profile trash (D-024). If the deleted profile is the
  /// current one, switch to the first remaining profile.
  Future<void> deleteToTrash(int id) async {
    await _db.softDeleteProfile(id);
    if (currentId == id) {
      final remaining = await _db.watchProfiles().first;
      final next =
          remaining.isEmpty ? null : remaining.first;
      if (next != null) await switchTo(next.id);
    }
  }

  Future<void> restore(int id) async {
    await _db.restoreProfile(id);
    await switchTo(id);
  }

  Future<void> deleteForever(int id) async {
    await _db.permanentlyDeleteProfile(id);
    if (currentId == id) {
      final remaining = await _db.watchProfiles().first;
      final next = remaining.isEmpty ? 1 : remaining.first.id;
      await switchTo(next);
    }
  }

  Future<void> emptyTrash() async {
    final trashed = await _db.trashedProfiles();
    for (final p in trashed) {
      await _db.permanentlyDeleteProfile(p.id);
    }
  }

  Future<void> switchTo(int id) =>
      _ref.read(currentProfileIdProvider.notifier).switchTo(id);
}

final profileActionsProvider =
    Provider<ProfileActions>((ref) => ProfileActions(ref));

/// Name column update helper (kept for future profile editing UIs).
NodesCompanion profileNodePatch({int? categoryId}) =>
    NodesCompanion(categoryId: Value(categoryId));
