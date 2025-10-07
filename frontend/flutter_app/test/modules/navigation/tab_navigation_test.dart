import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/app.dart';
import '../../helpers/hydrated_bloc.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('navigates between bottom tabs', (tester) async {
    await runHydrated(() async {
      await tester.pumpWidget(App());
      await tester.pumpAndSettle();

      expect(find.text('Manage your appointments'), findsOneWidget);

      await tester.tap(find.text('Products'));
      await tester.pumpAndSettle();
      expect(find.text('Browse available products'), findsOneWidget);

      await tester.tap(find.text('Services'));
      await tester.pumpAndSettle();
      expect(find.text('Discover services'), findsOneWidget);
    });
  });
}
