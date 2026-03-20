import 'package:flutter/material.dart';

import 'app_tokens.dart';


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

  /// Returns [AppStatusColors] from theme, or light/dark default if extension is missing.
  static AppStatusColors of(BuildContext context) {
    return Theme.of(context).extension<AppStatusColors>() ??
        (Theme.of(context).brightness == Brightness.dark ? dark : light);
  }
}

class AppTheme {
  AppTheme._();

  /// TextTheme built from [AppTokens]. Pass [onSurface] and [onSurfaceVariant]
  /// so light/dark each get correct contrast.
  static TextTheme textTheme({
    required Color onSurface,
    required Color onSurfaceVariant,
  }) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: AppTokens.fontSizeDisplay,
        fontWeight: AppTokens.fontWeightBold,
        color: onSurface,
      ),
      displayMedium: TextStyle(
        fontSize: AppTokens.fontSize3xl,
        fontWeight: AppTokens.fontWeightBold,
        color: onSurface,
      ),
      displaySmall: TextStyle(
        fontSize: AppTokens.fontSize2xl,
        fontWeight: AppTokens.fontWeightBold,
        color: onSurface,
      ),
      headlineLarge: TextStyle(
        fontSize: AppTokens.fontSize2xl,
        fontWeight: AppTokens.fontWeightBold,
        color: onSurface,
      ),
      headlineMedium: TextStyle(
        fontSize: AppTokens.fontSizeXl,
        fontWeight: AppTokens.fontWeightBold,
        color: onSurface,
      ),
      headlineSmall: TextStyle(
        fontSize: AppTokens.fontSizeLg,
        fontWeight: AppTokens.fontWeightSemiBold,
        color: onSurface,
      ),
      titleLarge: TextStyle(
        fontSize: AppTokens.fontSizeLg,
        fontWeight: AppTokens.fontWeightBold,
        color: onSurface,
      ),
      titleMedium: TextStyle(
        fontSize: AppTokens.fontSizeMd,
        fontWeight: AppTokens.fontWeightSemiBold,
        color: onSurface,
      ),
      titleSmall: TextStyle(
        fontSize: AppTokens.fontSizeMd,
        fontWeight: AppTokens.fontWeightMedium,
        color: onSurface,
      ),
      bodyLarge: TextStyle(
        fontSize: AppTokens.fontSizeLg,
        fontWeight: AppTokens.fontWeightRegular,
        color: onSurface,
      ),
      bodyMedium: TextStyle(
        fontSize: AppTokens.fontSizeMd,
        fontWeight: AppTokens.fontWeightRegular,
        color: onSurface,
      ),
      bodySmall: TextStyle(
        fontSize: AppTokens.fontSizeSm,
        fontWeight: AppTokens.fontWeightRegular,
        color: onSurfaceVariant,
      ),
      labelLarge: TextStyle(
        fontSize: AppTokens.fontSizeMd,
        fontWeight: AppTokens.fontWeightMedium,
        color: onSurface,
      ),
      labelMedium: TextStyle(
        fontSize: AppTokens.fontSizeSm,
        fontWeight: AppTokens.fontWeightMedium,
        color: onSurfaceVariant,
      ),
      labelSmall: TextStyle(
        fontSize: AppTokens.fontSizeXs,
        fontWeight: AppTokens.fontWeightMedium,
        color: onSurfaceVariant,
      ),
    );
  }

  static ThemeData get light {
    const Color surfaceBg = Color(0xFFF5F5F5);
    const Color surfaceCard = Color(0xFFFFFFFF);
    const Color onSurfacePrimary = Color(0xFF212121);
    const Color onSurfaceSecondary = Color(0xFF757575);
    const Color onSurfaceTertiary = Color(0xFF616161);
    const Color outline = Color(0xFF9E9E9E);
    const Color primaryDark = Color(0xFF212121);
    const Color onPrimary = Color(0xFFFFFFFF);
    const Color error = Color(0xFFE53935);
    const Color errorContainer = Color(0xFFFFEBEE);

    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
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
      textTheme: textTheme(
        onSurface: onSurfacePrimary,
        onSurfaceVariant: onSurfaceSecondary,
      ),
      scaffoldBackgroundColor: surfaceBg,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceBg,
        foregroundColor: onSurfacePrimary,
        elevation: 0,
        iconTheme: const IconThemeData(color: onSurfacePrimary),
        titleTextStyle: textTheme(
          onSurface: onSurfacePrimary,
          onSurfaceVariant: onSurfaceSecondary,
        ).titleLarge?.copyWith(fontSize: AppTokens.fontSize2xl),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark,
          foregroundColor: onPrimary,
          elevation: 2,
          minimumSize: const Size.fromHeight(AppTokens.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shadowColor: Colors.black.withValues(alpha: AppTokens.shadowAlpha),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTokens.spacingLg,
          vertical: AppTokens.spacingMd,
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
      textTheme: textTheme(
        onSurface: onSurfacePrimary,
        onSurfaceVariant: onSurfaceSecondary,
      ),
      scaffoldBackgroundColor: surfaceBg,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceBg,
        foregroundColor: onSurfacePrimary,
        elevation: 0,
        iconTheme: const IconThemeData(color: onSurfacePrimary),
        titleTextStyle: textTheme(
          onSurface: onSurfacePrimary,
          onSurfaceVariant: onSurfaceSecondary,
        ).titleLarge?.copyWith(fontSize: AppTokens.fontSize2xl),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLight,
          foregroundColor: onPrimary,
          elevation: 2,
          minimumSize: const Size.fromHeight(AppTokens.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.radiusMd),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shadowColor: const Color(0x40000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusLg),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusMd),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTokens.spacingLg,
          vertical: AppTokens.spacingMd,
        ),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        AppStatusColors.dark,
      ],
    );
  }
}
