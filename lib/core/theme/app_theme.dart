import 'package:flutter/material.dart';

/// Semantic colors for task status and priority used across the app.
class AppStatusColors extends ThemeExtension<AppStatusColors> {
  const AppStatusColors({
    required this.open,
    required this.inProgress,
    required this.done,
    required this.highPriority,
    required this.mediumPriority,
    required this.lowPriority,
  });

  final Color open;
  final Color inProgress;
  final Color done;
  final Color highPriority;
  final Color mediumPriority;
  final Color lowPriority;

  @override
  ThemeExtension<AppStatusColors> copyWith({
    Color? open,
    Color? inProgress,
    Color? done,
    Color? highPriority,
    Color? mediumPriority,
    Color? lowPriority,
  }) {
    return AppStatusColors(
      open: open ?? this.open,
      inProgress: inProgress ?? this.inProgress,
      done: done ?? this.done,
      highPriority: highPriority ?? this.highPriority,
      mediumPriority: mediumPriority ?? this.mediumPriority,
      lowPriority: lowPriority ?? this.lowPriority,
    );
  }

  @override
  ThemeExtension<AppStatusColors> lerp(
    ThemeExtension<AppStatusColors>? other,
    double t,
  ) {
    if (other is! AppStatusColors) return this;
    return AppStatusColors(
      open: Color.lerp(open, other.open, t)!,
      inProgress: Color.lerp(inProgress, other.inProgress, t)!,
      done: Color.lerp(done, other.done, t)!,
      highPriority: Color.lerp(highPriority, other.highPriority, t)!,
      mediumPriority: Color.lerp(mediumPriority, other.mediumPriority, t)!,
      lowPriority: Color.lerp(lowPriority, other.lowPriority, t)!,
    );
  }

  static const AppStatusColors light = AppStatusColors(
    open: Colors.blue,
    inProgress: Colors.orange,
    done: Colors.green,
    highPriority: Colors.red,
    mediumPriority: Colors.orange,
    lowPriority: Colors.green,
  );

  static const AppStatusColors dark = AppStatusColors(
    open: Color(0xFF64B5F6),
    inProgress: Color(0xFFFFB74D),
    done: Color(0xFF81C784),
    highPriority: Color(0xFFE57373),
    mediumPriority: Color(0xFFFFB74D),
    lowPriority: Color(0xFF81C784),
  );
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    const Color surfaceBg = Color(0xFFF5F5F5); // grey.shade100
    const Color surfaceCard = Color(0xFFFFFFFF);
    const Color onSurfacePrimary = Color(0xFF212121); // grey.shade900
    const Color onSurfaceSecondary = Color(0xFF757575); // grey.shade600
    const Color onSurfaceTertiary = Color(0xFF616161); // grey.shade700
    const Color outline = Color(0xFF9E9E9E); // grey
    const Color primaryDark = Color(0xFF212121); // grey.shade900
    const Color onPrimary = Color(0xFFFFFFFF);
    const Color error = Color(0xFFE53935); // red.shade400-ish
    const Color errorContainer = Color(0xFFFFEBEE); // red.shade50

    return ThemeData(
      useMaterial3: true,
      colorScheme:const ColorScheme.light(
        primary: primaryDark,
        onPrimary: onPrimary,
        surface: surfaceBg,
        onSurface: onSurfacePrimary,
        surfaceContainerHighest: surfaceCard,
        onSurfaceVariant: onSurfaceSecondary,
        outline: outline,
        outlineVariant: onSurfaceTertiary,
        error: error,
        onError: onPrimary,
        errorContainer: errorContainer,
        onErrorContainer: error,
      ),
      scaffoldBackgroundColor: surfaceBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceBg,
        foregroundColor: onSurfacePrimary,
        elevation: 0,
        iconTheme: IconThemeData(color: onSurfacePrimary),
        titleTextStyle: TextStyle(
          color: onSurfacePrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark,
          foregroundColor: onPrimary,
          elevation: 0,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        AppStatusColors.light,
      ],
    );
  }

  static ThemeData get dark {
    const Color surfaceBg = Color(0xFF121212);
    const Color surfaceCard = Color(0xFF1E1E1E);
    const Color onSurfacePrimary = Color(0xFFE1E1E1);
    const Color onSurfaceSecondary = Color(0xFFB0B0B0);
    const Color onSurfaceTertiary = Color(0xFF9E9E9E);
    const Color outline = Color(0xFF6E6E6E);
    const Color primaryLight = Color(0xFFE1E1E1);
    const Color onPrimary = Color(0xFF121212);
    const Color error = Color(0xFFCF6679);
    const Color errorContainer = Color(0xFF93000A);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryLight,
        onPrimary: onPrimary,
        surface: surfaceBg,
        onSurface: onSurfacePrimary,
        surfaceContainerHighest: surfaceCard,
        onSurfaceVariant: onSurfaceSecondary,
        outline: outline,
        outlineVariant: onSurfaceTertiary,
        error: error,
        onError: Color(0xFF000000),
        errorContainer: errorContainer,
        onErrorContainer: Color(0xFFFFDAD6),
      ),
      scaffoldBackgroundColor: surfaceBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceBg,
        foregroundColor: onSurfacePrimary,
        elevation: 0,
        iconTheme: IconThemeData(color: onSurfacePrimary),
        titleTextStyle: TextStyle(
          color: onSurfacePrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLight,
          foregroundColor: onPrimary,
          elevation: 0,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shadowColor: Color(0x40000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        AppStatusColors.dark,
      ],
    );
  }
}
