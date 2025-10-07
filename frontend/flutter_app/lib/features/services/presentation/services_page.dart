import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  static const String routeName = 'services';

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return Center(
      child: Text(localization.servicesTitle),
    );
  }
}
