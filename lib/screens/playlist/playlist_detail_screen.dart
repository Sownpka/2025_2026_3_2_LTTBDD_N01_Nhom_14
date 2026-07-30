import 'package:flutter/material.dart';
import '../../models/playlist.dart';
import '../../models/song.dart';
import '../../services/data_service.dart';

// StatefulWidget: giữ trạng thái bài hát đang chọn + lắng nghe dataService.
class PlaylistDetailScreen extends StatefulWidget {
  final Playlist playlist;
  final DataService dataService;
  const PlaylistDetailScreen({
    super.key,
    required this.playlist,
    required this.dataService,
  });

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}
