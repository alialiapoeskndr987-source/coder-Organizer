import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/models/enums.dart';
import '../core/theme/app_theme.dart';
import 'core_providers.dart';
import '../data/db/app_database.dart';

// ── Theme (FR-02 / D-008) — instant apply + persistence ─────────────
// `initial` is preloaded in main() so the first frame already carries the
// saved theme (no flash of the default on slow storage).
class ThemeController extends StateNotifier<AppTheme> {
  final AppDatabase _db;
  ThemeController(this._db, [AppTheme? initial])
      : super(initial ?? AppTheme.programmerBlue) {
    _load();
  }

  Future<void> _load() async {
    final v = await _db.getSetting('theme');
    final idx = int.tryParse(v ?? '') ?? 0;
    state = AppTheme
        .values[idx.clamp(0, AppTheme.values.length - 1)];
  }

  Future<void> setTheme(AppTheme t) async {
    state = t;
    await _db.setSetting('theme', '${t.index}');
  }
}

final themeProvider =
    StateNotifierProvider<ThemeController, AppTheme>((ref) {
  final c = ThemeController(ref.watch(appDatabaseProvider));
  ref.onDispose(() {});
  return c;
});

// ── Locale (NFR-06 / D-012) ─────────────────────────────────────────────
// null = follow the DEVICE language (standard behavior): with no explicit
// choice saved, MaterialApp resolves the system locale, so an Arabic phone
// gets Arabic on first launch. Once the user picks a language it is saved
// and `initial` (preloaded in main()) applies it from the very first frame
// — no system-language flash on subsequent starts.
class LocaleController extends StateNotifier<Locale?> {
  final AppDatabase _db;
  LocaleController(this._db, [Locale? initial]) : super(initial) {
    _load();
  }

  Future<void> _load() async {
    final v = await _db.getSetting('locale');
    if (v != null && v.isNotEmpty) state = Locale(v);
  }

  Future<void> setLocale(Locale? l) async {
    state = l;
    await _db.setSetting('locale', l?.languageCode ?? '');
  }
}

final localeProvider =
    StateNotifierProvider<LocaleController, Locale?>((ref) {
  final c = LocaleController(ref.watch(appDatabaseProvider));
  ref.onDispose(() {});
  return c;
});

// ── Main title (FR-02): free text, max 60 chars, shown on home header ─
class MainTitleController extends StateNotifier<String> {
  final AppDatabase _db;
  MainTitleController(this._db) : super('') {
    _load();
  }

  Future<void> _load() async =>
      state = await _db.getSetting('main_title') ?? '';

  Future<void> setTitle(String title) async {
    state = title;
    await _db.setSetting('main_title', title);
  }
}

final mainTitleProvider =
    StateNotifierProvider<MainTitleController, String>((ref) {
  final c = MainTitleController(ref.watch(appDatabaseProvider));
  ref.onDispose(() {});
  return c;
});

// ── Node sort (v1.23): tree browser + search results, persisted ─────
class NodeSortController extends StateNotifier<NodeSort> {
  final AppDatabase _db;
  NodeSortController(this._db) : super(NodeSort.manual) {
    _load();
  }

  Future<void> _load() async {
    final v = await _db.getSetting('node_sort');
    final idx = int.tryParse(v ?? '') ?? 0;
    state =
        NodeSort.values[idx.clamp(0, NodeSort.values.length - 1)];
  }

  Future<void> setSort(NodeSort s) async {
    state = s;
    await _db.setSetting('node_sort', '${s.index}');
  }
}

final nodeSortProvider =
    StateNotifierProvider<NodeSortController, NodeSort>((ref) {
  final c = NodeSortController(ref.watch(appDatabaseProvider));
  ref.onDispose(() {});
  return c;
});

// ── Home display preferences (v1.23): stats + grid density ──────────
class HomePrefs {
  final bool showStats;
  final bool compactGrid;
  const HomePrefs({this.showStats = true, this.compactGrid = false});
}

class HomePrefsController extends StateNotifier<HomePrefs> {
  final AppDatabase _db;
  HomePrefsController(this._db) : super(const HomePrefs()) {
    _load();
  }

  Future<void> _load() async {
    final stats = await _db.getSetting('show_stats');
    final compact = await _db.getSetting('compact_grid');
    state = HomePrefs(
      showStats: stats != '0',
      compactGrid: compact == '1',
    );
  }

  Future<void> setShowStats(bool v) async {
    state = HomePrefs(showStats: v, compactGrid: state.compactGrid);
    await _db.setSetting('show_stats', v ? '1' : '0');
  }

  Future<void> setCompactGrid(bool v) async {
    state = HomePrefs(showStats: state.showStats, compactGrid: v);
    await _db.setSetting('compact_grid', v ? '1' : '0');
  }
}

final homePrefsProvider =
    StateNotifierProvider<HomePrefsController, HomePrefs>((ref) {
  final c = HomePrefsController(ref.watch(appDatabaseProvider));
  ref.onDispose(() {});
  return c;
});
