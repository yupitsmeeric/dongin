import 'package:dongin/translate_api.dart';
import 'package:material_ui/material_ui.dart';
import 'package:dongin/reader.dart';
import 'package:dongin/settings.dart';
import 'package:provider/provider.dart';

// TODO: add a quick TL switch in the app bar
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dongin Reader")),
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
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => const Settings())),
            ),
          ],
        ),
      ),
      body: Reader(),
    );
  }
}
