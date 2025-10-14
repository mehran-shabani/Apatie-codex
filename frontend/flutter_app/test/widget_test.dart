// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:apatie/app.dart';
import 'package:apatie/shared/config/app_config.dart';

import 'helpers/hydrated_bloc.dart';

void main() {
  testWidgets('App initializes without errors', (tester) async {
    await runHydrated(() async {
      await tester.pumpWidget(App(config: AppConfig.fallback));
      await tester.pump();

      expect(find.byType(App), findsOneWidget);
    });
  });
}
