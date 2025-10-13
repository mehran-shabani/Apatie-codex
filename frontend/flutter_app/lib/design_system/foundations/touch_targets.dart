import 'package:flutter/widgets.dart';

import 'spacing.dart';

class AppTouchTargets {
  const AppTouchTargets._();

  static const Size minimumSize = Size(48, 48);
  static const double minimumHeight = 48;
  static const double minInteractiveWidth = 48;
  static const double comfortableHeight = 56;
  static const double toolbarHeight = 64;
  static const double denseToolbarHeight = 56;
  static const double listTileHeight = 56;
  static const double compactListTileHeight = 48;
  static const EdgeInsets focusPadding = EdgeInsets.all(AppSpacing.xs);
  static const EdgeInsets touchPadding = EdgeInsets.all(AppSpacing.xs);
}
