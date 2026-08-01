import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../models/song.dart';
import 'dart:math';

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

Set<String> dsYeuThich = {};

bool laYeuThich(Song bai) => dsYeuThich.contains(bai.id);

void doiYeuThich(Song bai) {
  if (!dsYeuThich.remove(bai.id)) {
    dsYeuThich.add(bai.id);
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

void khoiTaoAudio() {
  mayPhat.playerStateStream.listen((trangThai) {
    if (trangThai.processingState == ProcessingState.completed) {
      baiTiepTheo(tuDong: true);
    }
  });
}

Future<void> _taiVaPhat() async {
  final bai = baiDangPhat;
  if (bai == null) return;
  _ghiNhanGanDay(bai);
  try {
    await mayPhat.setAsset(bai.audio);
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
