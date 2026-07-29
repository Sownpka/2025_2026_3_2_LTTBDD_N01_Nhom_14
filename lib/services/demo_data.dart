import '../models/artist.dart';
import '../models/song.dart';

const _artistA = Artist(
  id: 'a1',
  name: 'Sơn Tùng MTP',
  image: 'assets/imgs/channels4_profile.jpg',
);
const _artistB = Artist(
  id: 'a2',
  name: 'Thanh Hưng',
  image: 'assets/s/ab6761610000e5eb394f4bba5e758ad7adc00a3c.jpg',
);

final List<Song> demoSongs = [
  Song(
    id: 's1',
    title: 'Nắng dưới chân mây',
    artist: _artistA,
    album: 'Album 1',
    image: 'assets/imgs/1752553703812_300.jpg',
    audio: 'assets/audio/Nắng Dưới Chân Mây (Hchun Remix).mp3',
    duration: const Duration(minutes: 3, seconds: 31),
    genre: 'Remix',
  ),
  Song(
    id: 's2',
    title: 'Em thua cô ta',
    artist: _artistB,
    album: 'Album 2',
    image: 'assets/imgs/1759914913445_300.jpg',
    audio: 'assets/audio/Em Thua Cô Ta (ACV Remix #2).mp3',
    duration: const Duration(minutes: 4, seconds: 33),
    genre: 'Remix',
  ),
  Song(
    id: 's3',
    title: 'Cô gái Gucci',
    artist: _artistA,
    album: 'Album 1',
    image: 'assets/imgs/1750302054142_300.jpg',
    audio: 'assets/audio/Cô Gái Guuci (Remix).mp3',
    duration: const Duration(minutes: 3, seconds: 22),
    genre: 'Remix',
  ),
];
