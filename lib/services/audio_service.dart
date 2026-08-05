import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../models/song.dart';
import 'dart:math';
import '../models/playlist.dart';
import 'data_service.dart';

final AudioPlayer mayPhat = AudioPlayer();

List<Song> dsPhat = [];
int viTriBai = -1;

List<Song> dsGanDay = [];

enum CheDoLap { khong, tatCa, motBai }

bool xaoTron = false;
CheDoLap cheDoLap = CheDoLap.khong;

final Random _ngauNhien = Random();

void doiXaoTron() {
  xaoTron = !xaoTron;
}

const String tenPlaylistYeuThich = 'Yêu thích';

Playlist _playlistYeuThich(DataService ds) {
  final timThay = ds.playlists.where((p) => p.name == tenPlaylistYeuThich);
  if (timThay.isNotEmpty) return timThay.first;
  ds.createPlaylist(tenPlaylistYeuThich);
  return ds.playlists.last;
}

void khoiTaoYeuThich(DataService ds) => _playlistYeuThich(ds);

bool laYeuThich(Song bai, DataService ds) =>
    _playlistYeuThich(ds).songs.any((b) => b.id == bai.id);

void doiYeuThich(Song bai, DataService ds) {
  final playlist = _playlistYeuThich(ds);
  if (playlist.songs.any((b) => b.id == bai.id)) {
    ds.removeSongFromPlaylist(playlist.id, bai.id);
  } else {
    ds.addSongToPlaylist(playlist.id, bai);
  }
}

void doiCheDoLap() {
  if (cheDoLap == CheDoLap.khong) {
    cheDoLap = CheDoLap.tatCa;
  } else if (cheDoLap == CheDoLap.tatCa) {
    cheDoLap = CheDoLap.motBai;
  } else {
    cheDoLap = CheDoLap.khong;
  }
}

void _ghiNhanGanDay(Song bai) {
  dsGanDay.removeWhere((b) => b.id == bai.id);
  dsGanDay.insert(0, bai);
  if (dsGanDay.length > 10) {
    dsGanDay = dsGanDay.sublist(0, 10);
  }
}

Song? get baiDangPhat =>
    (viTriBai >= 0 && viTriBai < dsPhat.length) ? dsPhat[viTriBai] : null;

bool get dangPhat => mayPhat.playing;

bool get dangTai =>
    mayPhat.processingState == ProcessingState.loading ||
    mayPhat.processingState == ProcessingState.buffering;

void khoiTaoAudio() {
  mayPhat.playerStateStream.listen((trangThai) {
    if (trangThai.processingState == ProcessingState.completed) {
      baiTiepTheo(tuDong: true);
    }
  });
  mayPhat.setVolume(1.0);
}

String? _assetDangNap;

Future<void> _taiVaPhat() async {
  final bai = baiDangPhat;
  if (bai == null) return;
  _ghiNhanGanDay(bai);
  try {
    if (_assetDangNap != bai.audio) {
      await mayPhat.setAsset(bai.audio);
      _assetDangNap = bai.audio;
    } else {
      await mayPhat.seek(Duration.zero);
    }
    await mayPhat.play();
  } catch (e) {
    debugPrint('Khong phat duoc ${bai.audio}: $e');
  }
}

Future<void> phatBai(Song bai, List<Song> ds) async {
  dsPhat = ds;
  final viTri = ds.indexWhere((b) => b.id == bai.id);
  viTriBai = viTri >= 0 ? viTri : 0;
  await _taiVaPhat();
}

Future<void> tamDungHoacPhat() async {
  if (mayPhat.playing) {
    await mayPhat.pause();
  } else {
    await mayPhat.play();
  }
}

Future<void> baiTiepTheo({bool tuDong = false}) async {
  if (dsPhat.isEmpty) return;

  // Het bai va dang lap 1 bai thi phat lai chinh no
  if (tuDong && cheDoLap == CheDoLap.motBai) {
    await mayPhat.seek(Duration.zero);
    await mayPhat.play();
    return;
  }

  if (xaoTron && dsPhat.length > 1) {
    var viTriMoi = viTriBai;
    while (viTriMoi == viTriBai) {
      viTriMoi = _ngauNhien.nextInt(dsPhat.length);
    }
    viTriBai = viTriMoi;
  } else {
    // Het bai cuoi ma khong lap thi dung han
    if (tuDong && cheDoLap == CheDoLap.khong && viTriBai >= dsPhat.length - 1) {
      await mayPhat.pause();
      await mayPhat.seek(Duration.zero);
      return;
    }
    viTriBai = (viTriBai + 1) % dsPhat.length;
  }

  await _taiVaPhat();
}

Future<void> baiTruoc() async {
  if (dsPhat.isEmpty) return;
  if (mayPhat.position.inSeconds > 3) {
    await mayPhat.seek(Duration.zero);
    return;
  }
  viTriBai = (viTriBai - 1 + dsPhat.length) % dsPhat.length;
  await _taiVaPhat();
}

Future<void> tuaDen(Duration viTri) => mayPhat.seek(viTri);
