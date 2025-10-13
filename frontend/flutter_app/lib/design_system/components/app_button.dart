import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/design_system/components/app_component_states.dart';
import 'package:flutter_app/design_system/foundations/radii.dart';
import 'package:flutter_app/design_system/foundations/shadows.dart';
import 'package:flutter_app/design_system/foundations/spacing.dart';
import 'package:flutter_app/design_system/foundations/touch_targets.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.tone = AppComponentStatus.neutral,
    this.compact = false,
    this.isLoading = false,
    this.leadingIcon,
    this.leadingIconSemanticLabel,
    this.trailingIcon,
    this.trailingIconSemanticLabel,
    this.onFocusChange,
    this.onHoverChange,
    this.onEventAnnounced,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppComponentStatus tone;
  final bool compact;
  final bool isLoading;
  final Widget? leadingIcon;
  final String? leadingIconSemanticLabel;
  final Widget? trailingIcon;
  final String? trailingIconSemanticLabel;
  final ValueChanged<bool>? onFocusChange;
  final ValueChanged<bool>? onHoverChange;
  final ValueChanged<String>? onEventAnnounced;
  final String? semanticLabel;

  bool get enabled => onPressed != null && !isLoading;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  void _announce(BuildContext context, String message) {
    if (widget.onEventAnnounced != null) {
      widget.onEventAnnounced!(message);
      return;
    }
    final direction = Directionality.of(context);
    SemanticsService.announce(message, direction);
  }

  AppShadowSet _shadows(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? AppShadows.dark : AppShadows.light;
  }

  void _handleFocus(bool focused) {
    if (_focused != focused) {
      setState(() {
        _focused = focused;
      });
      widget.onFocusChange?.call(focused);
      final message = focused
          ? 'تمرکز صفحه‌کلید روی دکمهٔ ${widget.label} قرار گرفت.'
          : 'تمرکز صفحه‌کلید از دکمهٔ ${widget.label} برداشته شد.';
      _announce(context, message);
    }
  }

  void _handleHover(bool hovered) {
    if (_hovered != hovered) {
      setState(() {
        _hovered = hovered;
      });
      widget.onHoverChange?.call(hovered);
      if (hovered) {
        _announce(context, 'نشانگر روی دکمهٔ ${widget.label} قرار گرفت.');
      }
    }
  }

  void _handlePressed(bool pressed) {
    if (_pressed != pressed) {
      setState(() {
        _pressed = pressed;
      });
      if (pressed) {
        _announce(context, 'دکمهٔ ${widget.label} فشرده شد.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = resolveComponentColors(
      context,
      status: widget.tone,
      highlighted: _hovered || _focused,
      disabled: !widget.enabled,
    );

    final padding = EdgeInsets.symmetric(
      horizontal: widget.compact ? AppSpacing.md : AppSpacing.lg,
      vertical: widget.compact ? AppSpacing.xs : AppSpacing.sm,
    );

    final shadow = _focused
        ? _shadows(context).level1
        : (_hovered ? _shadows(context).level1 : const <BoxShadow>[]);

    final labelStyle = theme.textTheme.labelLarge?.copyWith(
      color: colors.foreground,
    );

    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeInOut,
      padding: padding,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: widget.compact ? AppRadii.smRadius : AppRadii.mdRadius,
        border: Border.all(color: colors.border, width: 1),
        boxShadow: shadow,
      ),
      constraints: const BoxConstraints(
        minHeight: AppTouchTargets.minInteractiveHeight,
        minWidth: AppTouchTargets.minInteractiveWidth,
      ),
      child: _ButtonContent(
        label: widget.label,
        labelStyle: labelStyle,
        isLoading: widget.isLoading,
        leadingIcon: widget.leadingIcon,
        leadingIconSemanticLabel: widget.leadingIconSemanticLabel,
        trailingIcon: widget.trailingIcon,
        trailingIconSemanticLabel: widget.trailingIconSemanticLabel,
        foreground: colors.foreground,
      ),
    );

    return FocusableActionDetector(
      enabled: widget.enabled,
      onShowFocusHighlight: _handleFocus,
      onFocusChange: _handleFocus,
      onShowHoverHighlight: _handleHover,
      mouseCursor:
          widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTapDown: widget.enabled ? (_) => _handlePressed(true) : null,
        onTapCancel: widget.enabled ? () => _handlePressed(false) : null,
        onTapUp: widget.enabled
            ? (_) {
                _handlePressed(false);
                widget.onPressed?.call();
              }
            : null,
        child: Semantics(
          button: true,
          enabled: widget.enabled,
          label: widget.semanticLabel ?? 'دکمهٔ ${widget.label}',
          child: child,
        ),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.labelStyle,
    required this.isLoading,
    required this.foreground,
    this.leadingIcon,
    this.leadingIconSemanticLabel,
    this.trailingIcon,
    this.trailingIconSemanticLabel,
  });

  final String label;
  final TextStyle? labelStyle;
  final bool isLoading;
  final Color foreground;
  final Widget? leadingIcon;
  final String? leadingIconSemanticLabel;
  final Widget? trailingIcon;
  final String? trailingIconSemanticLabel;

  @override
  Widget build(BuildContext context) {
    final indicator = SizedBox.square(
      dimension: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(foreground),
      ),
    );

    final children = <Widget>[
      if (leadingIcon != null)
        Semantics(
          label: leadingIconSemanticLabel,
          child: IconTheme(
            data: IconThemeData(color: foreground, size: 20),
            child: leadingIcon!,
          ),
        ),
      if (!isLoading)
        Flexible(
          child: Text(
            label,
            style: labelStyle,
            overflow: TextOverflow.ellipsis,
          ),
        )
      else
        Flexible(
          child: Text(
            '$label (در حال بارگذاری)',
            style: labelStyle,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      if (isLoading) indicator,
      if (!isLoading && trailingIcon != null)
        Semantics(
          label: trailingIconSemanticLabel,
          child: IconTheme(
            data: IconThemeData(color: foreground, size: 20),
            child: trailingIcon!,
          ),
        ),
    ];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Row(
        key: ValueKey<bool>(isLoading),
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(width: AppSpacing.xs),
            children[i],
          ],
        ],
      ),
    );
  }
}
