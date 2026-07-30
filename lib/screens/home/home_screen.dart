import 'package:flutter/material.dart';

import '../../services/audio_service.dart';
import '../../services/data_service.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final duLieu = DataService();
  StreamSubscription? theoDoiMayPhat;

  @override
  void initState() {
    super.initState();
    khoiTaoAudio();
    theoDoiMayPhat = mayPhat.playerStateStream.listen((trangThai) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    theoDoiMayPhat?.cancel();
    // Khong dispose mayPhat vi no la bien dung chung cua ca app
    super.dispose();
  }

  Future<void> chonBai(int i) async {
    var dsBai = duLieu.songs;

    if (viTriBai == i) {
      if (dangPhat) {
        await mayPhat.pause();
      } else {
        await mayPhat.play();
      }
      return;
    }

    dsPhat = dsBai;
    viTriBai = i;
    setState(() {});
    try {
      await mayPhat.setAsset(dsBai[i].audio);
      await mayPhat.play();
    } catch (e) {
      debugPrint('Khong phat duoc ${dsBai[i].audio}: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var dsBai = duLieu.songs;

    return Material(
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Thu vien nhac',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            Expanded(
              child: ListView(
                children: [
                  for (var i = 0; i < dsBai.length; i++)
                    ListTile(
                      onTap: () {
                        chonBai(i);
                      },
                      leading: Image.asset(
                        dsBai[i].image,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        dsBai[i].title,
                        style: TextStyle(
                          fontWeight: viTriBai == i
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(dsBai[i].artist.name),
                      trailing: Icon(
                        viTriBai == i && dangPhat
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
