import 'package:flutter/material.dart';

class SeekBar extends StatelessWidget {
  final Duration viTri;
  final Duration tongThoiGian;
  final ValueChanged<Duration> onTua;

  const SeekBar({
    super.key,
    required this.viTri,
    required this.tongThoiGian,
    required this.onTua,
  });

  static String doiThoiGian(Duration d) {
    final phut = d.inMinutes;
    final giay = d.inSeconds % 60;
    return '$phut:${giay.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final tong = tongThoiGian.inMilliseconds;
    final hienTai = viTri.inMilliseconds.clamp(0, tong > 0 ? tong : 0);

    return Column(
      children: [
        Slider(
          min: 0,
          max: tong > 0 ? tong.toDouble() : 1,
          value: tong > 0 ? hienTai.toDouble() : 0,
          onChanged: (giaTri) => onTua(Duration(milliseconds: giaTri.round())),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(doiThoiGian(viTri)),
              Text(doiThoiGian(tongThoiGian)),
            ],
          ),
        ),
      ],
    );
  }
}
