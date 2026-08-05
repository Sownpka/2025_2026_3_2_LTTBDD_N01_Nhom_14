import 'package:flutter/material.dart';

import '../../services/audio_service.dart';
import '../../widgets/seek_bar.dart';
import 'dart:async';
import '../../theme/app_theme.dart';
import '../../models/song.dart';
import '../../services/data_service.dart';

class PlayerScreen extends StatefulWidget {
  final DataService dataService;
  const PlayerScreen({super.key, required this.dataService});

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
          child: dangTai
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : IconButton(
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

  Widget hangPhu(Song bai) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(
            laYeuThich(bai) ? Icons.favorite : Icons.favorite_border,
            color: laYeuThich(bai) ? mauChinh : Colors.black38,
          ),
          onPressed: () => setState(() => doiYeuThich(bai)),
        ),
        TextButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => const SizedBox(
                height: 160,
                child: Center(child: Text('Chua co loi cho bai hat nay')),
              ),
            );
          },
          child: const Text('Loi bai hat'),
        ),
        IconButton(
          icon: const Icon(Icons.list, color: Colors.black38),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Danh sach phat dang duoc lam')),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.playlist_add, color: Colors.black54),
          onPressed: () => _moThemPlaylist(bai),
        ),
      ],
    );
  }

  void _moThemPlaylist(Song bai) {
    final ds = widget.dataService;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Thêm vào playlist',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.add, color: mauChinh),
                  title: const Text('Tạo playlist mới'),
                  onTap: () {
                    Navigator.pop(context);
                    _taoPlaylistMoiVaThem(bai);
                  },
                ),
                const Divider(height: 1),
                if (ds.playlists.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Chưa có playlist nào'),
                  )
                else
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: ds.playlists.length,
                      itemBuilder: (context, i) {
                        final p = ds.playlists[i];
                        final daCo = p.songs.any((e) => e.id == bai.id);
                        return ListTile(
                          leading: const Icon(
                            Icons.queue_music,
                            color: mauChinh,
                          ),
                          title: Text(p.name),
                          subtitle: Text('${p.songs.length} bài hát'),
                          trailing: daCo
                              ? const Icon(Icons.check, color: mauChinh)
                              : null,
                          onTap: () {
                            Navigator.pop(context);
                            _themBaiVaoPlaylist(p.id, p.name, bai);
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _themBaiVaoPlaylist(String playlistId, String tenPlaylist, Song bai) {
    final daThem = widget.dataService.addSongToPlaylist(playlistId, bai);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          daThem
              ? 'Đã thêm "${bai.title}" vào $tenPlaylist'
              : '"${bai.title}" đã có trong $tenPlaylist',
        ),
      ),
    );
  }

  void _taoPlaylistMoiVaThem(Song bai) {
    final ds = widget.dataService;
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Playlist mới'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Tên playlist'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              final ten = controller.text.trim();
              if (ten.isEmpty) return;
              final tao = ds.createPlaylist(ten);
              if (tao) {
                ds.addSongToPlaylist(ds.playlists.last.id, bai);
              }
              Navigator.pop(context);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    tao
                        ? 'Đã tạo "$ten" và thêm bài hát'
                        : 'Tên playlist không hợp lệ',
                  ),
                ),
              );
            },
            child: const Text('Tạo'),
          ),
        ],
      ),
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
            const SizedBox(height: 20),
            hangPhu(bai),
          ],
        ),
      ),
    );
  }
}
