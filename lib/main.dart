import 'package:flutter/material.dart';
import 'package:nu_link_shortener/data/data_sources/http_data_source.dart';
import 'package:nu_link_shortener/presentation/recent_urls_list/view/recent_urls_list.dart';
import 'package:nu_link_shortener/presentation/url_form/views/url_form.dart';
import 'package:nu_link_shortener/domain/extensions/string_extensions.dart';

// bool get isApplePlatform {
//   if (kIsWeb) {
//     return false;
//   }
//   return (Platform.isIOS || Platform.isMacOS);
// }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expandable Fab'),
      ),
      body: const RecentURLsList(),
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
            // TODO: Call Repository
            try {
              final result = await HTTPDataSource().createAlias(url: value);
              print(result.toString());
            } catch (error) {
              print(error);
            }
          }
        },
      ),
    );
  }
}
