import 'package:flutter/material.dart';

import 'services/audio_service.dart';
import 'services/setting_service.dart';
import 'theme/app_theme.dart';
import 'screens/main_screen.dart';

void main() {
  khoiTaoAudio();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: caiDat,
      builder: (context, _) {
        return MaterialApp(
          title: 'Music App',
          debugShowCheckedModeBanner: false,
          theme: taoTheme(),
          darkTheme: taoThemeToi(),
          themeMode: caiDat.themeMode,
          home: const MainScreen(),
        );
      },
    );
  }
}
