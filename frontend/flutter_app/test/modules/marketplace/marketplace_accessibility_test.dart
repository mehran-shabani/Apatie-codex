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

        final strings = _MarketplaceStrings.forLocale(config.locale);

        await tester.pumpWidget(
          _buildTestApp(
            locale: config.locale,
            reduceMotion: config.reduceMotion,
            child: const MarketplacePage(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text(strings.marketplaceHeadline), findsOneWidget);

        final horizontalBar = find.byType(MarketplaceHorizontalCardBar);
        expect(horizontalBar, findsOneWidget);
        final dialogPattern = find.byType(MarketplaceDialogCardPattern);
        expect(dialogPattern, findsOneWidget);

        await tester.tap(find.byType(TextField).first);
        await tester.pump();
        expect(
          announcements,
          contains(strings.searchFieldFocusedAnnouncement),
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(
          announcements.any(
            (message) => message.contains(strings.addToReviewButtonLabel),
          ),
          isTrue,
        );

        await tester.ensureVisible(find.text(strings.personalNutritionProgramTitle));
        await tester.pump();
        await tester.tap(find.text(strings.quickSelectButtonLabel).at(1));
        await tester.pumpAndSettle();
        expect(
          announcements,
          contains(strings.quickSelectPressedAnnouncement),
        );

        final selectedCard = find.ancestor(
          of: find.text(strings.personalNutritionProgramTitle),
          matching: find.byType(AppCard),
        );
        expect(
          find.descendant(
            of: selectedCard,
            matching: find.text(strings.quickSelectSupportingText),
          ),
          findsOneWidget,
        );

        final firstCard = find.ancestor(
          of: find.text(strings.cardiacScreeningPackageTitle),
          matching: find.byType(AppCard),
        );
        expect(
          find.descendant(
            of: firstCard,
            matching: find.text(strings.reviewPromptText),
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

        await tester.tap(find.text(strings.openDialogButtonLabel));
        await tester.pumpAndSettle();
        expect(find.text(strings.dialogTitle), findsOneWidget);

        final dialogOpacity = tester.widget<AnimatedOpacity>(
          find.descendant(
            of: find.bySemanticsLabel(strings.dialogSemanticsLabel),
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
          announcements
              .any((message) => message.contains(strings.addToComparisonButtonLabel)),
          isTrue,
        );

        await tester.tap(find.text(strings.confirmSelectionButtonLabel));
        await tester.pumpAndSettle();
        expect(
          announcements,
          contains(strings.confirmSelectionPressedAnnouncement),
        );
        expect(find.text(strings.dialogTitle), findsNothing);
      },
    );
  }
}

class _MarketplaceStrings {
  const _MarketplaceStrings({
    required this.marketplaceHeadline,
    required this.searchFieldFocusedAnnouncement,
    required this.addToReviewButtonLabel,
    required this.personalNutritionProgramTitle,
    required this.quickSelectButtonLabel,
    required this.quickSelectPressedAnnouncement,
    required this.quickSelectSupportingText,
    required this.cardiacScreeningPackageTitle,
    required this.reviewPromptText,
    required this.openDialogButtonLabel,
    required this.dialogTitle,
    required this.dialogSemanticsLabel,
    required this.addToComparisonButtonLabel,
    required this.confirmSelectionButtonLabel,
    required this.confirmSelectionPressedAnnouncement,
  });

  final String marketplaceHeadline;
  final String searchFieldFocusedAnnouncement;
  final String addToReviewButtonLabel;
  final String personalNutritionProgramTitle;
  final String quickSelectButtonLabel;
  final String quickSelectPressedAnnouncement;
  final String quickSelectSupportingText;
  final String cardiacScreeningPackageTitle;
  final String reviewPromptText;
  final String openDialogButtonLabel;
  final String dialogTitle;
  final String dialogSemanticsLabel;
  final String addToComparisonButtonLabel;
  final String confirmSelectionButtonLabel;
  final String confirmSelectionPressedAnnouncement;

  static _MarketplaceStrings forLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return const _MarketplaceStrings(
          marketplaceHeadline: 'Browse available products',
          searchFieldFocusedAnnouncement:
              'تمرکز روی فیلد عبارت جست‌وجو قرار گرفت.',
          addToReviewButtonLabel: 'دکمهٔ افزودن به بررسی',
          personalNutritionProgramTitle: 'برنامهٔ تغذیهٔ شخصی',
          quickSelectButtonLabel: 'انتخاب فوری',
          quickSelectPressedAnnouncement:
              'دکمهٔ انتخاب فوری فشرده شد.',
          quickSelectSupportingText:
              'پس از انتخاب می‌توانید سفارش را نهایی کنید.',
          cardiacScreeningPackageTitle: 'پکیج غربالگری قلب و عروق',
          reviewPromptText: 'برای مقایسهٔ دقیق گزینه‌ها را مرور کنید.',
          openDialogButtonLabel: 'مشاهدهٔ کارت در گفت‌وگو',
          dialogTitle: 'جزئیات رسمی خدمت انتخاب‌شده',
          dialogSemanticsLabel: 'گفت‌وگوی رسمی برای بررسی کارت خدمت',
          addToComparisonButtonLabel: 'دکمهٔ افزودن به مقایسه',
          confirmSelectionButtonLabel: 'تأیید انتخاب',
          confirmSelectionPressedAnnouncement:
              'دکمهٔ تأیید انتخاب فشرده شد.',
        );
      case 'fa':
      default:
        return const _MarketplaceStrings(
          marketplaceHeadline: 'محصولات موجود را مرور کنید',
          searchFieldFocusedAnnouncement:
              'تمرکز روی فیلد عبارت جست‌وجو قرار گرفت.',
          addToReviewButtonLabel: 'دکمهٔ افزودن به بررسی',
          personalNutritionProgramTitle: 'برنامهٔ تغذیهٔ شخصی',
          quickSelectButtonLabel: 'انتخاب فوری',
          quickSelectPressedAnnouncement:
              'دکمهٔ انتخاب فوری فشرده شد.',
          quickSelectSupportingText:
              'پس از انتخاب می‌توانید سفارش را نهایی کنید.',
          cardiacScreeningPackageTitle: 'پکیج غربالگری قلب و عروق',
          reviewPromptText: 'برای مقایسهٔ دقیق گزینه‌ها را مرور کنید.',
          openDialogButtonLabel: 'مشاهدهٔ کارت در گفت‌وگو',
          dialogTitle: 'جزئیات رسمی خدمت انتخاب‌شده',
          dialogSemanticsLabel: 'گفت‌وگوی رسمی برای بررسی کارت خدمت',
          addToComparisonButtonLabel: 'دکمهٔ افزودن به مقایسه',
          confirmSelectionButtonLabel: 'تأیید انتخاب',
          confirmSelectionPressedAnnouncement:
              'دکمهٔ تأیید انتخاب فشرده شد.',
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
