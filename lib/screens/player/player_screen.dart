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

  Widget hangDieuKhien() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.shuffle, color: xaoTron ? mauChinh : Colors.black38),
          onPressed: () => setState(() => doiXaoTron()),
        ),
        IconButton(
          iconSize: 36,
          icon: const Icon(Icons.fast_rewind),
          onPressed: () => baiTruoc(),
        ),
        Container(
          decoration: const BoxDecoration(
            color: mauChinh,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            iconSize: 36,
            color: Colors.white,
            icon: Icon(dangPhat ? Icons.pause : Icons.play_arrow),
            onPressed: () => tamDungHoacPhat(),
          ),
        ),
        IconButton(
          iconSize: 36,
          icon: const Icon(Icons.fast_forward),
          onPressed: () => baiTiepTheo(),
        ),
        IconButton(
          icon: Icon(
            cheDoLap == CheDoLap.motBai ? Icons.repeat_one : Icons.repeat,
            color: cheDoLap == CheDoLap.khong ? Colors.black38 : mauChinh,
          ),
          onPressed: () => setState(() => doiCheDoLap()),
        ),
      ],
    );
  }

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
            hangDieuKhien(),
          ],
        ),
      ),
    );
  }
}
