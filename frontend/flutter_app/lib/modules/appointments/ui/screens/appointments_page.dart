import 'package:flutter/material.dart';
import 'package:apatie/l10n/app_localizations.dart';

class AppointmentsPage extends StatelessWidget {
  const AppointmentsPage({super.key});

  static const String routeName = 'appointments';
  static const String routePath = '/appointments';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Center(
      child: Text(
        localizations.appointmentsHeadline,
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
