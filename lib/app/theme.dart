import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF246BFD)),
        useMaterial3: true,
        fontFamily: 'Rubik',
      );
}
