import 'package:flutter/material.dart';

import '../../services/audio_service.dart';
import '../../widgets/seek_bar.dart';
import 'dart:async';
import '../../theme/app_theme.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  StreamSubscription? _theoDoiTrangThai;
  StreamSubscription? _theoDoiViTri;

  @override
  void initState() {
    super.initState();
    _theoDoiTrangThai = mayPhat.playerStateStream.listen((_) {
      if (mounted) setState(() {});
    });
    _theoDoiViTri = mayPhat.positionStream.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _theoDoiTrangThai?.cancel();
    _theoDoiViTri?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bai = baiDangPhat;

    if (bai == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dang phat')),
        body: const Center(child: Text('Chua chon bai hat nao')),
      );
    }

    final tongThoiGian = mayPhat.duration ?? bai.duration;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đang phát'),
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.keyboard_arrow_down),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 24),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                bai.image,
                width: 240,
                height: 240,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 240,
                    height: 240,
                    color: mauNhat,
                    child: const Icon(
                      Icons.music_note,
                      size: 80,
                      color: mauChinh,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
            Text(
              bai.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              bai.artist.name,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 24),
            SeekBar(
              viTri: mayPhat.position,
              tongThoiGian: tongThoiGian,
              onTua: (viTri) => tuaDen(viTri),
            ),

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 44,
                  icon: const Icon(Icons.skip_previous),
                  onPressed: () => baiTruoc(),
                ),
                const SizedBox(width: 16),
                IconButton(
                  iconSize: 56,
                  icon: Icon(dangPhat ? Icons.pause_circle : Icons.play_circle),
                  onPressed: () => tamDungHoacPhat(),
                ),
                const SizedBox(width: 16),
                IconButton(
                  iconSize: 44,
                  icon: const Icon(Icons.skip_next),
                  onPressed: () => baiTiepTheo(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
