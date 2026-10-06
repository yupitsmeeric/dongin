import 'package:material_ui/material_ui.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:provider/provider.dart';
import 'package:dongin/translate_api.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final languages = ["ko", "en", "ja", "de"];
  late TranslateApi api;

  @override
  Widget build(BuildContext context) {
    api = context.watch<TranslateApi>();
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text("Translation"),
            tiles: [
              SettingsTile(
                leading: const Icon(Icons.text_rotate_up_sharp),
                title: const Text("Source Language"),
                value: Text(api.sLang),
                trailing: SizedBox(
                  width: 180,
                  child: DropdownButton<String>(
                    value: api.sLang,
                    isExpanded: true,
                    items: [
                      for (var lang in languages)
                        DropdownMenuItem(value: lang, child: Text(lang)),
                    ],
                    onChanged: (sLang) {
                      if (sLang == null) return;
                      api.sLang = sLang;
                    },
                  ),
                ),
              ),

              SettingsTile(
                leading: const Icon(Icons.text_rotation_down_sharp),
                title: const Text("Target Language"),
                value: Text(api.tLang),
                trailing: SizedBox(
                  width: 180,
                  child: DropdownButton<String>(
                    value: api.tLang,
                    isExpanded: true,
                    items: [
                      for (var lang in languages)
                        DropdownMenuItem(value: lang, child: Text(lang)),
                    ],
                    onChanged: (tLang) {
                      if (tLang == null) return;
                      setState(() {
                        api.tLang = tLang;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
