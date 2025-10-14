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

        expect(find.text('رزرو مرحله‌به‌مرحلهٔ نوبت رسمی'), findsOneWidget);

        final initialProgress =
            tester.widget<AppProgressIndicator>(find.byType(AppProgressIndicator).first);
        expect(initialProgress.value, moreOrLessEquals(1 / 3));

        await tester.tap(find.byType(TextField).first);
        await tester.pump();
        expect(
          announcements,
          contains('تمرکز روی فیلد جست‌وجوی خدمات قرار گرفت.'),
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(
          announcements,
          contains('تمرکز صفحه‌کلید روی گزینهٔ مشاورهٔ تغذیهٔ تخصصی قرار گرفت.'),
        );

        await tester.tap(find.text('مشاورهٔ تغذیهٔ تخصصی'));
        await tester.pump();
        expect(
          announcements,
          contains('گزینهٔ مشاورهٔ تغذیهٔ تخصصی انتخاب شد.'),
        );

        await tester.tap(find.text('ادامه'));
        await tester.pumpAndSettle();
        expect(find.text('مرحلهٔ دوم: انتخاب متخصص معتمد'), findsOneWidget);

        final secondStepProgress =
            tester.widget<AppProgressIndicator>(find.byType(AppProgressIndicator).first);
        expect(secondStepProgress.value, moreOrLessEquals(2 / 3));

        await tester.tap(find.text('دکتر میلاد برومند – متخصص قلب'));
        await tester.pump();
        expect(
          announcements,
          contains('گزینهٔ دکتر میلاد برومند – متخصص قلب انتخاب شد.'),
        );

        await tester.tap(find.text('ادامه'));
        await tester.pumpAndSettle();
        expect(find.text('مرحلهٔ نهایی: تأیید زمان مراجعه'), findsOneWidget);

        final finalProgress =
            tester.widget<AppProgressIndicator>(find.byType(AppProgressIndicator).first);
        expect(finalProgress.value, moreOrLessEquals(1));

        await tester.tap(find.text('سه‌شنبه ۲۵ مرداد، ساعت ۱۰:۳۰'));
        await tester.pump();
        expect(
          announcements,
          contains('گزینهٔ سه‌شنبه ۲۵ مرداد، ساعت ۱۰:۳۰ انتخاب شد.'),
        );

        final summaryCard = find.ancestor(
          of: find.text('خلاصهٔ درخواست'),
          matching: find.byType(AppCard),
        );

        expect(
          find.descendant(
            of: summaryCard,
            matching: find.text('مشاورهٔ تغذیهٔ تخصصی'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: summaryCard,
            matching: find.text('دکتر میلاد برومند – متخصص قلب'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: summaryCard,
            matching: find.text('سه‌شنبه ۲۵ مرداد، ساعت ۱۰:۳۰'),
          ),
          findsOneWidget,
        );
        expect(find.textContaining('هنوز انتخاب نشده است'), findsNothing);
        expect(find.text('ثبت نهایی نوبت'), findsOneWidget);
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
