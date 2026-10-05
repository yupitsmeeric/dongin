import 'dart:convert';

// import 'package:flutter/widgets.dart';
import 'package:lru_cache/lru_cache.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;

class TranslateApi {
  final http.Client _client;
  String _sLang = "ko";
  String _tLang = "en";
  final _cache = LruCache<String, String>(256);
  final unescape = HtmlUnescape();

  void close() {
    _client.close();
  }

  TranslateApi({http.Client? client, sLang = "ko", tLang = "en"})
    : _client = client ?? http.Client(),
      _sLang = sLang,
      _tLang = tLang;

  get sLang => _sLang;
  set sLang(String value) {
    if (_sLang == value) return;

    _sLang = value;
    _cache.evictAll();
  }

  get tLang => _tLang;
  set tLang(String value) {
    if (_tLang == value) return;

    _tLang = value;
    _cache.evictAll();
  }

  Future<String> translate(String text) async {
    // trim the string to 100 chars
    if (text.length > 100) {
      text = text.substring(0, 100);
    }
    // check cache first
    final cachedTranslation = await _cache.get(text);
    if (cachedTranslation != null) {
      // print("returning cached translation for $text");
      // print(_cache.snapshot());
      return cachedTranslation;
    }

    final uri = Uri.parse(
      'https://translate-pa.googleapis.com/v1/translateHtml',
    );
    final body = [
      [
        [text],
        sLang,
        tLang,
      ],
      "wt_lib",
    ];
    final response = await _client.post(
      uri,
      headers: {
        "Accept": "*/*",
        "Content-Type": "application/json+protobuf",
        "X-Goog-API-Key": "AIzaSyATBXajvzQLTDHEQbcpq0Ihe0vWDHmO520",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      return "failed to translate";
    }

    final decoded = jsonDecode(response.body);
    final String translation = decoded[0][0];

    // html unescape
    final cleanTranslation = unescape.convert(translation);
    _cache.put(text, cleanTranslation);
    return cleanTranslation;

    // return  as String;
  }
}
