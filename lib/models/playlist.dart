import 'song.dart';
class Playlist {
  final String id;
  String name;
  List<Song> songs;
  Playlist({
    required this.id,
    required this.name,
    required this.songs,
  });
  // Số lượng bài hát
  int get totalSongs {
    return songs.length;
  }
  // Tổng thời lượng playlist
  Duration get totalDuration {
    Duration total = Duration.zero;
    for(final song in songs){
      total += song.duration;
    }
    return total;
  }
  @override
  String toString(){
    return name;
  }
}