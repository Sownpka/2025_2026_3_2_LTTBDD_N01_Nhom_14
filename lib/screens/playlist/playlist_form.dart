import 'package:flutter/material.dart';
import '../../models/playlist.dart';
import '../../services/data_service.dart';
import '../../services/setting_service.dart';

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

class _PlaylistFormState extends State<_PlaylistForm> {
  late final _controller = TextEditingController(text: widget.initialName);
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final ok = widget.onSave(_controller.text.trim());
    setState(() => _loading = false);
    ok
        ? Navigator.pop(context, true)
        : ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                tr("Tên playlist đã tồn tại", "Playlist name already exists"),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(20),
    child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(widget.subtitle, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 25),
          TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: tr("Tên playlist", "Playlist Name"),
              prefixIcon: const Icon(Icons.library_music),
              border: const OutlineInputBorder(),
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? tr("Vui lòng nhập tên playlist", "Please enter playlist name")
                : v.trim().length < 3
                ? tr("Tối thiểu 3 ký tự", "Minimum 3 characters")
                : null,
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: _loading ? null : _save,
              icon: Icon(widget.buttonIcon),
              label: _loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(widget.buttonLabel),
            ),
          ),
        ],
      ),
    ),
  );
}

// StatelessWidget: màn hình tạo playlist mới.
class AddPlaylistScreen extends StatelessWidget {
  final DataService dataService;
  const AddPlaylistScreen({super.key, required this.dataService});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(tr("Tạo Playlist", "Create Playlist")),
      centerTitle: true,
    ),
    body: _PlaylistForm(
      title: tr("Tạo Playlist mới", "Create New Playlist"),
      subtitle: tr(
        "Tạo playlist của riêng bạn để lưu những bài hát yêu thích.",
        "Create your own playlist to store your favourite songs.",
      ),
      initialName: "",
      buttonLabel: tr("Tạo Playlist", "Create Playlist"),
      buttonIcon: Icons.add,
      onSave: dataService.createPlaylist,
    ),
  );
}

// StatelessWidget: màn hình đổi tên playlist.
class EditPlaylistScreen extends StatelessWidget {
  final Playlist playlist;
  final DataService dataService;
  const EditPlaylistScreen({
    super.key,
    required this.playlist,
    required this.dataService,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(tr("Sửa Playlist", "Edit Playlist")),
      centerTitle: true,
    ),
    body: _PlaylistForm(
      title: tr("Sửa Playlist", "Edit Playlist"),
      subtitle: tr("Đổi tên playlist.", "Change playlist name."),
      initialName: playlist.name,
      buttonLabel: tr("Lưu", "Save"),
      buttonIcon: Icons.save,
      onSave: (name) => dataService.renamePlaylist(playlist.id, name),
    ),
  );
}
