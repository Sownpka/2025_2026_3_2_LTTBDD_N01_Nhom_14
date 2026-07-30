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

Future<void> baiTiepTheo() async {
  if (dsPhat.isEmpty) return;
  viTriBai = (viTriBai + 1) % dsPhat.length;
  await _taiVaPhat();
}

Future<void> tuaDen(Duration viTri) => mayPhat.seek(viTri);
