import 'package:flutter/material.dart';
import '../../services/setting_service.dart';

class SettingsScreen extends StatefulWidget {
  final SettingsService settings;
  const SettingsScreen({super.key, required this.settings});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsService svc;

  @override
  void initState() {
    super.initState();
    svc = widget.settings;
    svc.addListener(_onSvc);
  }

  @override
  void dispose() {
    svc.removeListener(_onSvc);
    super.dispose();
  }

  void _onSvc() => setState(() {});

  String _labelForLocale(Locale l) {
    switch (l.languageCode) {
      case 'en':
        return 'English';
      case 'vi':
      default:
        return 'Tiếng Việt';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = svc.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(svc.locale.languageCode == 'vi' ? 'Cài đặt' : 'Settings'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: SelectionArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Language
              Card(
                child: ListTile(
                  title: Text(
                    svc.locale.languageCode == 'vi' ? 'Ngôn ngữ' : 'Language',
                  ),
                  trailing: DropdownButton<Locale>(
                    value: svc.locale,
                    items: const [
                      DropdownMenuItem(
                        value: Locale('vi'),
                        child: Text('Tiếng Việt'),
                      ),
                      DropdownMenuItem(
                        value: Locale('en'),
                        child: Text('English'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) svc.setLocale(v);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Theme
              Card(
                child: ListTile(
                  title: Text(
                    svc.locale.languageCode == 'vi' ? 'Giao diện' : 'Theme',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ChoiceChip(
                        label: Text(
                          svc.locale.languageCode == 'vi' ? 'Sáng' : 'Light',
                        ),
                        selected: !isDark,
                        onSelected: (sel) {
                          if (sel) svc.setThemeMode(ThemeMode.light);
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: Text(
                          svc.locale.languageCode == 'vi' ? 'Tối' : 'Dark',
                        ),
                        selected: isDark,
                        onSelected: (sel) {
                          if (sel) svc.setThemeMode(ThemeMode.dark);
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Group info
              Text(
                svc.locale.languageCode == 'vi'
                    ? 'Thông tin nhóm'
                    : 'Group information',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nhóm 14 — Lớp N01',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '• Nguyễn Thế Phương — 24100275 — Nhóm trưởng',
                      ),
                      const Text('• Nguyễn Hồng Sơn — 24100299'),
                      const Text('• Phùng Đức Tuấn — 24100515'),
                      const SizedBox(height: 12),
                      Text(
                        'GVHD: Nguyễn Xuân Quế',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'Môn: Lập trình cho thiết bị di động',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
