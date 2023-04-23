import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nu_link_shortener/data/data_sources/mock_data_source.dart';
import 'package:nu_link_shortener/data/repositories/http_alias_repository.dart';
import 'package:nu_link_shortener/domain/entities/alias.dart';
import 'package:nu_link_shortener/domain/entities/alias_link.dart';
import 'package:nu_link_shortener/domain/exceptions/request_exception.dart';
import 'package:nu_link_shortener/domain/repositories/alias_repository.dart';
import 'package:nu_link_shortener/presentation/urls_list/cubit/urls_list_cubit.dart';
import 'package:nu_link_shortener/presentation/urls_list/cubit/urls_list_state.dart';

void main() {
  group('URLs List Cubit', () {
    Alias? alias;
    AliasRepository repository = HTTPAliasRepository(dataSource: MockDataSource());

    blocTest<URLsListCubit, URLsListState>(
      'Create Alias error',
      build: () => URLsListCubit(repository: repository),
      act: (bloc) async => await bloc.createAlias(url: ''),
      expect: () => [const URLsListState(status: URLsListStatus.loading)],
      errors: () => [isA<RequestException>()],
    );

    blocTest<URLsListCubit, URLsListState>(
      'Create Alias',
      build: () => URLsListCubit(repository: repository),
      act: (bloc) async { 
        await bloc.createAlias(url: 'https://nu.com.mx');
        alias = bloc.aliases.first;
      },
      expect: () => [
        URLsListState(status: URLsListStatus.loading, items: [alias!]),
        URLsListState(status: URLsListStatus.success, items: [alias!])
      ],
    );
  });
}
