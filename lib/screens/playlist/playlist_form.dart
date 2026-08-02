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
            const SnackBar(content: Text("Playlist name already exists")),
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
            decoration: const InputDecoration(
              labelText: "Playlist Name",
              prefixIcon: Icon(Icons.library_music),
              border: OutlineInputBorder(),
            ),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? "Please enter playlist name"
                : v.trim().length < 3
                ? "Minimum 3 characters"
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
    appBar: AppBar(title: const Text("Create Playlist"), centerTitle: true),
    body: _PlaylistForm(
      title: "Create New Playlist",
      subtitle: "Create your own playlist to store your favourite songs.",
      initialName: "",
      buttonLabel: "Create Playlist",
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
    appBar: AppBar(title: const Text("Edit Playlist"), centerTitle: true),
    body: _PlaylistForm(
      title: "Edit Playlist",
      subtitle: "Change playlist name.",
      initialName: playlist.name,
      buttonLabel: "Save",
      buttonIcon: Icons.save,
      onSave: (name) => dataService.renamePlaylist(playlist.id, name),
    ),
  );
}
