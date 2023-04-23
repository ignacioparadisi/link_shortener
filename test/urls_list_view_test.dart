import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nu_link_shortener/data/data_sources/mock_data_source.dart';
import 'package:nu_link_shortener/data/repositories/http_alias_repository.dart';
import 'package:nu_link_shortener/presentation/urls_list/cubit/urls_list_cubit.dart';
import 'package:nu_link_shortener/presentation/urls_list/view/urls_list_view.dart';

void main() {
  late Widget widget;
  setUp(() {
    widget = MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocProvider(
          create: (context) => URLsListCubit(
              repository: HTTPAliasRepository(dataSource: MockDataSource())),
          child: const URLsListView(),
        ),
      ),
    );
  });

  group('UI Tests', () {
    testWidgets('Text field form starts closed', (tester) async {
      await tester.pumpWidget(widget);
      final finder = find.byType(FadeTransition);
      final widgets = tester.widgetList<FadeTransition>(finder);
      // First transition is textfield
      // Second transition is save button
      // Third transition is add button
      expect(widgets.map((e) => e.opacity.value).toList(), equals([0, 0, 1]));
    });

    testWidgets('Textfield form opens', (tester) async {
      await tester.pumpWidget(widget);
      final fadeTransitionFinder = find.byType(FadeTransition);
      final widgets = tester.widgetList<FadeTransition>(fadeTransitionFinder);
      expect(widgets.map((e) => e.opacity.value).toList(), equals([0, 0, 1]));

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(widgets.map((e) => e.opacity.value).toList(), equals([1, 1, 0]));
    });

    testWidgets('Textfield form closes on close button', (tester) async {
      await tester.pumpWidget(widget);
      final fadeTransitionFinder = find.byType(FadeTransition);
      final widgets = tester.widgetList<FadeTransition>(fadeTransitionFinder);
      if (widgets.first.opacity.value == 0) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();
      }
      expect(widgets.map((e) => e.opacity.value).toList(), equals([1, 1, 1, 0]));
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(widgets.map((e) => e.opacity.value).toList(), equals([0, 1, 0, 1]));
    });

    testWidgets('Invalid URL', (tester) async {
      await tester.pumpWidget(widget);
      final fadeTransitionFinder = find.byType(FadeTransition);
      final widgets = tester.widgetList<FadeTransition>(fadeTransitionFinder);
      if (widgets.first.opacity.value == 0) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();
      }
      final textFieldFinder = find.byType(TextFormField);
      await tester.enterText(textFieldFinder, '123');
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();
      expect(find.text('Not valid URL'), findsOneWidget);
    });

    testWidgets('Create alias successfully', (tester) async {
      await tester.pumpWidget(widget);
      final fadeTransitionFinder = find.byType(FadeTransition);
      final widgets = tester.widgetList<FadeTransition>(fadeTransitionFinder);
      if (widgets.first.opacity.value == 0) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();
      }
      final textFieldFinder = find.byType(TextFormField);
      await tester.enterText(textFieldFinder, 'https://nu.com.mx');
      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();
      final urlFinder = find.text(
          'https://url-shortener-server.onrender.com/api/alias/2081096980');
      final urls = tester.widgetList(urlFinder);
      expect(urls.length, 1);
    });
  });
}
