import 'package:nu_link_shortener/data/data_sources/http_data_source.dart';
import 'package:nu_link_shortener/data/repositories/http_alias_repository.dart';
import 'package:nu_link_shortener/domain/repositories/alias_repository.dart';

class RepositoryFactory {
  final _httpDataSource = HTTPDataSource();

  static final RepositoryFactory _instance = RepositoryFactory._internal();

  RepositoryFactory._internal();

  factory RepositoryFactory() {
    return _instance;
  }

  AliasRepository get aliasRepository {
    return HTTPAliasRepository(dataSource: _httpDataSource);
  }
}