import 'package:flutter/material.dart';

import '../widgets/mini_player.dart';
import 'home/home_screen.dart';
import 'settings/settings_screen.dart';
import '../services/setting_service.dart';
import '../services/data_service.dart';
import '../services/audio_service.dart';
import 'playlist/playlist_screen.dart';
import 'search/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int tabHienTai = 0;
  final DataService _duLieu = DataService();

  @override
  void initState() {
    super.initState();
    khoiTaoYeuThich(_duLieu);
    caiDat.addListener(_onDoiNgonNgu);
  }

  @override
  void dispose() {
    caiDat.removeListener(_onDoiNgonNgu);
    _duLieu.dispose();
    super.dispose();
  }

  void _onDoiNgonNgu() => mounted ? setState(() {}) : null;

  List<Widget> get _cacTab => [
    HomeScreen(dataService: _duLieu),
    SearchScreen(dataService: _duLieu),
    PlaylistScreen(dataService: _duLieu),
    SettingsScreen(settings: caiDat),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: tabHienTai, children: _cacTab),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MiniPlayer(dataService: _duLieu),
          BottomNavigationBar(
            currentIndex: tabHienTai,
            onTap: (i) => setState(() => tabHienTai = i),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                label: tr('Trang chủ', 'Home'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.search),
                label: tr('Tìm kiếm', 'Search'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.queue_music),
                label: tr('Playlist', 'Playlist'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings_outlined),
                label: tr('Cài đặt', 'Settings'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ManHinhChua extends StatelessWidget {
  final String ten;

  const ManHinhChua({super.key, required this.ten});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ten)),
      body: const Center(child: Text('Màn hình đang được hoàn thiện')),
    );
  }
}
