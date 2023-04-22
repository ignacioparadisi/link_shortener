import 'dart:convert';

import 'package:nu_link_shortener/data/data_sources/data_srouce.dart';
import 'package:nu_link_shortener/data/services/http_service.dart';

abstract class URLShortenerHTTPPaths {
  static String createAliasPath() {
    return 'api/alias';
  }

  static String getAliasPath({ required String id}) {
    return 'api/alias/$id';
  }
}

class HTTPDataSource implements DataSource {

  @override
  Future<dynamic> createAlias({required String url}) async {
    final path = URLShortenerHTTPPaths.createAliasPath();
    final body = {'url': url};
    final response = await HTTPService().post(path: path, body: body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw RequestException(message: response.reasonPhrase, code: '${response.statusCode}');
  }

  @override
  Future<dynamic> getAliasById({required String id}) {
    // TODO: implement getAliasById
    throw UnimplementedError();
  }

}

class GeneralException implements Exception {
  final String? message;
  GeneralException({ this.message });

  @override
  String toString() {
    if (message != null) return '$runtimeType: $message';
    return runtimeType.toString();
  }
}

class RequestException extends GeneralException {
  final String? code;
  RequestException({ super.message, this.code });
}