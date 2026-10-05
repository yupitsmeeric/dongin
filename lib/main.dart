import 'package:flutter/material.dart';
import 'package:dongin/reader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
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
            const DrawerHeader(child: Text("Dongin Reader")),
            ListTile(title: const Text("Reader")),
            ListTile(title: const Text("Settings")),
          ],
        ),
      ),
      body: Reader(),
    );
  }
}
