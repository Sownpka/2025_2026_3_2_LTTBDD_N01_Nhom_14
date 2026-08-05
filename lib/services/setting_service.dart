import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final SettingsService caiDat = SettingsService();
String tr(String vi, String en) => caiDat.locale.languageCode == 'vi' ? vi : en;

enum AudioQuality { low, medium, high }

class SettingsService extends ChangeNotifier {
  Locale _locale = const Locale('vi'); // mặc định Tiếng Việt
  ThemeMode _themeMode = ThemeMode.light;
  AudioQuality _quality = AudioQuality.high;
  bool _initialized = false;

  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;
  AudioQuality get quality => _quality;
  bool get initialized => _initialized;

  static const _kLangKey = 'app_lang';
  static const _kThemeKey = 'app_theme'; // 'light'|'dark'
  static const _kQualityKey = 'app_quality'; // 'low'|'medium'|'high'

  SettingsService() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final sp = await SharedPreferences.getInstance();
    final lang = sp.getString(_kLangKey) ?? 'vi';
    final theme = sp.getString(_kThemeKey) ?? 'light';
    final quality = sp.getString(_kQualityKey) ?? 'high';

    _locale = Locale(lang);
    _themeMode = theme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    _quality = _parseQuality(quality);
    _initialized = true;
    notifyListeners();
  }

  AudioQuality _parseQuality(String s) {
    switch (s) {
      case 'low':
        return AudioQuality.low;
      case 'medium':
        return AudioQuality.medium;
      case 'high':
      default:
        return AudioQuality.high;
    }
  }

  Future<void> setLocale(Locale newLocale) async {
    if (_locale == newLocale) return;
    _locale = newLocale;
    notifyListeners();
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kLangKey, newLocale.languageCode);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kThemeKey, mode == ThemeMode.dark ? 'dark' : 'light');
  }

  Future<void> setQuality(AudioQuality q) async {
    if (_quality == q) return;
    _quality = q;
    notifyListeners();
    final sp = await SharedPreferences.getInstance();
    final s = q == AudioQuality.low
        ? 'low'
        : q == AudioQuality.medium
        ? 'medium'
        : 'high';
    await sp.setString(_kQualityKey, s);
  }
}

final SettingsService caiDat = SettingsService();
String tr(String vi, String en) => caiDat.locale.languageCode == 'vi' ? vi : en;
