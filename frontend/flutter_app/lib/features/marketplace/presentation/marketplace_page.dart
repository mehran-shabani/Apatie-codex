import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class MarketplacePage extends StatelessWidget {
  const MarketplacePage({super.key});

  static const String routeName = 'marketplace';

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return Center(
      child: Text(localization.marketplaceTitle),
    );
  }
}
