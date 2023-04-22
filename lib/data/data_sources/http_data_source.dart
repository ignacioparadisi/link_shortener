import 'dart:convert';

import 'package:nu_link_shortener/data/data_sources/data_srouce.dart';
import 'package:nu_link_shortener/data/services/http_service.dart';
import 'package:nu_link_shortener/domain/exceptions/request_exception.dart';

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

}