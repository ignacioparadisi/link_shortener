import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu_link_shortener/domain/entities/alias.dart';
import 'package:nu_link_shortener/domain/repositories/alias_repository.dart';
import 'package:nu_link_shortener/domain/repositories/repository_factory.dart';
import 'package:nu_link_shortener/presentation/urls_list/cubit/urls_list_state.dart';

class URLsListCubit extends Cubit<URLsListState> {
  final AliasRepository _repository;
  List<Alias> aliases = [];
  URLsListCubit({required AliasRepository repository})
      : _repository = repository,
        super(const URLsListState());

  Future<void> createAlias({required String url}) async {
    emit(URLsListState(status: URLsListStatus.loading, items: aliases));
    final alias =
        await _repository.createAlias(url: url);
    aliases.add(alias);
    aliases.sort(
        (alias1, alias2) => alias2.dateCreated.compareTo(alias1.dateCreated));
    emit(URLsListState(status: URLsListStatus.success, items: aliases));
  }
}
