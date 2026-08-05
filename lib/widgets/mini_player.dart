import 'package:flutter/material.dart';

import '../services/audio_service.dart';
import '../screens/player/player_screen.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../services/data_service.dart';
import '../services/setting_service.dart';

class MiniPlayer extends StatefulWidget {
  final DataService dataService;
  const MiniPlayer({super.key, required this.dataService});

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  StreamSubscription? _theoDoiTrangThai;

  @override
  void initState() {
    super.initState();
    _theoDoiTrangThai = mayPhat.playerStateStream.listen((_) {
      if (mounted) setState(() {});
    });
    caiDat.addListener(_onDoiNgonNgu);
  }

  void _onDoiNgonNgu() => mounted ? setState(() {}) : null;

  @override
  void dispose() {
    _theoDoiTrangThai?.cancel();
    caiDat.removeListener(_onDoiNgonNgu);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bai = baiDangPhat;

    if (bai == null) return const SizedBox();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerScreen(dataService: widget.dataService),
          ),
        );
      },
      child: Container(
        height: 64,
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: mauChinh,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                bai.image,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 44,
                    height: 44,
                    color: Colors.white24,
                    child: const Icon(
                      Icons.music_note,
                      size: 20,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${tr('Đang phát', 'Now playing')}: ${bai.title}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    bai.artist.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                dangPhat ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: () => tamDungHoacPhat(),
            ),
            IconButton(
              icon: const Icon(Icons.skip_next, color: Colors.white),
              onPressed: () => baiTiepTheo(),
            ),
          ],
        ),
      ),
    );
  }
}
