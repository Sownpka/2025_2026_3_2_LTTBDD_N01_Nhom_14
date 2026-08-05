import 'package:flutter/material.dart';

import '../../services/audio_service.dart';
import '../../services/data_service.dart';
import '../../services/setting_service.dart';
import '../../widgets/song_tile.dart';
import '../../theme/app_theme.dart';
import '../../models/song.dart';
import '../player/player_screen.dart';

import 'dart:async';

class HomeScreen extends StatefulWidget {
  final DataService dataService;
  const HomeScreen({super.key, required this.dataService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DataService get duLieu => widget.dataService;
  StreamSubscription? theoDoiMayPhat;

  @override
  void dispose() {
    theoDoiMayPhat?.cancel();
    caiDat.removeListener(_onDoiNgonNgu);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    theoDoiMayPhat = mayPhat.playerStateStream.listen((trangThai) {
      if (mounted) {
        setState(() {});
      }
    });
    caiDat.addListener(_onDoiNgonNgu);
  }

  void _onDoiNgonNgu() => mounted ? setState(() {}) : null;

  Route<void> _duongDanPlayer() {
    return PageRouteBuilder(
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      pageBuilder: (context, animation, secondaryAnimation) =>
          PlayerScreen(dataService: duLieu),
    );
  }

  void chonBai(int i) async {
    final dsBai = duLieu.songs;
    final bai = dsBai[i];
    Navigator.push(context, _duongDanPlayer());
    if (baiDangPhat?.id != bai.id) {
      await phatBai(bai, dsBai);
    }
  }

  Widget tieuDeMuc(String chu) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        chu,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget theGanDay(Song bai) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, _duongDanPlayer());
        phatBai(bai, duLieu.songs);
      },
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                bai.image,
                width: 110,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 110,
                    height: 90,
                    color: mauNhat,
                    child: const Icon(Icons.music_note, color: mauChinh),
                  );
                },
              ),
            ),
            const SizedBox(height: 6),
            Text(
              bai.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dsBai = duLieu.songs;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('Music App — Trang chủ', 'Music App — Home')),
      ),
      body: ListView(
        children: [
          if (dsGanDay.isNotEmpty) ...[
            tieuDeMuc(tr('Nghe gần đây', 'Recently played')),
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16),
                children: [for (final bai in dsGanDay) theGanDay(bai)],
              ),
            ),
          ],
          tieuDeMuc(tr('Danh sách bài hát', 'All songs')),
          for (var i = 0; i < dsBai.length; i++)
            SongTile(
              bai: dsBai[i],
              dangChon: viTriBai == i,
              dangPhatBai: viTriBai == i && dangPhat,
              onTap: () => chonBai(i),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
