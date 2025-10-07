import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({super.key});

  static const String routeName = 'marketplace';
  static const String routePath = '/marketplace';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Center(
      child: Text(
        localizations.marketplaceHeadline,
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
