import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:apatie/app.dart';

import '../helpers/hydrated_bloc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('renders localized strings based on active locale', (tester) async {
    await runHydrated(() async {
      tester.binding.platformDispatcher.localeTestValue = const Locale('fa');

      await tester.pumpWidget(App());
      await tester.pumpAndSettle();

      expect(find.text('آپاتیه کدکس'), findsOneWidget);
      expect(find.byTooltip('تغییر پوسته'), findsOneWidget);

      tester.binding.platformDispatcher.clearLocaleTestValue();
    });
  });
}
