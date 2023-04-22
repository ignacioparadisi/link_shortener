import 'package:nu_link_shortener/data/data_sources/data_srouce.dart';
import 'package:nu_link_shortener/domain/entities/alias.dart';
import 'package:nu_link_shortener/domain/repositories/alias_repository.dart';

class HTTPAliasRepository implements AliasRepository {
  final DataSource _dataSource;

  HTTPAliasRepository({required DataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<Alias> createAlias({required String url}) async {
    final json = await _dataSource.createAlias(url: url);
    return Alias.fromJSON(json);
  }
  
}
