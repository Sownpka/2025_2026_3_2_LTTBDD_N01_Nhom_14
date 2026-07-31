import 'package:flutter/material.dart';

import '../../services/audio_service.dart';
import '../../widgets/seek_bar.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    final bai = baiDangPhat;

    if (bai == null) {
      return const Material(
        child: Center(child: Text('Chua chon bai hat nao')),
      );
    }

    final tongThoiGian = mayPhat.duration ?? bai.duration;

    return Material(
      child: SafeArea(
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
            Image.asset(
              bai.image,
              width: 260,
              height: 260,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 260,
                  height: 260,
                  color: Colors.grey,
                  child: const Icon(Icons.music_note, size: 80),
                );
              },
            ),
            const SizedBox(height: 32),
            Text(
              bai.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text('${bai.artist.name} - ${bai.album}'),
            const SizedBox(height: 24),
            SeekBar(
              viTri: mayPhat.position,
              tongThoiGian: tongThoiGian,
              onTua: (viTri) => tuaDen(viTri),
            ),
          ],
        ),
      ),
    );
  }
}
