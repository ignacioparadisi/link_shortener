import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu_link_shortener/domain/repositories/repository_factory.dart';
import 'package:nu_link_shortener/presentation/urls_list/cubit/urls_list_cubit.dart';
import 'package:nu_link_shortener/presentation/urls_list/view/urls_list_view.dart';

abstract class RouteName {
  static const initial = '/';
}

abstract class AppRouter {
  static Route? generateRoute(RouteSettings settings) {
    if (settings.name == null) {
      return null;
    }

    final uri = Uri.parse(settings.name!);
    final pathSegments = uri.pathSegments;
    final queryParameters = uri.queryParameters;
    final path = pathSegments.isEmpty ? '/' : '/${pathSegments.join('/')}';

    switch (path) {
      case RouteName.initial:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => BlocProvider(
            create: (context) =>
                URLsListCubit(repository: RepositoryFactory().aliasRepository),
            child: const URLsListView(),
          ),
        );
    }
  }
}
