// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Apatie Codex';

  @override
  String get appointmentsTab => 'Appointments';

  @override
  String get marketplaceTab => 'Products';

  @override
  String get servicesTab => 'Services';

  @override
  String get appointmentsHeadline => 'Manage your appointments';

  @override
  String get marketplaceHeadline => 'Browse available products';

  @override
  String get servicesHeadline => 'Discover services';

  @override
  String get themeToggleTooltip => 'Toggle theme';
}
