import 'package:flutter/material.dart';
import 'package:nu_link_shortener/presentation/recent_urls_list/view/recent_urls_list.dart';
import 'package:nu_link_shortener/presentation/views/text_field_fab.dart';
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
      floatingActionButton: TextFieldFab(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return null;
          }
          if (!value.isValidURL) {
            return 'Not valid URL';
          }
          return null;
        },
        onSubmit: (isValid) async {
          if (isValid) {
            await Future.delayed(Duration(seconds: 2));
          }
        },
      ),
    );
  }
}
