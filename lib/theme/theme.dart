import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MonitoringTheme {
  static TextTheme textTheme = GoogleFonts.varelaRoundTextTheme(const TextTheme(
          bodyLarge: TextStyle(fontSize: 22),
          bodyMedium: TextStyle(fontSize: 16),
          bodySmall: TextStyle(fontSize: 10)))
      .copyWith(
    titleMedium: GoogleFonts.quicksand(),
  );

  static ThemeData get light {
    return ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 246, 160, 0),
        ),
        textTheme: textTheme);
  }

  static ThemeData get dark {
    return ThemeData(
        colorScheme: const ColorScheme.dark(background: Color(0xFF15140C)),
        textTheme: textTheme);
  }
}
