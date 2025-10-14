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
        messenger.setMockDecodedMessageHandler<Object?>(
          SystemChannels.accessibility,
          (Object? message) async {
            if (message is Map<Object?, Object?>) {
              final Object? type = message['type'];
              final Object? data = message['data'];
              if (type == 'announce' && data is Map<Object?, Object?>) {
                final Object? announcedMessage = data['message'];
                if (announcedMessage is String) {
                  announcements.add(announcedMessage);
                }
              }
            }
            return null;
          },
        );
        addTearDown(() {
          messenger.setMockDecodedMessageHandler<Object?>(
            SystemChannels.accessibility,
            null,
          );
        });

        final strings = _ServicesStrings.forLocale(config.locale);

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
            of: find.bySemanticsLabel(strings.floatingWindowSemanticsLabel),
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
            (message) => message.contains(strings.minimizeButtonLabel),
          ),
          isTrue,
        );

        await tester.tap(find.text(strings.minimizeLabel));
        await tester.pumpAndSettle();
        expect(
          announcements,
          contains(strings.minimizePressedAnnouncement),
        );
        expect(find.text(strings.compactStateLabel), findsOneWidget);
        expect(find.textContaining(strings.compactStateDescription), findsOneWidget);

        await tester.tap(find.text(strings.finishMonitoringLabel));
        await tester.pump();
        expect(
          announcements,
          contains(strings.finishMonitoringPressedAnnouncement),
        );
        await tester.pump();
        expect(find.text(strings.monitoringFinishedMessage), findsOneWidget);

        await tester.pump(const Duration(seconds: 4));
        await tester.pumpAndSettle();
        expect(find.text(strings.monitoringFinishedMessage), findsNothing);

        await tester.tap(find.text(strings.restoreLabel));
        await tester.pumpAndSettle();
        expect(
          announcements,
          contains(strings.restorePressedAnnouncement),
        );
        expect(find.text(strings.activeLabel), findsOneWidget);
      },
    );
  }
}

class _ServicesStrings {
  const _ServicesStrings({
    required this.floatingWindowSemanticsLabel,
    required this.minimizeButtonLabel,
    required this.minimizeLabel,
    required this.minimizePressedAnnouncement,
    required this.compactStateLabel,
    required this.compactStateDescription,
    required this.finishMonitoringLabel,
    required this.finishMonitoringPressedAnnouncement,
    required this.monitoringFinishedMessage,
    required this.restoreLabel,
    required this.restorePressedAnnouncement,
    required this.activeLabel,
  });

  final String floatingWindowSemanticsLabel;
  final String minimizeButtonLabel;
  final String minimizeLabel;
  final String minimizePressedAnnouncement;
  final String compactStateLabel;
  final String compactStateDescription;
  final String finishMonitoringLabel;
  final String finishMonitoringPressedAnnouncement;
  final String monitoringFinishedMessage;
  final String restoreLabel;
  final String restorePressedAnnouncement;
  final String activeLabel;

  static _ServicesStrings forLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return const _ServicesStrings(
          floatingWindowSemanticsLabel: 'پنجرهٔ شناور برای پایش زنده',
          minimizeButtonLabel: 'دکمهٔ کوچک‌سازی',
          minimizeLabel: 'کوچک‌سازی',
          minimizePressedAnnouncement: 'دکمهٔ کوچک‌سازی فشرده شد.',
          compactStateLabel: 'حالت فشرده',
          compactStateDescription: 'پنجره در حالت فشرده قرار دارد.',
          finishMonitoringLabel: 'پایان پایش',
          finishMonitoringPressedAnnouncement: 'دکمهٔ پایان پایش فشرده شد.',
          monitoringFinishedMessage: 'پایش زنده با موفقیت پایان یافت.',
          restoreLabel: 'بازگشایی پنجره',
          restorePressedAnnouncement: 'دکمهٔ بازگشایی پنجره فشرده شد.',
          activeLabel: 'فعال',
        );
      case 'fa':
      default:
        return const _ServicesStrings(
          floatingWindowSemanticsLabel: 'پنجرهٔ شناور برای پایش زنده',
          minimizeButtonLabel: 'دکمهٔ کوچک‌سازی',
          minimizeLabel: 'کوچک‌سازی',
          minimizePressedAnnouncement: 'دکمهٔ کوچک‌سازی فشرده شد.',
          compactStateLabel: 'حالت فشرده',
          compactStateDescription: 'پنجره در حالت فشرده قرار دارد.',
          finishMonitoringLabel: 'پایان پایش',
          finishMonitoringPressedAnnouncement: 'دکمهٔ پایان پایش فشرده شد.',
          monitoringFinishedMessage: 'پایش زنده با موفقیت پایان یافت.',
          restoreLabel: 'بازگشایی پنجره',
          restorePressedAnnouncement: 'دکمهٔ بازگشایی پنجره فشرده شد.',
          activeLabel: 'فعال',
        );
    }
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
