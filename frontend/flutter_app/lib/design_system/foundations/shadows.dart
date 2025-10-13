import 'package:flutter/widgets.dart';

class AppShadowSet {
  const AppShadowSet({
    required this.level1,
    required this.level2,
    required this.level3,
    required this.shadowColor,
  });

  final List<BoxShadow> level1;
  final List<BoxShadow> level2;
  final List<BoxShadow> level3;
  final Color shadowColor;
}

class AppShadows {
  const AppShadows._();

  static const AppShadowSet light = AppShadowSet(
    level1: <BoxShadow>[
      BoxShadow(
        color: Color(0x14000000),
        blurRadius: 8,
        offset: Offset(0, 2),
        spreadRadius: 0,
      ),
    ],
    level2: <BoxShadow>[
      BoxShadow(
        color: Color(0x1A000000),
        blurRadius: 16,
        offset: Offset(0, 6),
        spreadRadius: -2,
      ),
    ],
    level3: <BoxShadow>[
      BoxShadow(
        color: Color(0x20000000),
        blurRadius: 24,
        offset: Offset(0, 12),
        spreadRadius: -4,
      ),
    ],
    shadowColor: Color(0x26000000),
  );

  static const AppShadowSet dark = AppShadowSet(
    level1: <BoxShadow>[
      BoxShadow(
        color: Color(0x33000000),
        blurRadius: 8,
        offset: Offset(0, 2),
        spreadRadius: 0,
      ),
    ],
    level2: <BoxShadow>[
      BoxShadow(
        color: Color(0x40000000),
        blurRadius: 20,
        offset: Offset(0, 8),
        spreadRadius: -2,
      ),
    ],
    level3: <BoxShadow>[
      BoxShadow(
        color: Color(0x4D000000),
        blurRadius: 28,
        offset: Offset(0, 16),
        spreadRadius: -4,
      ),
    ],
    shadowColor: Color(0x59000000),
  );
}
