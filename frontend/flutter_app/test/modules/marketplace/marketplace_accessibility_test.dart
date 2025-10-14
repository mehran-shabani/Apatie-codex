import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:apatie/design_system/components/app_card.dart';
import 'package:apatie/design_system/components/app_progress_indicator.dart';
import 'package:apatie/l10n/app_localizations.dart';
import 'package:apatie/modules/marketplace/ui/patterns/dialog_card/marketplace_dialog_card_pattern.dart';
import 'package:apatie/modules/marketplace/ui/patterns/horizontal_card_bar/marketplace_horizontal_card_bar.dart';
import 'package:apatie/modules/marketplace/ui/screens/marketplace_page.dart';

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
      'Marketplace patterns keep focus order, announcements, and loading cues aligned — '
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
            child: const MarketplacePage(),
          ),
        );
        await tester.pumpAndSettle();

        if (config.locale.languageCode == 'fa') {
          expect(find.text('محصولات موجود را مرور کنید'), findsOneWidget);
        } else {
          expect(find.text('Browse available products'), findsOneWidget);
        }

        final horizontalBar = find.byType(MarketplaceHorizontalCardBar);
        expect(horizontalBar, findsOneWidget);
        final dialogPattern = find.byType(MarketplaceDialogCardPattern);
        expect(dialogPattern, findsOneWidget);

        await tester.tap(find.byType(TextField).first);
        await tester.pump();
        expect(
          announcements,
          contains('تمرکز روی فیلد عبارت جست‌وجو قرار گرفت.'),
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(
          announcements.any(
            (message) => message.contains('دکمهٔ افزودن به بررسی'),
          ),
          isTrue,
        );

        await tester.ensureVisible(find.text('برنامهٔ تغذیهٔ شخصی'));
        await tester.pump();
        await tester.tap(find.text('انتخاب فوری').at(1));
        await tester.pumpAndSettle();
        expect(
          announcements,
          contains('دکمهٔ انتخاب فوری فشرده شد.'),
        );

        final selectedCard = find.ancestor(
          of: find.text('برنامهٔ تغذیهٔ شخصی'),
          matching: find.byType(AppCard),
        );
        expect(
          find.descendant(
            of: selectedCard,
            matching: find.text('پس از انتخاب می‌توانید سفارش را نهایی کنید.'),
          ),
          findsOneWidget,
        );

        final firstCard = find.ancestor(
          of: find.text('پکیج غربالگری قلب و عروق'),
          matching: find.byType(AppCard),
        );
        expect(
          find.descendant(
            of: firstCard,
            matching: find.text('برای مقایسهٔ دقیق گزینه‌ها را مرور کنید.'),
          ),
          findsOneWidget,
        );

        final progressValues = tester
            .widgetList<AppProgressIndicator>(find.descendant(
          of: horizontalBar,
          matching: find.byType(AppProgressIndicator),
        ))
            .map((indicator) => indicator.value)
            .whereType<double>()
            .toList();
        expect(progressValues.any((value) => (value - 0.9).abs() < 0.01), isTrue);
        expect(progressValues.where((value) => (value - 0.6).abs() < 0.01).length, greaterThanOrEqualTo(1));

        await tester.tap(find.text('مشاهدهٔ کارت در گفت‌وگو'));
        await tester.pumpAndSettle();
        expect(find.text('جزئیات رسمی خدمت انتخاب‌شده'), findsOneWidget);

        final dialogOpacity = tester.widget<AnimatedOpacity>(
          find.descendant(
            of: find.bySemanticsLabel('گفت‌وگوی رسمی برای بررسی کارت خدمت'),
            matching: find.byType(AnimatedOpacity),
          ),
        );
        expect(
          dialogOpacity.duration,
          config.reduceMotion ? Duration.zero : const Duration(milliseconds: 160),
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(
          announcements.any((message) => message.contains('دکمهٔ افزودن به مقایسه')),
          isTrue,
        );

        await tester.tap(find.text('تأیید انتخاب'));
        await tester.pumpAndSettle();
        expect(
          announcements,
          contains('دکمهٔ تأیید انتخاب فشرده شد.'),
        );
        expect(find.text('جزئیات رسمی خدمت انتخاب‌شده'), findsNothing);
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
