import 'package:flutter/material.dart';

import '../../services/audio_service.dart';
import '../../services/data_service.dart';
import '../../widgets/song_tile.dart';
import '../../theme/app_theme.dart';
import '../../models/song.dart';

import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final duLieu = DataService();
  StreamSubscription? theoDoiMayPhat;

  @override
  void dispose() {
    theoDoiMayPhat?.cancel();
    super.dispose();
  }

  Future<void> chonBai(int i) async {
    final dsBai = duLieu.songs;
    if (viTriBai == i) {
      await tamDungHoacPhat();
    } else {
      await phatBai(dsBai[i], dsBai);
    }
    setState(() {});
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
      onTap: () async {
        await phatBai(bai, duLieu.songs);
        setState(() {});
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
      appBar: AppBar(title: const Text('Music App — Trang chu')),
      body: ListView(
        children: [
          if (dsGanDay.isNotEmpty) ...[
            tieuDeMuc('Nghe gan day'),
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16),
                children: [for (final bai in dsGanDay) theGanDay(bai)],
              ),
            ),
          ],
          tieuDeMuc('Danh sach bai hat'),
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
