import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:apatie/design_system/foundations/spacing.dart';

/// Provides a consistent layout for arranging component state previews within
/// golden tests. Each section renders a title followed by evenly spaced tiles
/// that contain the example widgets.
class ComponentStateGallery extends StatelessWidget {
  const ComponentStateGallery({
    super.key,
    required this.sections,
  });

  final List<ComponentStateSection> sections;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (final section in sections) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(height: AppSpacing.xl));
      }
      children.add(section);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class ComponentStateSection extends StatelessWidget {
  const ComponentStateSection({
    super.key,
    required this.title,
    required this.tiles,
  });

  final String title;
  final List<ComponentStateTile> tiles;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          textAlign: TextAlign.right,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          alignment: WrapAlignment.end,
          runSpacing: AppSpacing.lg,
          spacing: AppSpacing.lg,
          children: tiles,
        ),
      ],
    );
  }
}

class ComponentStateTile extends StatelessWidget {
  const ComponentStateTile({
    super.key,
    required this.label,
    required this.child,
    this.width = 280,
  });

  final String label;
  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            textAlign: TextAlign.right,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

/// Forces the wrapped widget into a hovered visual state by dispatching a
/// synthetic pointer event once layout is complete. Each instance uses a unique
/// pointer device id so multiple hover examples can coexist in a single frame.
class GoldenHoverActivator extends StatefulWidget {
  const GoldenHoverActivator({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<GoldenHoverActivator> createState() => _GoldenHoverActivatorState();
}

class _GoldenHoverActivatorState extends State<GoldenHoverActivator> {
  static int _nextDeviceId = 950000;
  final GlobalKey _targetKey = GlobalKey();
  bool _activated = false;
  late final int _deviceId;

  @override
  void initState() {
    super.initState();
    _deviceId = _nextDeviceId++;
  }

  void _dispatchHover() {
    if (_activated) return;
    final context = _targetKey.currentContext;
    if (context == null) return;
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox) return;
    final offset = renderObject.localToGlobal(
      renderObject.size.center(Offset.zero),
    );
    final binding = WidgetsBinding.instance;
    binding.handlePointerEvent(
      PointerAddedEvent(
        position: offset,
        device: _deviceId,
        kind: PointerDeviceKind.mouse,
      ),
    );
    binding.handlePointerEvent(
      PointerHoverEvent(
        position: offset,
        device: _deviceId,
        kind: PointerDeviceKind.mouse,
      ),
    );
    _activated = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _dispatchHover());
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _targetKey,
      child: widget.child,
    );
  }
}

/// Requests focus for the provided [FocusNode] after the first frame so that
/// widgets can display their focused or active styling in golden captures.
class GoldenFocusActivator extends StatefulWidget {
  const GoldenFocusActivator({
    super.key,
    required this.focusNode,
    required this.child,
  });

  final FocusNode focusNode;
  final Widget child;

  @override
  State<GoldenFocusActivator> createState() => _GoldenFocusActivatorState();
}

class _GoldenFocusActivatorState extends State<GoldenFocusActivator> {
  bool _requested = false;

  void _request() {
    if (_requested) return;
    if (!widget.focusNode.canRequestFocus) return;
    final scope = FocusScope.of(context);
    if (!scope.hasFocus) {
      scope.requestFocus(widget.focusNode);
    } else {
      widget.focusNode.requestFocus();
    }
    _requested = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _request());
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: widget.focusNode,
      child: widget.child,
    );
  }
}
