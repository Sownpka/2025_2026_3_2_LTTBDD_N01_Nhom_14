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

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  String? _selectedId;

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

  Playlist get _playlist => widget.dataService.playlists.firstWhere(
    (e) => e.id == widget.playlist.id,
  );

  void _select(Song s) =>
      setState(() => _selectedId = _selectedId == s.id ? null : s.id);

  void _remove(Song s) {
    if (_selectedId == s.id) _selectedId = null;
    widget.dataService.removeSongFromPlaylist(_playlist.id, s.id);
  }

  Future<void> _addSong() async {
    final ids = <String>[];
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setDialog) => AlertDialog(
          title: const Text("Add songs"),
          content: SizedBox(
            width: double.maxFinite,
            height: 350,
            child: ListView(
              children: widget.dataService.songs
                  .map(
                    (s) => CheckboxListTile(
                      value: ids.contains(s.id),
                      title: Text(s.title),
                      subtitle: Text(s.artist.name),
                      onChanged: (v) => setDialog(
                        () => v! ? ids.add(s.id) : ids.remove(s.id),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("Add (${ids.length})"),
            ),
          ],
        ),
      ),
    );
    if (ok == true) {
      for (final id in ids) {
        widget.dataService.addSongToPlaylist(
          _playlist.id,
          widget.dataService.songs.firstWhere((e) => e.id == id),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(_playlist.name),
      actions: [IconButton(onPressed: _addSong, icon: const Icon(Icons.add))],
    ),
    body: _playlist.songs.isEmpty
        ? const Center(child: Text("No songs"))
        : ListView.builder(
            itemCount: _playlist.songs.length,
            itemBuilder: (_, i) {
              final s = _playlist.songs[i];
              return SongItem(
                song: s,
                isSelected: s.id == _selectedId,
                onTap: () => _select(s),
                onDelete: () => _remove(s),
              );
            },
          ),
  );
}

// StatelessWidget: 1 dòng bài hát trong playlist.
class SongItem extends StatelessWidget {
  final Song song;
  final bool isSelected;
  final VoidCallback onTap, onDelete;

  const SongItem({
    super.key,
    required this.song,
    required this.onTap,
    required this.onDelete,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    onTap: onTap,
    selected: isSelected,
    leading: Icon(isSelected ? Icons.check_circle : Icons.music_note),
    title: Text(song.title),
    subtitle: Text(song.artist.name),
    trailing: IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: onDelete,
    ),
  );
}
