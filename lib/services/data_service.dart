import 'package:flutter/foundation.dart';
import '../models/artist.dart';
import '../models/song.dart';
import '../models/playlist.dart';

class DataService extends ChangeNotifier {
  final List<Song> _songs = [];
  final List<Playlist> _playlists = [];
  DataService() {
    _initSampleData();
  }
  List<Song> get songs => List.unmodifiable(_songs);
  List<Playlist> get playlists => List.unmodifiable(_playlists);
  // Sample Data
  void _initSampleData() {
    final mtp = Artist(
      id: "A01",
      name: "Sơn Tùng MTP",
      image: "assets/imgs/mtp.jpg",
    );
    final jack = Artist(id: "A02", name: "Jack", image: "assets/imgs/jack.jpg");
    final erik = Artist(id: "A03", name: "Erik", image: "assets/imgs/erik.jpg");
    final den = Artist(
      id: "A04",
      name: "Đen Vâu",
      image: "assets/imgs/den.jpg",
    );

    _songs.addAll([
      Song(
        id: "local01",
        title: "Come My Way",
        artist: mtp,
        album: "MTP",
        image: "assets/imgs/mtp.jpg",
        audio: "assets/audio/Come My Way.mp3",
        duration: const Duration(minutes: 4),
        genre: "Pop",
      ),
      Song(
        id: "local02",
        title: "Hãy Trao Cho Anh",
        artist: mtp,
        album: "Chúng Ta",
        image: "assets/imgs/mtp.jpg",
        audio: "assets/audio/Come My Way.mp3",
        duration: const Duration(minutes: 4),
        genre: "Pop",
      ),
      Song(
        id: "local03",
        title: "Lạc Trôi",
        artist: mtp,
        album: "MTP",
        image: "assets/imgs/mtp.jpg",
        audio: "assets/audio/Come My Way.mp3",
        duration: const Duration(minutes: 4),
        genre: "Ballad",
      ),
      Song(
        id: "local04",
        title: "Chúng Ta Của Hiện Tại",
        artist: mtp,
        album: "Chúng Ta",
        image: "assets/imgs/mtp.jpg",
        audio: "assets/audio/Come My Way.mp3",
        duration: const Duration(minutes: 5),
        genre: "Ballad",
      ),
      Song(
        id: "local05",
        title: "Sóng Gió",
        artist: jack,
        album: "Sóng Gió",
        image: "assets/imgs/jack.jpg",
        audio: "assets/audio/Come My Way.mp3",
        duration: const Duration(minutes: 4),
        genre: "Pop",
      ),
      Song(
        id: "local06",
        title: "Bạc Phận",
        artist: jack,
        album: "JACK",
        image: "assets/imgs/jack.jpg",
        audio: "assets/audio/Come My Way.mp3",
        duration: const Duration(minutes: 4),
        genre: "Ballad",
      ),
      Song(
        id: "local07",
        title: "Có Chắc Yêu Là Đây",
        artist: mtp,
        album: "MTP",
        image: "assets/imgs/mtp.jpg",
        audio: "assets/audio/Come My Way.mp3",
        duration: const Duration(minutes: 3),
        genre: "Pop",
      ),
      Song(
        id: "local08",
        title: "Sau Tất Cả",
        artist: erik,
        album: "ERIK",
        image: "assets/imgs/erik.jpg",
        audio: "assets/audio/Come My Way.mp3",
        duration: const Duration(minutes: 4),
        genre: "Ballad",
      ),
      Song(
        id: "local09",
        title: "Em Không Sai Chúng Ta Sai",
        artist: erik,
        album: "Ballad",
        image: "assets/imgs/erik.jpg",
        audio: "assets/audio/Come My Way.mp3",
        duration: const Duration(minutes: 5),
        genre: "Ballad",
      ),
      Song(
        id: "local10",
        title: "Mang Tiền Về Cho Mẹ",
        artist: den,
        album: "Đen Vâu",
        image: "assets/imgs/den.jpg",
        audio: "assets/audio/Come My Way.mp3",
        duration: const Duration(minutes: 4),
        genre: "Rap",
      ),
      Song(
        id: "local11",
        title: "Trốn Tìm",
        artist: den,
        album: "Đen Vâu",
        image: "assets/imgs/den.jpg",
        audio: "assets/audio/Come My Way.mp3",
        duration: const Duration(minutes: 5),
        genre: "Rap",
      ),
    ]);
  }

  // SEARCH
  List<Song> searchSong(String keyword) {
    final key = keyword.toLowerCase().trim();
    if (key.isEmpty) {
      return songs;
    }
    return _songs.where((song) {
      return song.title.toLowerCase().contains(key) ||
          song.artist.name.toLowerCase().contains(key) ||
          song.genre.toLowerCase().contains(key);
    }).toList();
  }

  // PLAYLIST
  bool createPlaylist(String name) {
    if (name.trim().isEmpty) {
      return false;
    }
    _playlists.add(
      Playlist(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        songs: [],
      ),
    );
    notifyListeners();
    return true;
  }

  bool renamePlaylist(String id, String name) {
    final playlist = getPlaylist(id);
    if (playlist == null || name.trim().isEmpty) {
      return false;
    }
    playlist.name = name;
    notifyListeners();
    return true;
  }

  bool deletePlaylist(String id) {
    _playlists.removeWhere((e) => e.id == id);
    notifyListeners();
    return true;
  }

  bool addSongToPlaylist(String playlistId, Song song) {
    final playlist = getPlaylist(playlistId);
    if (playlist == null) {
      return false;
    }
    if (playlist.songs.any((e) => e.id == song.id)) {
      return false;
    }
    playlist.songs.add(song);
    notifyListeners();
    return true;
  }

  bool removeSongFromPlaylist(String playlistId, String songId) {
    final playlist = getPlaylist(playlistId);
    if (playlist == null) {
      return false;
    }
    playlist.songs.removeWhere((e) => e.id == songId);
    notifyListeners();
    return true;
  }

  Playlist? getPlaylist(String id) {
    try {
      return _playlists.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }
}
