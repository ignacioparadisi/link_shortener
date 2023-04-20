import 'package:flutter/material.dart';

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
  }
}