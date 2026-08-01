import 'package:flutter/material.dart';

import '../services/audio_service.dart';
import '../screens/player/player_screen.dart';
import 'dart:async';
import '../theme/app_theme.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({super.key});

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
  }

  @override
  void dispose() {
    _theoDoiTrangThai?.cancel();
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
          MaterialPageRoute(builder: (context) => const PlayerScreen()),
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
            Image.asset(
              bai.image,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 44,
                  height: 44,
                  color: Colors.grey,
                  child: const Icon(Icons.music_note, size: 20),
                );
              },
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dang phat: ${bai.title}',
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
              icon: Icon(dangPhat ? Icons.pause : Icons.play_arrow),
              onPressed: () => tamDungHoacPhat(),
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: () => baiTiepTheo(),
            ),
          ],
        ),
      ),
    );
  }
}
