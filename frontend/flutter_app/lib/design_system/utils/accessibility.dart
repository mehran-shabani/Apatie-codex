import 'package:flutter/material.dart';

/// Utilities to keep animations accessible and consistent with system settings.
class AccessibilityUtils {
  const AccessibilityUtils._();

  /// Whether motion should be reduced based on platform accessibility settings.
  static bool reduceMotion(BuildContext context) {
    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery == null) {
      return false;
    }
    return mediaQuery.disableAnimations || mediaQuery.accessibleNavigation;
  }

  /// Returns a duration that respects the current accessibility preferences.
  static Duration motionAwareDuration(
    BuildContext context, {
    int milliseconds = 180,
  }) {
    final clamped = milliseconds.clamp(0, 200);
    if (reduceMotion(context)) {
      return Duration.zero;
    }
    return Duration(milliseconds: clamped);
  }
}
