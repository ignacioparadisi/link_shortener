import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:nu_link_shortener/data/data_sources/data_srouce.dart';
import 'package:nu_link_shortener/data/data_sources/http_data_source.dart';
import 'package:nu_link_shortener/data/data_sources/mock_data_source.dart';
import 'package:nu_link_shortener/data/repositories/http_alias_repository.dart';
import 'package:nu_link_shortener/domain/repositories/alias_repository.dart';

bool get isRunningTests {
  return !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');
}

class RepositoryFactory {
  DataSource get _httpDataSource { 
    if (isRunningTests) {
      return MockDataSource(); 
    }
    return HTTPDataSource(); 
  }

  static final RepositoryFactory _instance = RepositoryFactory._internal();

  RepositoryFactory._internal();

  factory RepositoryFactory() {
    return _instance;
  }

  AliasRepository get aliasRepository {
    return HTTPAliasRepository(dataSource: _httpDataSource);
  }
}