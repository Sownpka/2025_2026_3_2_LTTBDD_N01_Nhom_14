import 'package:flutter/material.dart';

import '../../services/data_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var baiDangChon = -1;
  final duLieu = DataService();

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
                        setState(() {
                          baiDangChon = i;
                        });
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
                          fontWeight: baiDangChon == i
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(dsBai[i].artist.name),
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
