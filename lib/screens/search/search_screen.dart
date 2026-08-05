import 'package:flutter/material.dart';
import '../../models/song.dart';
import '../../services/data_service.dart';
import '../../services/setting_service.dart';
import '../../services/audio_service.dart';
import '../player/player_screen.dart';

class SearchBox extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;
  final String? hintText;
  const SearchBox({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onClear,
    this.hintText,
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
        hintText: widget.hintText ?? tr("Tìm kiếm...", "Search..."),
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
  final VoidCallback? onTap;
  final bool dense;
  const SongTile({
    super.key,
    required this.song,
    this.onTap,
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
        icon: const Icon(Icons.play_arrow, color: Colors.green),
        onPressed: onTap,
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

class SearchScreen extends StatefulWidget {
  final DataService dataService;
  const SearchScreen({super.key, required this.dataService});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  late List<Song> _results = widget.dataService.songs;

  @override
  void initState() {
    super.initState();
    caiDat.addListener(_onDoiNgonNgu);
  }

  void _onDoiNgonNgu() => mounted ? setState(() {}) : null;

  @override
  void dispose() {
    _controller.dispose();
    caiDat.removeListener(_onDoiNgonNgu);
    super.dispose();
  }

  void _search(String key) => setState(() {
    _results = key.trim().isEmpty
        ? widget.dataService.songs
        : widget.dataService.searchSong(key);
  });

  Route<void> _duongDanPlayer() {
    return PageRouteBuilder(
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      pageBuilder: (context, animation, secondaryAnimation) =>
          PlayerScreen(dataService: widget.dataService),
    );
  }

  // Phat bai duoc chon, danh sach phat la ket qua tim kiem hien tai.
  void _chonBai(Song s) async {
    Navigator.push(context, _duongDanPlayer());
    if (baiDangPhat?.id != s.id) {
      await phatBai(s, _results);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(tr("Tìm kiếm", "Search"))),
    body: Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          SearchBox(
            controller: _controller,
            onChanged: _search,
            onClear: () => _search(""),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _results.isEmpty
                ? Center(
                    child: Text(tr("Không tìm thấy bài hát", "No songs found")),
                  )
                : ListView.builder(
                    itemCount: _results.length,
                    itemBuilder: (_, i) => SongTile(
                      song: _results[i],
                      onTap: () => _chonBai(_results[i]),
                    ),
                  ),
          ),
        ],
      ),
    ),
  );
}
