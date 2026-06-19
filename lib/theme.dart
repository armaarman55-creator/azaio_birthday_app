import 'package:flutter/material.dart';

/// App-wide design tokens for Azaio's Birthday App
class AppTheme {
  AppTheme._();

  // ── Colour Palette ─────────────────────────────────────────────────────────
  static const Color blueyBlue    = Color(0xFF7DD3F0);
  static const Color blueyDark    = Color(0xFF3B82F6);
  static const Color peppaPink    = Color(0xFFF472B6);
  static const Color peppaDark    = Color(0xFFEC4899);
  static const Color demonPurple  = Color(0xFFA855F7);
  static const Color demonDark    = Color(0xFF7C3AED);
  static const Color starGold     = Color(0xFFFDE68A);
  static const Color cloudWhite   = Colors.white;

  // ── Card decoration helper ─────────────────────────────────────────────────
  static BoxDecoration glassCard({double opacity = 0.2, double radius = 20}) =>
      BoxDecoration(
        color: Colors.white.withValues(alpha: opacity),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1.5),
      );

  // ── Text styles ────────────────────────────────────────────────────────────
  static const TextStyle displayLarge = TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.w900,
    color: cloudWhite,
    shadows: [Shadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3))],
  );

  static const TextStyle headingLarge = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w900,
    color: cloudWhite,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: cloudWhite,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: cloudWhite,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: cloudWhite,
  );

  // ── Theme definitions (one per show) ───────────────────────────────────────
  static const List<Map<String, dynamic>> showThemes = [
    {
      'id': 'bluey',
      'name': 'Bluey',
      'emoji': '🐕',
      'color1': blueyBlue,
      'color2': blueyDark,
      'accent': starGold,
      'greeting': 'Wackadoo! Happy Birthday!',
      'character': '🐶',
      'funFact': 'Bluey is a Blue Heeler puppy who lives in Brisbane, Australia!',
    },
    {
      'id': 'peppa',
      'name': 'Peppa Pig',
      'emoji': '🐷',
      'color1': peppaPink,
      'color2': peppaDark,
      'accent': Color(0xFFFF6B6B),
      'greeting': 'Oink! It\'s your birthday!',
      'character': '🐽',
      'funFact': 'Peppa LOVES jumping in muddy puddles with her family!',
    },
    {
      'id': 'demon',
      'name': 'Demon Hunters',
      'emoji': '⭐',
      'color1': demonPurple,
      'color2': demonDark,
      'accent': starGold,
      'greeting': 'You\'re a STAR, Azaio!',
      'character': '💫',
      'funFact': 'Three K-Pop girls who fight demons with the power of music!',
    },
  ];
}
