import 'package:flutter/material.dart';

import 'screens/home/home_screen.dart';
import 'services/audio_service.dart';
import 'theme/app_theme.dart';

void main() {
  khoiTaoAudio();
  runApp(
    MaterialApp(
      title: 'Music App',
      debugShowCheckedModeBanner: false,
      theme: taoTheme(),
      home: const HomeScreen(),
    ),
  );
}
