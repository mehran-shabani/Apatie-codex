import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:apatie/design_system/components/app_progress_indicator.dart';
import 'package:apatie/l10n/app_localizations.dart';
import 'package:apatie/modules/services/ui/patterns/floating_window/services_floating_window_pattern.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const configs = <_TestConfig>[
    _TestConfig(
      description: 'LTR locale without motion reduction',
      locale: Locale('en'),
      reduceMotion: false,
    ),
    _TestConfig(
      description: 'RTL locale with reduced motion',
      locale: Locale('fa'),
      reduceMotion: true,
    ),
  ];

  for (final config in configs) {
    testWidgets(
      'Services floating window exposes focus, warnings, and notifications — '
      '${config.description}',
      (tester) async {
        final announcements = <String>[];
        final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
        final previousHandler = messenger.getMockMethodCallHandler(SystemChannels.accessibility);
        messenger.setMockMethodCallHandler(SystemChannels.accessibility, (methodCall) async {
          if (methodCall.method == 'announce') {
            announcements.add(methodCall.arguments as String);
          }
          return null;
        });
        addTearDown(() {
          messenger.setMockMethodCallHandler(SystemChannels.accessibility, previousHandler);
        });

        await tester.pumpWidget(
          _buildTestApp(
            locale: config.locale,
            reduceMotion: config.reduceMotion,
            child: const ServicesFloatingWindowPattern(),
          ),
        );
        await tester.pumpAndSettle();

        final floatingContainer = tester.widget<AnimatedContainer>(
          find.descendant(
            of: find.bySemanticsLabel('پنجرهٔ شناور برای پایش زنده'),
            matching: find.byType(AnimatedContainer),
          ),
        );
        expect(
          floatingContainer.duration,
          config.reduceMotion ? Duration.zero : const Duration(milliseconds: 180),
        );

        final progressValues = tester
            .widgetList<AppProgressIndicator>(find.byType(AppProgressIndicator))
            .map((indicator) => indicator.value)
            .whereType<double>()
            .toList();
        expect(
          progressValues.any((value) => (value - 0.75).abs() < 0.01),
          isTrue,
          reason: 'Main service monitoring indicator should report 75% completion.',
        );
        expect(
          progressValues.any((value) => (value - 0.45).abs() < 0.01),
          isTrue,
          reason: 'Floating window indicator should report 45% completion.',
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(
          announcements.any(
            (message) => message.contains('دکمهٔ کوچک‌سازی'),
          ),
          isTrue,
        );

        await tester.tap(find.text('کوچک‌سازی'));
        await tester.pumpAndSettle();
        expect(
          announcements,
          contains('دکمهٔ کوچک‌سازی فشرده شد.'),
        );
        expect(find.text('حالت فشرده'), findsOneWidget);
        expect(find.textContaining('پنجره در حالت فشرده'), findsOneWidget);

        await tester.tap(find.text('پایان پایش'));
        await tester.pump();
        expect(
          announcements,
          contains('دکمهٔ پایان پایش فشرده شد.'),
        );
        await tester.pump();
        expect(find.text('پایش زنده با موفقیت پایان یافت.'), findsOneWidget);

        await tester.pump(const Duration(seconds: 4));
        await tester.pumpAndSettle();
        expect(find.text('پایش زنده با موفقیت پایان یافت.'), findsNothing);

        await tester.tap(find.text('بازگشایی پنجره'));
        await tester.pumpAndSettle();
        expect(
          announcements,
          contains('دکمهٔ بازگشایی پنجره فشرده شد.'),
        );
        expect(find.text('فعال'), findsOneWidget);
      },
    );
  }
}

class _TestConfig {
  const _TestConfig({
    required this.description,
    required this.locale,
    required this.reduceMotion,
  });

  final String description;
  final Locale locale;
  final bool reduceMotion;
}

Widget _buildTestApp({
  required Locale locale,
  required bool reduceMotion,
  required Widget child,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Builder(
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final override = mediaQuery.copyWith(
          disableAnimations: reduceMotion,
          accessibleNavigation: reduceMotion,
        );
        return MediaQuery(
          data: override,
          child: Scaffold(
            body: child,
          ),
        );
      },
    ),
  );
}
