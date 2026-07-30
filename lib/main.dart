import 'package:flutter/material.dart';

import 'screens/home/home_screen.dart';
import 'services/audio_service.dart';

void main() {
  khoiTaoAudio();
  runApp(const MaterialApp(home: HomeScreen()));
}
