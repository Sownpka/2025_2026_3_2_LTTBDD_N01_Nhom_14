import 'package:flutter/material.dart';
import '../../models/song.dart';
import '../../services/data_service.dart';
import 'search_screen.dart';

// tìm kiếm bài hát
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
