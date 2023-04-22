import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class HTTPService {
  final Uri baseURL = Uri.parse('https://url-shortener-server.onrender.com/');
  static final HTTPService _instance = HTTPService._internal();

  HTTPService._internal();

  factory HTTPService() {
    return _instance;
  }

  Future<http.Response> get({required String path}) {
    final url = Uri.https(baseURL.host, path);
    return http.get(url);
  }

  Future<http.Response> post(
      {required String path, Map<String, dynamic>? body}) {
    final url = Uri.https(baseURL.host, path);
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8'
    };
    final bodyEncoded = jsonEncode(body);
    log('Executing $url\nWith body: $body');
    return http.post(url, headers: headers, body: bodyEncoded);
  }
}
