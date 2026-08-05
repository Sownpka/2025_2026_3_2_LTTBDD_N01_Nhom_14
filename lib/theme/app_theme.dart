import 'package:flutter/material.dart';

const Color mauChinh = Color(0xFF2563EB);
const Color mauNen = Color(0xFFF5F7FB);
const Color mauNhat = Color(0xFFDBEAFE);
const Color mauNenToi = Color(0xFF111827);
const Color mauTheToi = Color(0xFF1F2937);

ThemeData taoTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: mauChinh, primary: mauChinh),
    scaffoldBackgroundColor: mauNen,
    appBarTheme: const AppBarTheme(
      backgroundColor: mauChinh,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: mauChinh,
      thumbColor: mauChinh,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: mauChinh,
      unselectedItemColor: Colors.black54,
      type: BottomNavigationBarType.fixed,
    ),
  );
}

ThemeData taoThemeToi() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: mauChinh,
      primary: mauChinh,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: mauNenToi,
    cardColor: mauTheToi,
    appBarTheme: const AppBarTheme(
      backgroundColor: mauTheToi,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    sliderTheme: const SliderThemeData(
      activeTrackColor: mauChinh,
      thumbColor: mauChinh,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: mauTheToi,
      selectedItemColor: mauChinh,
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
