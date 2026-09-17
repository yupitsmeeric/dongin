import 'package:dongin/translate_api.dart';

// test the translate function
Future<void> main() async {
  final api = TranslateApi();
  final text = "깨물다";
  final out = await api.translate(text);
  print(out);
  api.close();
  return;
}
