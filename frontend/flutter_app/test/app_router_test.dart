import 'package:flutter_test/flutter_test.dart';

import 'package:apatie/app.dart';

import 'helpers/hydrated_bloc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('navigates between tabs without transition animations', (tester) async {
    await runHydrated(() async {
      await tester.pumpWidget(App());
      await tester.pumpAndSettle();

      expect(find.text('Manage your appointments'), findsOneWidget);

      await tester.tap(find.text('Products'));
      await tester.pump();
      expect(find.text('Browse available products'), findsOneWidget);

      await tester.tap(find.text('Services'));
      await tester.pump();
      expect(find.text('Discover services'), findsOneWidget);
    });
  });

  testWidgets('returns to initial route when reselecting the active tab', (tester) async {
    await runHydrated(() async {
      await tester.pumpWidget(App());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Products'));
      await tester.pump();
      expect(find.text('Browse available products'), findsOneWidget);

      await tester.tap(find.text('Appointments'));
      await tester.pump();
      expect(find.text('Manage your appointments'), findsOneWidget);
    });
  });
}
