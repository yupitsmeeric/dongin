import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:local_assets_server/local_assets_server.dart';

const PORT = 8001;
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
  bool isListening = false;
  int? port;
  late InAppWebViewController _controller;

  @override
  void initState() {
    _initServer();
    super.initState();
  }

  Future<void> _initServer() async {
    final server = LocalAssetsServer(
      address: InternetAddress.loopbackIPv4,
      port: PORT,
      assetsBasePath: 'assets/ttu-ebook-reader',
      logger: DebugLogger(),
    );

    await server.serve();

    setState(() {
      port = server.boundPort!;
      // port = ;
      isListening = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dongin Reader")),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri("http://localhost:$PORT/manage.html"),
                ),
                onWebViewCreated: (controller) {
                  _controller = controller;
                },
                onLoadStop: (controller, _) async {
                  await setInitialSettings(controller);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> setInitialSettings(InAppWebViewController controller) async {
  // set initial settings
  // horizontal
  await controller.evaluateJavascript(
    source: 'javascript:window.localStorage.setItem("writingMode", "horizontal-tb")',
  );
  await controller.evaluateJavascript(
    source: 'javascript:window.localStorage.setItem("theme", "dark-theme")',
  );
}
