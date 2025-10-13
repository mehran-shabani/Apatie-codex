import 'package:flutter/material.dart';
import 'package:apatie/design_system/components/app_component_states.dart';
import 'package:apatie/design_system/components/app_option_row.dart';
import 'package:apatie/design_system/foundations/spacing.dart';

class AppListItem {
  const AppListItem({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.selected = false,
    this.disabled = false,
    this.compact = false,
    this.isLoading = false,
    this.tone,
    this.onTap,
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
  final AppComponentStatus? tone;
  final VoidCallback? onTap;
  final String? semanticLabel;
}

class AppList extends StatelessWidget {
  const AppList({
    super.key,
    required this.items,
    this.padding,
    this.separated = true,
    this.semanticLabel,
  });

  final List<AppListItem> items;
  final EdgeInsetsGeometry? padding;
  final bool separated;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: semanticLabel ?? 'فهرست گزینه‌ها',
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: padding ?? const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        itemBuilder: (context, index) {
          final item = items[index];
          return AppOptionRow(
            title: item.title,
            subtitle: item.subtitle,
            leading: item.leading,
            trailing: item.trailing,
            selected: item.selected,
            disabled: item.disabled,
            compact: item.compact,
            isLoading: item.isLoading,
            tone: item.tone ?? AppComponentStatus.neutral,
            onTap: item.onTap,
            semanticLabel: item.semanticLabel,
          );
        },
        separatorBuilder: (context, index) =>
            separated ? const SizedBox(height: AppSpacing.sm) : const SizedBox.shrink(),
        itemCount: items.length,
      ),
    );
  }
}
