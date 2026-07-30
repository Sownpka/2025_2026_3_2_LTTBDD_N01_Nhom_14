import 'package:flutter/material.dart';
import '../../models/playlist.dart';
import '../../services/data_service.dart';

// StatefulWidget: form dùng chung cho tạo mới và đổi tên playlist.
class _PlaylistForm extends StatefulWidget {
  final String title, subtitle, initialName, buttonLabel;
  final IconData buttonIcon;
  final bool Function(String) onSave;

  const _PlaylistForm({
    required this.title,
    required this.subtitle,
    required this.initialName,
    required this.buttonLabel,
    required this.buttonIcon,
    required this.onSave,
  });

  @override
  State<_PlaylistForm> createState() => _PlaylistFormState();
}


