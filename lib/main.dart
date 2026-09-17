import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:local_assets_server/local_assets_server.dart';
import 'package:dongin/translate_api.dart';

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
  // late InAppWebViewController _controller;
  String _message = "";
  TranslateApi api = TranslateApi();

  @override
  void initState() {
    _initServer();
    super.initState();
  }

  @override
  void dispose() {
    api.close();
    super.dispose();
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
                  // _controller = controller;
                },
                onLoadStop: (controller, _) async {
                  await setInitialSettings(controller);
                },
                onTitleChanged: (controller, _) async {
                  await controller.evaluateJavascript(
                    source: javascriptToExecute,
                  );
                },
                onConsoleMessage: onConsoleMessage,
              ),
            ),
            Text(_message, style: const TextStyle(fontSize: 22)),
          ],
        ),
      ),
    );
  }

  Future<void> onConsoleMessage(
    InAppWebViewController controller,
    ConsoleMessage message,
  ) async {
    if (!mounted) {
      return;
    }
    String translated = "";
    try {
      translated = await api.translate(message.message);
    } catch (_) {
      return;
    }
    setState(() {
      print(message.message);
      print(translated);
      // _message = message.message;
      _message = translated;
    });
  }
}

Future<String> translateText(String text) async {
  // given a korean string, translate it and return
  // TODO
  return "";
}

Future<void> setInitialSettings(InAppWebViewController controller) async {
  // set initial settings
  // horizontal
  await controller.evaluateJavascript(
    source: 'javascript:window.localStorage.setItem("writingMode", "horizontal-tb")',
  );
  await controller.evaluateJavascript(source: 'console.log("Hello World!!!");');
  await controller.evaluateJavascript(source: javascriptToExecute);
}

String javascriptToExecute = """
skipMarks = [" ", ".", ","];

function getTappedWord(e) {
  // console.log("Tap detected!!");

  let range;
  let textNode;
  let offset;

  const selectionText = document.getSelection().toString();

  if (document.caretPositionFromPoint) {
    range = document.caretPositionFromPoint(e.clientX, e.clientY);
    // range = document.caretPositionFromPoint(x, y);
    textNode = range.offsetNode;
    offset = range.offset;
  } else { return; }

  // check if text node and if so, do the selection
  if (!textNode || textNode.nodeType != 3) { return; }
  let newRange = document.createRange();
  let start = offset;
  // if user clicks a space, select the word after
  if (skipMarks.includes(textNode.data[start])) { start++; }
  let end = offset;
  while (start >= 0 && !skipMarks.includes(textNode.data[start])) {
    start--;
  }
  if (start != 0) { start++; }
  while (end < textNode.data.length && !skipMarks.includes(textNode.data[end])) {
    end++;
  }

  newRange.setStart(textNode, start);
  newRange.setEnd(textNode, end);
  console.log(textNode.data.slice(start, end));


  const selection = window.getSelection();
  selection.removeAllRanges();
  selection.addRange(newRange);
}

function getSelectedText() {
  return document.getSelection().toString().trim();
}

function onSelectionChange(){
  setTimeout(()=>{
    const text = getSelectedText();
    if (text) {
        console.log(text);
    }
  }, 0)
}

var reader = document.getElementsByClassName('book-content');
if (reader.length != 0) {
  reader[0].addEventListener('click',getTappedWord, true);
  document.addEventListener('selectionchange', onSelectionChange, true);
}

""";
