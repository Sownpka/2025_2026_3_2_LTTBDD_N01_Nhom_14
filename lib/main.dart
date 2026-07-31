import 'package:flutter/material.dart';

import 'services/audio_service.dart';
import 'theme/app_theme.dart';
import 'screens/main_screen.dart';

void main() {
  khoiTaoAudio();
  runApp(
    MaterialApp(
      title: 'Music App',
      debugShowCheckedModeBanner: false,
      theme: taoTheme(),
      home: const MainScreen(),
    ),
  );
}
