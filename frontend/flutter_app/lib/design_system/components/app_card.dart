import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/foundations/radii.dart';
import 'package:apatie/design_system/foundations/shadows.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:apatie/design_system/foundations/touch_targets.dart';
import 'package:apatie/design_system/utils/accessibility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppCard extends StatefulWidget {
  const AppCard({
    super.key,
    required this.child,
    this.header,
    this.footer,
    this.onTap,
    this.compact = false,
    this.tone = AppComponentStatus.neutral,
    this.isLoading = false,
    this.disabled = false,
    this.onEventAnnounced,
    this.semanticLabel,
  });

  final Widget child;
  final Widget? header;
  final Widget? footer;
  final VoidCallback? onTap;
  final bool compact;
  final AppComponentStatus tone;
  final bool isLoading;
  final bool disabled;
  final ValueChanged<String>? onEventAnnounced;
  final String? semanticLabel;

  bool get interactive => onTap != null && !disabled;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _hovered = false;
  bool _focused = false;

  void _announce(String message) {
    if (widget.onEventAnnounced != null) {
      widget.onEventAnnounced!(message);
    } else {
      SemanticsService.announce(message, Directionality.of(context));
    }
  }

  AppShadowSet _shadows(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppShadows.dark
        : AppShadows.light;
  }

  @override
  Widget build(BuildContext context) {
    final colors = resolveComponentColors(
      context,
      status: widget.tone,
      highlighted: _hovered || _focused,
      disabled: widget.disabled,
    );

    final theme = Theme.of(context);
    final contentPadding = EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: widget.compact ? AppSpacing.sm : AppSpacing.md,
    );

    final reduceMotion = AccessibilityUtils.reduceMotion(context);
    final containerDuration =
        AccessibilityUtils.motionAwareDuration(context, milliseconds: 180);
    final fadeDuration =
        AccessibilityUtils.motionAwareDuration(context, milliseconds: 160);

    final cardBody = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.header != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: widget.header!,
          ),
        widget.child,
        if (widget.footer != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: widget.footer!,
          ),
      ],
    );

    final decorated = ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: AppTouchTargets.minimumHeight,
        minWidth: AppTouchTargets.minInteractiveWidth,
      ),
      child: AnimatedContainer(
        duration: containerDuration,
        curve: reduceMotion ? Curves.linear : Curves.easeInOut,
        padding: contentPadding,
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: widget.compact ? AppRadii.mdRadius : AppRadii.lgRadius,
          border: Border.all(color: colors.border, width: 1),
          boxShadow: _hovered || _focused ? _shadows(context).level1 : null,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedOpacity(
                duration: fadeDuration,
                curve: reduceMotion ? Curves.linear : Curves.easeInOut,
                opacity: widget.isLoading ? 0.5 : 1,
                child: cardBody,
              ),
            ),
            if (widget.isLoading)
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Semantics(
                      label: 'در حال بارگذاری کارت',
                      child: LinearProgressIndicator(
                        minHeight: 2,
                        backgroundColor: colors.background,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    final semantics = Semantics(
      label: widget.semanticLabel ?? 'کارت اطلاعاتی',
      button: widget.interactive,
      enabled: !widget.disabled,
      child: decorated,
    );

    final focusable = FocusableActionDetector(
      enabled: widget.interactive,
      onShowHoverHighlight: (value) {
        if (_hovered != value) {
          setState(() => _hovered = value);
          if (value) {
            _announce('نشانگر روی کارت قرار گرفت.');
          }
        }
      },
      onShowFocusHighlight: (value) {
        if (_focused != value) {
          setState(() => _focused = value);
          _announce(
            value
                ? 'تمرکز صفحه‌کلید روی کارت قرار گرفت.'
                : 'تمرکز صفحه‌کلید از کارت برداشته شد.',
          );
        }
      },
      child: GestureDetector(
        onTap: widget.interactive
            ? () {
                _announce('کارت انتخاب شد.');
                widget.onTap?.call();
              }
            : null,
        child: semantics,
      ),
    );

    return focusable;
  }
}
