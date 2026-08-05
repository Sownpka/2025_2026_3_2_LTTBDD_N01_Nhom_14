import 'package:flutter/material.dart';
import '../../models/song.dart';
import '../../services/data_service.dart';
import '../../services/setting_service.dart';
import 'search_screen.dart';

class SongSearchDelegate extends SearchDelegate<String> {
  final DataService dataService;
  SongSearchDelegate({required this.dataService});
  @override
  List<Widget>? buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ""),
  ];
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, ""),
  );
  @override
  Widget buildResults(BuildContext context) => _SearchList(
    keyword: query,
    dataService: dataService,
    onSelect: (t) => close(context, t),
  );
  @override
  Widget buildSuggestions(BuildContext context) => _SearchList(
    keyword: query,
    dataService: dataService,
    onSelect: (t) => close(context, t),
  );
}

class _SearchList extends StatefulWidget {
  final String keyword;
  final DataService dataService;
  final ValueChanged<String> onSelect;
  const _SearchList({
    required this.keyword,
    required this.dataService,
    required this.onSelect,
  });
  @override
  State<_SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<_SearchList> {
  List<Song> _results = [];
  @override
  void initState() {
    super.initState();
    _search();
  }

  @override
  void didUpdateWidget(covariant _SearchList old) {
    super.didUpdateWidget(old);
    if (old.keyword != widget.keyword) _search();
  }

  void _search() => setState(() {
    _results = widget.keyword.trim().isEmpty
        ? []
        : widget.dataService.searchSong(widget.keyword);
  });
  @override
  Widget build(BuildContext context) {
    if (_results.isEmpty) {
      return Center(
        child: Text(tr("Không tìm thấy bài hát", "No songs found")),
      );
    }
    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (_, i) => SongTile(
        song: _results[i],
        dense: true,
        onTap: () => widget.onSelect(_results[i].title),
      ),
    );
  }
}
