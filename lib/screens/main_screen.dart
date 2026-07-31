import 'package:flutter/material.dart';

import '../widgets/mini_player.dart';
import 'home/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int tabHienTai = 0;

  static const _cacTab = [
    HomeScreen(),
    ManHinhChua(ten: 'Tim kiem'),
    ManHinhChua(ten: 'Playlist'),
    ManHinhChua(ten: 'Cai dat'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: tabHienTai, children: _cacTab),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayer(),
          BottomNavigationBar(
            currentIndex: tabHienTai,
            onTap: (i) => setState(() => tabHienTai = i),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Trang chu',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Tim kiem',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.queue_music),
                label: 'Playlist',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                label: 'Cai dat',
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
      body: const Center(child: Text('Man hinh dang duoc hoan thien')),
    );
  }
}
