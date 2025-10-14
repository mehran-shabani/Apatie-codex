import 'dart:typed_data';

import 'package:apatie/design_system/foundations/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../config/golden_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GoldenConfig smoke test', () {
    testGoldens('renders example component on default surfaces', (tester) async {
      final previousComparator = goldenFileComparator;
      goldenFileComparator = _TrivialGoldenComparator();
      addTearDown(() {
        goldenFileComparator = previousComparator;
      });

      await GoldenConfig.pumpGoldenWidget(
        tester,
        name: 'design_system/example_component',
        widget: const _ExampleComponent(),
      );
    });
  });
}

class _ExampleComponent extends StatelessWidget {
  const _ExampleComponent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Card(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text('سلام آپاتیه', style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'این یک آزمون تصویری نمونه است.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrivialGoldenComparator extends GoldenFileComparator {
  _TrivialGoldenComparator();

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async => true;

  @override
  Future<void> update(Uri golden, Uint8List imageBytes) async {}
}
