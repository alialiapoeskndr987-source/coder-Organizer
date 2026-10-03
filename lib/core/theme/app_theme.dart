import 'package:flutter/material.dart';

/// The 8 approved themes (D-008) with the exact colors from SRS section 6.
/// Single-style mode: 4 light + 4 dark presets.
enum AppTheme {
  programmerBlue,
  terminalGreen,
  neonPurple,
  sunsetOrange,
  nightCrimson,
  oceanTeal,
  metalSilver,
  midnightGold,
}

class ThemePreset {
  final int primary;
  final int accent;
  final int background;
  final Brightness brightness;
  const ThemePreset(this.primary, this.accent, this.background, this.brightness);
}

const Map<AppTheme, ThemePreset> kThemePresets = {
  AppTheme.programmerBlue: ThemePreset(0xFF2563EB, 0xFF0EA5E9, 0xFFF8FAFC, Brightness.light),
  AppTheme.terminalGreen: ThemePreset(0xFF10B981, 0xFF84CC16, 0xFF0B1F14, Brightness.dark),
  AppTheme.neonPurple: ThemePreset(0xFF8B5CF6, 0xFFEC4899, 0xFF17102B, Brightness.dark),
  AppTheme.sunsetOrange: ThemePreset(0xFFEA580C, 0xFFF59E0B, 0xFFFFF7ED, Brightness.light),
  AppTheme.nightCrimson: ThemePreset(0xFFEF4444, 0xFFF87171, 0xFF1F0808, Brightness.dark),
  AppTheme.oceanTeal: ThemePreset(0xFF0D9488, 0xFF0284C7, 0xFFF0FDFA, Brightness.light),
  AppTheme.metalSilver: ThemePreset(0xFF475569, 0xFF64748B, 0xFFF4F6F8, Brightness.light),
  AppTheme.midnightGold: ThemePreset(0xFFD4A017, 0xFFFDE047, 0xFF171310, Brightness.dark),
};

extension AppThemeX on AppTheme {
  ThemePreset get preset => kThemePresets[this]!;
  bool get isDark => preset.brightness == Brightness.dark;
  String get themeKey => 'theme${index + 1}';

  ThemeData material() {
    final p = preset;
    final light = p.brightness == Brightness.light;
    final bg = Color(p.background);
    final primary = Color(p.primary);
    final accent = Color(p.accent);
    final onSurface = light ? const Color(0xFF111827) : const Color(0xFFE5E7EB);
    final surfaceHigh = Color.lerp(bg, light ? Colors.black : Colors.white, 0.06)!;
    final surface = Color.lerp(bg, light ? Colors.black : Colors.white, 0.04)!;
    final onContainer = light ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final scheme = ColorScheme(
      brightness: p.brightness,
      primary: primary,
      onPrimary: light ? Colors.white : Colors.black,
      secondary: accent,
      onSecondary: light ? Colors.white : Colors.black,
      error: light ? const Color(0xFFB91C1C) : const Color(0xFFFCA5A5),
      onError: light ? Colors.white : Colors.black,
      surface: surface,
      onSurface: onSurface,
      onSurfaceVariant: light ? const Color(0xFF475569) : const Color(0xFF9CA3AF),
      outline: light ? const Color(0xFFCBD5E1) : const Color(0xFF374151),
      surfaceContainerHighest: surfaceHigh,
      surfaceContainer: surface,
      primaryContainer: Color.lerp(bg, primary, 0.25)!,
      onPrimaryContainer: onContainer,
      secondaryContainer: Color.lerp(bg, accent, 0.25)!,
      onSecondaryContainer: onContainer,
      inverseSurface: light ? const Color(0xFF111827) : const Color(0xFFF8FAFC),
      onInverseSurface: light ? const Color(0xFFF8FAFC) : const Color(0xFF111827),
      surfaceTint: primary,
    );
    final radius = BorderRadius.circular(12);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surfaceHigh,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.5)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceHigh,
        border: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: scheme.outline)),
        enabledBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: scheme.outline)),
        focusedBorder: OutlineInputBorder(borderRadius: radius, borderSide: BorderSide(color: primary, width: 2)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: radius), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: radius), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: scheme.outline.withValues(alpha: 0.6)),
        backgroundColor: surfaceHigh,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
        shape: RoundedRectangleBorder(borderRadius: radius),
      ),
      dividerTheme: DividerThemeData(color: scheme.outline.withValues(alpha: 0.4)),
      listTileTheme: ListTileThemeData(shape: RoundedRectangleBorder(borderRadius: radius)),
      navigationBarTheme: NavigationBarThemeData(backgroundColor: surfaceHigh, indicatorColor: scheme.primaryContainer),
      fontFamilyFallback: const ['Noto Sans', 'Noto Sans Arabic', 'Roboto'],
    );
  }
}
