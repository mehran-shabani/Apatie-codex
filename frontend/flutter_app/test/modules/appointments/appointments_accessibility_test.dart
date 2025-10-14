import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:apatie/design_system/components/app_card.dart';
import 'package:apatie/design_system/components/app_progress_indicator.dart';
import 'package:apatie/l10n/app_localizations.dart';
import 'package:apatie/modules/appointments/ui/patterns/full_screen_flow/appointments_full_screen_flow.dart';

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
      'Appointments full-screen flow handles focus, announcements, and loading states — '
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

        final strings = _AppointmentsStrings.forLocale(config.locale);

        await tester.pumpWidget(
          _buildTestApp(
            locale: config.locale,
            reduceMotion: config.reduceMotion,
            child: const AppointmentsFullScreenFlow(),
          ),
        );
        await tester.pumpAndSettle();

        final animatedSwitcher = tester.widget<AnimatedSwitcher>(find.byType(AnimatedSwitcher));
        expect(
          animatedSwitcher.duration,
          config.reduceMotion ? Duration.zero : const Duration(milliseconds: 180),
        );

        expect(find.text(strings.flowTitle), findsOneWidget);

        final initialProgress =
            tester.widget<AppProgressIndicator>(find.byType(AppProgressIndicator).first);
        expect(initialProgress.value, moreOrLessEquals(1 / 3));

        await tester.tap(find.byType(TextField).first);
        await tester.pump();
        expect(
          announcements,
          contains(strings.serviceFieldFocusedAnnouncement),
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(
          announcements,
          contains(strings.firstServiceFocusedAnnouncement),
        );

        await tester.tap(find.text(strings.nutritionConsultationService));
        await tester.pump();
        expect(
          announcements,
          contains(strings.nutritionConsultationSelectedAnnouncement),
        );

        await tester.tap(find.text(strings.continueLabel));
        await tester.pumpAndSettle();
        expect(find.text(strings.secondStepTitle), findsOneWidget);

        final secondStepProgress =
            tester.widget<AppProgressIndicator>(find.byType(AppProgressIndicator).first);
        expect(secondStepProgress.value, moreOrLessEquals(2 / 3));

        await tester.tap(find.text(strings.cardiologistExpert));
        await tester.pump();
        expect(
          announcements,
          contains(strings.cardiologistSelectedAnnouncement),
        );

        await tester.tap(find.text(strings.continueLabel));
        await tester.pumpAndSettle();
        expect(find.text(strings.finalStepTitle), findsOneWidget);

        final finalProgress =
            tester.widget<AppProgressIndicator>(find.byType(AppProgressIndicator).first);
        expect(finalProgress.value, moreOrLessEquals(1));

        await tester.tap(find.text(strings.firstTimeSlot));
        await tester.pump();
        expect(
          announcements,
          contains(strings.firstTimeSlotSelectedAnnouncement),
        );

        final summaryCard = find.ancestor(
          of: find.text(strings.summaryTitle),
          matching: find.byType(AppCard),
        );

        expect(
          find.descendant(
            of: summaryCard,
            matching: find.text(strings.nutritionConsultationService),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: summaryCard,
            matching: find.text(strings.cardiologistExpert),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: summaryCard,
            matching: find.text(strings.firstTimeSlot),
          ),
          findsOneWidget,
        );
        expect(find.textContaining(strings.notSelectedLabel), findsNothing);
        expect(find.text(strings.finalizeLabel), findsOneWidget);
      },
    );
  }
}

class _AppointmentsStrings {
  const _AppointmentsStrings({
    required this.flowTitle,
    required this.serviceFieldFocusedAnnouncement,
    required this.firstServiceFocusedAnnouncement,
    required this.nutritionConsultationService,
    required this.nutritionConsultationSelectedAnnouncement,
    required this.continueLabel,
    required this.secondStepTitle,
    required this.cardiologistExpert,
    required this.cardiologistSelectedAnnouncement,
    required this.finalStepTitle,
    required this.firstTimeSlot,
    required this.firstTimeSlotSelectedAnnouncement,
    required this.summaryTitle,
    required this.notSelectedLabel,
    required this.finalizeLabel,
  });

