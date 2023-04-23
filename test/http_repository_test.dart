import 'package:flutter_test/flutter_test.dart';
import 'package:nu_link_shortener/data/data_sources/mock_data_source.dart';
import 'package:nu_link_shortener/data/repositories/http_alias_repository.dart';
import 'package:nu_link_shortener/domain/exceptions/request_exception.dart';

void main() {
  group('HTTP Repository', () {
    final repository = HTTPAliasRepository(dataSource: MockDataSource());
    test('Create Alilas Error', () {
      final createAlias = repository.createAlias(url: '');
      expect(() async => await createAlias, throwsA(isA<RequestException>()));
    });

    test('Create Alias Successfuly', () async {
      const url = 'https://nu.com.mx';
      final alias = await repository.createAlias(url: url);
      expect(alias.links.original, url);
      expect(alias.id, isNotEmpty);
    });
  });
}
