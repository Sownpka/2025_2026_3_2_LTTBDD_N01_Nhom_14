import 'package:flutter/material.dart';

import '../models/song.dart';

class SongTile extends StatelessWidget {
  final Song bai;
  final bool dangChon;
  final bool dangPhatBai;
  final VoidCallback onTap;

  const SongTile({
    super.key,
    required this.bai,
    required this.onTap,
    this.dangChon = false,
    this.dangPhatBai = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Image.asset(
        bai.image,
        width: 52,
        height: 52,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 52,
            height: 52,
            color: Colors.grey,
            child: const Icon(Icons.music_note),
          );
        },
      ),
      title: Text(bai.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(bai.artist.name),
    );
  }
}
