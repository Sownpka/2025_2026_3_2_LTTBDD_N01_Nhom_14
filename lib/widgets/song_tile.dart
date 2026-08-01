import 'package:flutter/material.dart';

import '../models/song.dart';
import '../theme/app_theme.dart';

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
    final mauChinh = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            bai.image,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 48,
                height: 48,
                color: mauNhat,
                child: Icon(Icons.music_note, color: mauChinh),
              );
            },
          ),
        ),
        title: Text(
          bai.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: dangChon ? FontWeight.bold : FontWeight.w600,
            color: dangChon ? mauChinh : Colors.black87,
          ),
        ),
        subtitle: Text(
          bai.artist.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        trailing: Icon(
          dangPhatBai ? Icons.pause : Icons.play_arrow,
          color: mauChinh,
        ),
      ),
    );
  }
}
