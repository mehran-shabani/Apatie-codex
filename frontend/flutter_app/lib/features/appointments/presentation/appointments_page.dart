import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  static const String routeName = 'appointments';

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return Center(
      child: Text(localization.appointmentsTitle),
    );
  }
}
