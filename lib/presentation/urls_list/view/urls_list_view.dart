import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nu_link_shortener/presentation/recent_urls_list/view/recent_urls_list.dart';
import 'package:nu_link_shortener/presentation/url_form/views/url_form.dart';
import 'package:nu_link_shortener/domain/extensions/string_extensions.dart';
import 'package:nu_link_shortener/presentation/urls_list/cubit/urls_list_cubit.dart';
import 'package:nu_link_shortener/presentation/urls_list/cubit/urls_list_state.dart';

class URLsListView extends StatelessWidget {
  const URLsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<URLsListCubit, URLsListState>(
      listener: (_, __) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Expandable Fab'),
          ),
          body: RecentURLsList(),
          floatingActionButton: URLForm(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return null;
              }
              if (!value.isValidURL) {
                return 'Not valid URL';
              }
              return null;
            },
            onSubmit: (isValid, value) async {
              if (value == null || value.isEmpty) {
                return;
              }
              if (isValid) {
                await BlocProvider.of<URLsListCubit>(context).createAlias(url: value);
              }
            },
          ),
        );
      },
    );
  }
}
