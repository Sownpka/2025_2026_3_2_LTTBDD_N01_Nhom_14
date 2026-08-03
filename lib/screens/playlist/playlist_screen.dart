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

  void _snack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _create() async {
    final r = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddPlaylistScreen(dataService: widget.dataService),
      ),
    );
    if (r == true && mounted) _snack("Playlist created successfully");
  }

  Future<void> _edit(Playlist p) async {
    final r = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            EditPlaylistScreen(playlist: p, dataService: widget.dataService),
      ),
    );
    if (r == true && mounted) _snack("Playlist updated");
  }

  Future<void> _delete(Playlist p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => DeletePlaylistDialog(playlist: p),
    );
    if (ok == true) {
      widget.dataService.deletePlaylist(p.id);
      _snack("Playlist deleted");
    }
  }

  void _openDetail(Playlist p) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) =>
          PlaylistDetailScreen(playlist: p, dataService: widget.dataService),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final playlists = widget.dataService.playlists;
    return Scaffold(
      appBar: AppBar(title: const Text("Playlist"), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: _create,
        child: const Icon(Icons.add),
      ),
      body: playlists.isEmpty
          ? EmptyPlaylistView(onCreate: _create)
          : ListView.builder(
              itemCount: playlists.length,
              itemBuilder: (_, i) {
                final p = playlists[i];
                return PlaylistTile(
                  playlist: p,
                  onTap: () => _openDetail(p),
                  onEdit: () => _edit(p),
                  onDelete: () => _delete(p),
                );
              },
            ),
    );
  }
}
// StatelessWidget: trạng thái rỗng khi chưa có playlist nào.
class EmptyPlaylistView extends StatelessWidget {
  final VoidCallback onCreate;
  const EmptyPlaylistView({super.key, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.queue_music_rounded,
              size: 90,
              color: theme.colorScheme.primary.withOpacity(0.7),
            ),
            const SizedBox(height: 24),
            Text(
              "No Playlist",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Create your first playlist to start listening to your favorite songs.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: const Text("Create Playlist"),
            ),
          ],
        ),
      ),
    );
  }
}
