import 'package:flutter/material.dart';
import '../../models/playlist.dart';
import '../../services/data_service.dart';
import 'playlist_form.dart';
import 'playlist_detail_screen.dart';

// StatefulWidget: lắng nghe dataService để tự refresh danh sách playlist.
class PlaylistScreen extends StatefulWidget {
  final DataService dataService;
  const PlaylistScreen({super.key, required this.dataService});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  @override
  void initState() {
    super.initState();
    widget.dataService.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.dataService.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => mounted ? setState(() {}) : null;

