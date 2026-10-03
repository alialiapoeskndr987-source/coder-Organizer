import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';
import 'core_providers.dart';
import '../data/db/app_database.dart';

// ── Theme (FR-02 / D-008) — instant apply + persistence ──────────────
class ThemeController extends StateNotifier<AppTheme> {
  final AppDatabase _db;
  ThemeController(this._db) : super(AppTheme.programmerBlue) {
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

// ── Locale (NFR-06 / D-012): null = system default (English) ─────────
class LocaleController extends StateNotifier<Locale?> {
  final AppDatabase _db;
  LocaleController(this._db) : super(null) {
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
