import 'package:flutter/material.dart';

const Color mauChinh = Color(0xFF5B21B6);
const Color mauNen = Color(0xFFF8F7FC);
const Color mauNhat = Color(0xFFDDD6FE);

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
