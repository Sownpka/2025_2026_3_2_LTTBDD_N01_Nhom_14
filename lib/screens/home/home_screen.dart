import 'package:flutter/material.dart';

import '../../services/demo_data.dart';

// Man hinh Trang chu - BAN 1: chi hien danh sach bai hat, chua phat nhac.
// Viet theo kieu tren lop: Material + Column + ListView voi vong for.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Vi tri bai dang chon trong danh sach. -1 = chua chon bai nao.
  var baiDangChon = -1;

  @override
  Widget build(BuildContext context) {
    return Material(
      // SafeArea: tranh chu bi thanh trang thai (gio, pin) cua dien thoai de len.
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
                  for (var i = 0; i < demoSongs.length; i++)
                    ListTile(
                      onTap: () {
                        setState(() {
                          baiDangChon = i;
                        });
                      },
                      leading: Image.asset(
                        demoSongs[i].image,
                        width: 52,
                        height: 52,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        demoSongs[i].title,
                        style: TextStyle(
                          // Bai dang chon thi in dam cho de nhin.
                          fontWeight: baiDangChon == i
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(demoSongs[i].artist.name),
                      trailing: const Icon(Icons.play_arrow),
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
