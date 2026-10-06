import 'package:dongin/translate_api.dart';
import 'package:material_ui/material_ui.dart';
import 'package:dongin/reader.dart';
import 'package:dongin/settings.dart';
import 'package:provider/provider.dart';

// TODO: Refactor TranslateApi to be a changenotifier and make the toggle switch subscribe to it
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    Provider<TranslateApi>(
      create: (_) => TranslateApi(),
      builder: (context, child) =>
          MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final _selected = [true, false];
  late TranslateApi api;

  @override
  Widget build(BuildContext context) {
    api = context.watch<TranslateApi>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dongin Reader"),
        actions: [
          ToggleButtons(
            isSelected: [for (int i = 0; i <= 1; i++) i == api.tLangIdx],
            onPressed: (index) {
              setState(() {
                api.tLangidx = index;
              });
            },
            children: [Text("en"), Text("ja")],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text("Dongin Reader", textScaler: TextScaler.linear(2.0)),
            ),
            ListTile(
              leading: const Icon(Icons.menu_book_sharp),
              title: const Text("Home"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Settings()),
                );
              },
            ),
          ],
        ),
      ),
      body: Reader(),
    );
  }
}
