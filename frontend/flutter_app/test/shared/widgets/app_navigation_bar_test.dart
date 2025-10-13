import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_app/shared/widgets/app_navigation_bar.dart';

Widget _buildWrappedNavigationBar({
  int currentIndex = 0,
  ValueChanged<int>? onItemSelected,
  Locale? locale,
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: AppNavigationBar(
        currentIndex: currentIndex,
        onItemSelected: onItemSelected ?? (_) {},
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('renders localized tab labels and handles selection', (tester) async {
    var tappedIndex = -1;

    await tester.pumpWidget(
      _buildWrappedNavigationBar(
        currentIndex: 1,
        onItemSelected: (index) => tappedIndex = index,
      ),
    );
    await tester.pumpAndSettle();

    final navigationBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(navigationBar.selectedIndex, 1);
    expect(find.text('Products'), findsOneWidget);

    await tester.tap(find.text('Services'));
    await tester.pump();

    expect(tappedIndex, 2);
  });

  testWidgets('applies localization for non-English locales', (tester) async {
    await tester.pumpWidget(
      _buildWrappedNavigationBar(
        currentIndex: 0,
        locale: const Locale('fa'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('نوبت‌دهی'), findsOneWidget);
    expect(find.text('محصولات'), findsOneWidget);
    expect(find.text('خدمات'), findsOneWidget);
  });
}
