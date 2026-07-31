import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../models/song.dart';

final AudioPlayer mayPhat = AudioPlayer();

List<Song> dsPhat = [];
int viTriBai = -1;

Song? get baiDangPhat =>
    (viTriBai >= 0 && viTriBai < dsPhat.length) ? dsPhat[viTriBai] : null;

bool get dangPhat => mayPhat.playing;

void khoiTaoAudio() {
  mayPhat.playerStateStream.listen((trangThai) {
    if (trangThai.processingState == ProcessingState.completed) {
      baiTiepTheo();
    }
  });
}

Future<void> _taiVaPhat() async {
  final bai = baiDangPhat;
  if (bai == null) return;
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

Future<void> baiTiepTheo() async {
  if (dsPhat.isEmpty) return;
  viTriBai = (viTriBai + 1) % dsPhat.length;
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
