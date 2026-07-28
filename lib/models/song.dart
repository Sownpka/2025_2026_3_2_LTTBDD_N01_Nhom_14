import 'artist.dart';
class Song {
  final String id;
  final String title;
  final Artist artist;
  final String album;
  final String image;
  final String audio;
  final Duration duration;
  final String genre;
  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.image,
    required this.audio,
    required this.duration,
    required this.genre,
  });
  @override
  String toString(){
    return title;
  }
}