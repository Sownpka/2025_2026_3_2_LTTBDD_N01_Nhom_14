import 'package:flutter/material.dart';
import '../../models/playlist.dart';
import '../../services/data_service.dart';
import '../../services/setting_service.dart';
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
    caiDat.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.dataService.removeListener(_refresh);
    caiDat.removeListener(_refresh);
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
    if (r == true && mounted) {
      _snack(tr("Đã tạo playlist thành công", "Playlist created successfully"));
    }
  }

  Future<void> _edit(Playlist p) async {
    final r = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            EditPlaylistScreen(playlist: p, dataService: widget.dataService),
      ),
    );
    if (r == true && mounted) {
      _snack(tr("Đã cập nhật playlist", "Playlist updated"));
    }
  }

  Future<void> _delete(Playlist p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => DeletePlaylistDialog(playlist: p),
    );
    if (ok == true) {
      widget.dataService.deletePlaylist(p.id);
      _snack(tr("Đã xoá playlist", "Playlist deleted"));
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
      appBar: AppBar(
        title: Text(tr("Playlist", "Playlists")),
        centerTitle: true,
      ),
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
              tr("Chưa có playlist", "No Playlist"),
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              tr(
                "Tạo playlist đầu tiên để bắt đầu nghe những bài hát yêu thích của bạn.",
                "Create your first playlist to start listening to your favorite songs.",
              ),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: Text(tr("Tạo playlist", "Create Playlist")),
            ),
          ],
        ),
      ),
    );
  }
}

// StatelessWidget: hiển thị playlist
class PlaylistTile extends StatelessWidget {
  final Playlist playlist;
  final VoidCallback? onTap, onEdit, onDelete;
  const PlaylistTile({
    super.key,
    required this.playlist,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  String get _duration {
    final d = playlist.totalDuration;
    final h = d.inHours, m = d.inMinutes.remainder(60);
    final donViPhut = tr("phút", "min");
    return h > 0
        ? "${h}${tr('g', 'h')} ${m}${tr('p', 'm')}"
        : "${d.inMinutes} $donViPhut";
  }

  @override
  Widget build(BuildContext context) => Card(
    elevation: 3,
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 28,
        child: Text(
          playlist.totalSongs.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        playlist.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(
              "${playlist.totalSongs} bài hát",
              "${playlist.totalSongs} songs",
            ),
          ),
          Text(_duration, style: const TextStyle(color: Colors.grey)),
        ],
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (v) => v == "edit" ? onEdit?.call() : onDelete?.call(),
        itemBuilder: (_) => [
          PopupMenuItem(value: "edit", child: Text(tr("Đổi tên", "Rename"))),
          PopupMenuItem(value: "delete", child: Text(tr("Xoá", "Delete"))),
        ],
      ),
    ),
  );
}

// StatelessWidget: xoá playlist.
class DeletePlaylistDialog extends StatelessWidget {
  final Playlist playlist;
  const DeletePlaylistDialog({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(tr("Xoá playlist", "Delete playlist")),
    content: Text(tr("Xoá '${playlist.name}'?", "Delete '${playlist.name}'?")),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context, false),
        child: Text(tr("Huỷ", "Cancel")),
      ),
      ElevatedButton(
        onPressed: () => Navigator.pop(context, true),
        child: Text(tr("Xoá", "Delete")),
      ),
    ],
  );
}
