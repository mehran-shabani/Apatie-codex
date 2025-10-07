import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('fa')];

  static const _localizedValues = {
    'en': {
      'appointmentsTab': 'Appointments',
      'appointmentsTitle': 'Appointments module coming soon',
      'marketplaceTab': 'Marketplace',
      'marketplaceTitle': 'Marketplace module coming soon',
      'servicesTab': 'Services',
      'servicesTitle': 'Services module coming soon',
    },
    'fa': {
      'appointmentsTab': 'نوبت‌دهی',
      'appointmentsTitle': 'ماژول نوبت‌دهی به‌زودی',
      'marketplaceTab': 'محصولات',
      'marketplaceTitle': 'بازار محصولات خانگی به‌زودی',
      'servicesTab': 'خدمات',
      'servicesTitle': 'خدمات سیار به‌زودی',
    },
  };

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  String get appointmentsTab => _string('appointmentsTab');
  String get appointmentsTitle => _string('appointmentsTitle');
  String get marketplaceTab => _string('marketplaceTab');
  String get marketplaceTitle => _string('marketplaceTitle');
  String get servicesTab => _string('servicesTab');
  String get servicesTitle => _string('servicesTitle');

  String _string(String key) {
    final values = _localizedValues[locale.languageCode] ?? _localizedValues['en']!;
    return values[key] ?? _localizedValues['en']![key]!;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.map((l) => l.languageCode).contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
