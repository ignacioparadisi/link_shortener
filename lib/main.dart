import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu_link_shortener/presentation/urls_list/cubit/urls_list_cubit.dart';
import 'package:nu_link_shortener/presentation/urls_list/view/urls_list_view.dart';

void main() {
  runApp(
    const MaterialApp(
      home: App(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

@immutable
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => URLsListCubit(),
      child: const URLsListView(),
    );
  }
}
