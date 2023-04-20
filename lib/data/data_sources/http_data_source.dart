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
  static final HTTPDataSource _instance = HTTPDataSource._internal();

  HTTPDataSource._internal();

  factory HTTPDataSource() {
    return _instance;
  }

  @override
  Future<dynamic> createAlias({required String url}) async {
    final path = URLShortenerHTTPPaths.createAliasPath();
    return await HTTPService().post(path: path, body: {'url': url});
  }

  @override
  Future<dynamic> getAliasById({required String id}) {
    // TODO: implement getAliasById
    throw UnimplementedError();
  }

}