  final String flowTitle;
  final String serviceFieldFocusedAnnouncement;
  final String firstServiceFocusedAnnouncement;
  final String nutritionConsultationService;
  final String nutritionConsultationSelectedAnnouncement;
  final String continueLabel;
  final String secondStepTitle;
  final String cardiologistExpert;
  final String cardiologistSelectedAnnouncement;
  final String finalStepTitle;
  final String firstTimeSlot;
  final String firstTimeSlotSelectedAnnouncement;
  final String summaryTitle;
  final String notSelectedLabel;
  final String finalizeLabel;

  static _AppointmentsStrings forLocale(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return const _AppointmentsStrings(
          flowTitle: 'رزرو مرحله‌به‌مرحلهٔ نوبت رسمی',
          serviceFieldFocusedAnnouncement:
              'تمرکز روی فیلد جست‌وجوی خدمات قرار گرفت.',
          firstServiceFocusedAnnouncement:
              'تمرکز صفحه‌کلید روی گزینهٔ مشاورهٔ تغذیهٔ تخصصی قرار گرفت.',
          nutritionConsultationService: 'مشاورهٔ تغذیهٔ تخصصی',
          nutritionConsultationSelectedAnnouncement:
              'گزینهٔ مشاورهٔ تغذیهٔ تخصصی انتخاب شد.',
          continueLabel: 'ادامه',
          secondStepTitle: 'مرحلهٔ دوم: انتخاب متخصص معتمد',
          cardiologistExpert: 'دکتر میلاد برومند – متخصص قلب',
          cardiologistSelectedAnnouncement:
              'گزینهٔ دکتر میلاد برومند – متخصص قلب انتخاب شد.',
          finalStepTitle: 'مرحلهٔ نهایی: تأیید زمان مراجعه',
          firstTimeSlot: 'سه‌شنبه ۲۵ مرداد، ساعت ۱۰:۳۰',
          firstTimeSlotSelectedAnnouncement:
              'گزینهٔ سه‌شنبه ۲۵ مرداد، ساعت ۱۰:۳۰ انتخاب شد.',
          summaryTitle: 'خلاصهٔ درخواست',
          notSelectedLabel: 'هنوز انتخاب نشده است',
          finalizeLabel: 'ثبت نهایی نوبت',
        );
      case 'fa':
      default:
        return const _AppointmentsStrings(
          flowTitle: 'رزرو مرحله‌به‌مرحلهٔ نوبت رسمی',
          serviceFieldFocusedAnnouncement:
              'تمرکز روی فیلد جست‌وجوی خدمات قرار گرفت.',
          firstServiceFocusedAnnouncement:
              'تمرکز صفحه‌کلید روی گزینهٔ مشاورهٔ تغذیهٔ تخصصی قرار گرفت.',
          nutritionConsultationService: 'مشاورهٔ تغذیهٔ تخصصی',
          nutritionConsultationSelectedAnnouncement:
              'گزینهٔ مشاورهٔ تغذیهٔ تخصصی انتخاب شد.',
          continueLabel: 'ادامه',
          secondStepTitle: 'مرحلهٔ دوم: انتخاب متخصص معتمد',
          cardiologistExpert: 'دکتر میلاد برومند – متخصص قلب',
          cardiologistSelectedAnnouncement:
              'گزینهٔ دکتر میلاد برومند – متخصص قلب انتخاب شد.',
          finalStepTitle: 'مرحلهٔ نهایی: تأیید زمان مراجعه',
          firstTimeSlot: 'سه‌شنبه ۲۵ مرداد، ساعت ۱۰:۳۰',
          firstTimeSlotSelectedAnnouncement:
              'گزینهٔ سه‌شنبه ۲۵ مرداد، ساعت ۱۰:۳۰ انتخاب شد.',
          summaryTitle: 'خلاصهٔ درخواست',
          notSelectedLabel: 'هنوز انتخاب نشده است',
          finalizeLabel: 'ثبت نهایی نوبت',
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
