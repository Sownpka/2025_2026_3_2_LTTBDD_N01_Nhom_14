import 'package:flutter/material.dart';
import '../../models/song.dart';
import '../../services/data_service.dart';

class SearchBox extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final String hintText;
  const SearchBox({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onClear,
    this.hintText = "Search...",
  });

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(15));
    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: widget.controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  widget.controller.clear();
                  widget.onClear?.call();
                },
              ),
        filled: true,
        border: border,
        enabledBorder: border,
        focusedBorder: border,
      ),
    );
  }
}

class SongTile extends StatelessWidget {
  final Song song;
  final VoidCallback? onTap, onAdd;
  final bool dense;
  const SongTile({
    super.key,
    required this.song,
    this.onTap,
    this.onAdd,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = dense ? 48.0 : 60.0;
    final tile = ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          song.image,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Icon(Icons.music_note, size: dense ? 24 : 30),
        ),
      ),
      title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        song.artist.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.playlist_add, color: Colors.green),
        onPressed: onAdd,
      ),
    );
    return dense
        ? tile
        : Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: tile,
          );
  }
}

void addToPlaylist(BuildContext context, DataService dataService, Song song) {
  final messenger = ScaffoldMessenger.of(context);
  if (dataService.playlists.isEmpty) {
    messenger.showSnackBar(
      const SnackBar(content: Text("No playlist available")),
    );
    return;
  }
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Choose playlist"),
      content: SizedBox(
        width: double.maxFinite,
        height: 300,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: dataService.playlists.length,
          itemBuilder: (_, i) {
            final p = dataService.playlists[i];
            return ListTile(
              leading: const Icon(Icons.queue_music, color: Colors.deepPurple),
              title: Text(p.name),
              onTap: () {
                final added = dataService.addSongToPlaylist(p.id, song);
                Navigator.pop(context);
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      added
                          ? "${song.title} added to ${p.name}"
                          : "Song already exists",
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    ),
  );
}
