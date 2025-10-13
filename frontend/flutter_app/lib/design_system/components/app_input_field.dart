import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/components/app_button.dart';
import 'package:apatie/design_system/foundations/radii.dart';
import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:apatie/design_system/foundations/touch_targets.dart';
import 'package:apatie/design_system/utils/accessibility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppInputField extends StatefulWidget {
  const AppInputField({
    super.key,
    required this.label,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.helperText,
    this.placeholder,
    this.tone = AppComponentStatus.neutral,
    this.compact = false,
    this.isLoading = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.onEventAnnounced,
    this.semanticLabel,
    this.errorText,
    this.onRetry,
    this.retryLabel = 'تلاش دوباره',
  });

  final String label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? helperText;
  final String? placeholder;
  final AppComponentStatus tone;
  final bool compact;
  final bool isLoading;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final ValueChanged<String>? onEventAnnounced;
  final String? semanticLabel;
  final String? errorText;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  late FocusNode _focusNode;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(covariant AppInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode && widget.focusNode != null) {
      _focusNode.removeListener(_handleFocusChange);
      _focusNode = widget.focusNode!;
      _focusNode.addListener(_handleFocusChange);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _announce('تمرکز روی فیلد ${widget.label} قرار گرفت.');
    } else {
      _announce('تمرکز از فیلد ${widget.label} برداشته شد.');
    }
    setState(() {});
  }

  void _announce(String message) {
    if (widget.onEventAnnounced != null) {
      widget.onEventAnnounced!(message);
    } else {
      SemanticsService.announce(message, Directionality.of(context));
    }
  }

  InputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: widget.compact ? AppRadii.smRadius : AppRadii.mdRadius,
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = resolveComponentColors(
      context,
      status: widget.tone,
      highlighted: _hovered || _focusNode.hasFocus,
      disabled: !widget.enabled,
    );

    final reduceMotion = AccessibilityUtils.reduceMotion(context);
    final errorDuration =
        AccessibilityUtils.motionAwareDuration(context, milliseconds: 140);

    final field = ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: AppTouchTargets.minInteractiveHeight,
        minWidth: AppTouchTargets.minInteractiveWidth,
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.placeholder,
          helperText:
              widget.isLoading ? 'در حال بارگذاری داده' : widget.helperText,
          errorText: widget.errorText,
          errorMaxLines: 2,
          filled: true,
          fillColor: colors.background,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: widget.compact ? AppSpacing.xs : AppSpacing.sm,
          ),
          border: _border(colors.border),
          enabledBorder: _border(colors.border),
          focusedBorder: _border(
            theme.colorScheme.primary,
            width: 2,
          ),
          disabledBorder: _border(colors.border.withOpacity(0.4)),
          errorBorder: _border(theme.colorScheme.error),
          focusedErrorBorder: _border(theme.colorScheme.error, width: 2),
          labelStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colors.foreground,
          ),
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colors.foreground.withOpacity(0.7),
          ),
          helperStyle: theme.textTheme.bodySmall?.copyWith(
            color: colors.foreground.withOpacity(0.7),
          ),
          errorStyle: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: theme.textTheme.bodyLarge?.copyWith(color: colors.foreground),
      ),
    );

    final semanticsHintParts = [
      if (widget.placeholder != null) widget.placeholder!,
      if (widget.errorText != null) 'خطا: ${widget.errorText}',
    ];

    final decorated = MouseRegion(
      cursor: widget.enabled ? SystemMouseCursors.text : SystemMouseCursors.basic,
      onEnter: (_) {
        if (!widget.enabled) {
          return;
        }
        setState(() => _hovered = true);
        _announce('نشانگر روی فیلد ${widget.label} قرار گرفت.');
      },
      onExit: (_) => setState(() => _hovered = false),
      child: Semantics(
        label: widget.semanticLabel ?? 'فیلد ورودی ${widget.label}',
        textField: true,
        enabled: widget.enabled,
        value: widget.controller?.text,
        hint: semanticsHintParts.isEmpty ? null : semanticsHintParts.join(' '),
        liveRegion: widget.errorText != null,
        child: field,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        decorated,
        if (widget.isLoading)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: colors.background,
              color: theme.colorScheme.primary,
            ),
          ),
        AnimatedSwitcher(
          duration: errorDuration,
          transitionBuilder: (child, animation) {
            if (reduceMotion) {
              return child;
            }
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: widget.errorText == null
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Semantics(
                    liveRegion: true,
                    label: 'خطا در ورود داده',
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.errorText!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (widget.onRetry != null)
                          Padding(
                            padding:
                                const EdgeInsetsDirectional.only(start: AppSpacing.sm),
                            child: AppButton(
                              label: widget.retryLabel,
                              onPressed: widget.onRetry,
                              tone: AppComponentStatus.warning,
                              compact: true,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
