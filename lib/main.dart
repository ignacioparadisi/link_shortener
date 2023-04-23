import 'package:flutter/material.dart';
import 'package:nu_link_shortener/presentation/router.dart';

void main() {
  runApp(
    const MaterialApp(
      initialRoute: RouteName.initial,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.generateRoute,
    ),
  );
}
