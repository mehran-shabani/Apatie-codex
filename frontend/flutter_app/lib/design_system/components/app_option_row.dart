import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/design_system/components/app_component_states.dart';
import 'package:flutter_app/design_system/foundations/radii.dart';
import 'package:flutter_app/design_system/foundations/spacing.dart';

class AppOptionRow extends StatefulWidget {
  const AppOptionRow({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.selected = false,
    this.disabled = false,
    this.compact = false,
    this.isLoading = false,
    this.tone = AppComponentStatus.neutral,
    this.onTap,
    this.onFocusChange,
    this.onHoverChange,
    this.onEventAnnounced,
    this.semanticLabel,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final bool selected;
  final bool disabled;
  final bool compact;
  final bool isLoading;
  final AppComponentStatus tone;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onFocusChange;
  final ValueChanged<bool>? onHoverChange;
  final ValueChanged<String>? onEventAnnounced;
  final String? semanticLabel;

  bool get interactive => onTap != null && !disabled;

  @override
  State<AppOptionRow> createState() => _AppOptionRowState();
}

class _AppOptionRowState extends State<AppOptionRow> {
  bool _hovered = false;
  bool _focused = false;

  void _announce(String message) {
    if (widget.onEventAnnounced != null) {
      widget.onEventAnnounced!(message);
    } else {
      SemanticsService.announce(message, Directionality.of(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = resolveComponentColors(
      context,
      status: widget.selected ? AppComponentStatus.info : widget.tone,
      highlighted: _hovered || _focused,
      disabled: widget.disabled,
    );
    final theme = Theme.of(context);

    final padding = EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: widget.compact ? AppSpacing.xs : AppSpacing.sm,
    );

    final content = Row(
      children: [
        if (widget.leading != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
            child: widget.leading!,
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colors.foreground,
                  fontWeight: widget.selected ? FontWeight.w600 : null,
                ),
              ),
              if (widget.subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Text(
                    widget.subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.foreground.withOpacity(0.8),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (widget.trailing != null)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: AppSpacing.sm),
            child: widget.trailing!,
          ),
      ],
    );

    final decorated = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeInOut,
      padding: padding,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: widget.compact ? AppRadii.smRadius : AppRadii.mdRadius,
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Stack(
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: widget.isLoading ? 0.5 : 1,
            child: content,
          ),
          if (widget.isLoading)
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: LinearProgressIndicator(
                  minHeight: 2,
                  color: colors.border,
                  backgroundColor: colors.background,
                ),
              ),
            ),
        ],
      ),
    );

    return FocusableActionDetector(
      enabled: widget.interactive,
      onShowHoverHighlight: (hovered) {
        if (_hovered != hovered) {
          setState(() => _hovered = hovered);
          widget.onHoverChange?.call(hovered);
          if (hovered) {
            _announce('نشانگر روی گزینهٔ ${widget.title} قرار گرفت.');
          }
        }
      },
      onShowFocusHighlight: (focused) {
        if (_focused != focused) {
          setState(() => _focused = focused);
          widget.onFocusChange?.call(focused);
          _announce(
            focused
                ? 'تمرکز صفحه‌کلید روی گزینهٔ ${widget.title} قرار گرفت.'
                : 'تمرکز صفحه‌کلید از گزینهٔ ${widget.title} برداشته شد.',
          );
        }
      },
      child: GestureDetector(
        onTap: widget.interactive
            ? () {
                _announce('گزینهٔ ${widget.title} انتخاب شد.');
                widget.onTap?.call();
              }
            : null,
        child: Semantics(
          button: widget.interactive,
          label: widget.semanticLabel ?? 'گزینهٔ ${widget.title}',
          enabled: !widget.disabled,
          selected: widget.selected,
          child: decorated,
        ),
      ),
    );
  }
}
