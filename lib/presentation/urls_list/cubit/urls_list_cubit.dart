import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu_link_shortener/domain/entities/alias.dart';
import 'package:nu_link_shortener/domain/repositories/repository_factory.dart';
import 'package:nu_link_shortener/presentation/urls_list/cubit/urls_list_state.dart';

class URLsListCubit extends Cubit<URLsListState> {
  List<Alias> aliases = [];
  URLsListCubit() : super(const URLsListState());

  void getRecentAliases() {

  }

  Future<void> createAlias({ required String url }) async {
    emit(URLsListState(status: URLsListStatus.loading, items: aliases));
    final alias = await RepositoryFactory().aliasRepository.createAlias(url: url);
    aliases.add(alias);
    emit(URLsListState(status: URLsListStatus.success, items: aliases));
  }
}