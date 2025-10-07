import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:superapp/app.dart';

void main() {
  testWidgets('switching tabs updates navigation bar', (tester) async {
    await tester.pumpWidget(const SuperApp());
    expect(find.text('Appointments'), findsOneWidget);

    await tester.tap(find.text('Marketplace'));
    await tester.pumpAndSettle();

    NavigationBar navBar = tester.widget(find.byType(NavigationBar));
    expect(navBar.selectedIndex, 1);

    await tester.tap(find.text('Services'));
    await tester.pumpAndSettle();

    navBar = tester.widget(find.byType(NavigationBar));
    expect(navBar.selectedIndex, 2);
  });
}
