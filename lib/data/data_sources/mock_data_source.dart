import 'dart:convert';

import 'package:nu_link_shortener/data/data_sources/data_srouce.dart';
import 'package:nu_link_shortener/domain/exceptions/request_exception.dart';

class MockDataSource implements DataSource {
  @override
  Future createAlias({required String url}) {
    if (url == '') {
      throw RequestException();
    }
    Map<String, dynamic> data = {
      "alias": "2081096980",
      "_links": {
        "self": url,
        "short": "https://url-shortener-server.onrender.com/api/alias/2081096980"
      },
    };
    return Future.value(data);
  }

}