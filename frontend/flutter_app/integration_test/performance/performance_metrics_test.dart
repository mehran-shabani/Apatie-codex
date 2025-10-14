import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vm_service/vm_service.dart';

import 'package:apatie/app.dart';

class _InMemoryHydratedStorage implements HydratedStorage {
  _InMemoryHydratedStorage();

  final Map<String, dynamic> _store = <String, dynamic>{};

  @override
  Future<void> clear() async => _store.clear();

  @override
  Future<void> close() async {}

  @override
  Future<void> delete(String key) async => _store.remove(key);

  @override
  dynamic read(String key) => _store[key];

  @override
  Future<void> write(String key, dynamic value) async => _store[key] = value;
}

final IntegrationTestWidgetsFlutterBinding _binding =
    IntegrationTestWidgetsFlutterBinding.ensureInitialized()
        as IntegrationTestWidgetsFlutterBinding;

final Map<String, dynamic> _performanceReport = <String, dynamic>{};

void _recordMetrics(String key, Map<String, Object?> metrics) {
  _performanceReport[key] = metrics;
  _binding.reportData = Map<String, dynamic>.from(_performanceReport);
}

double _durationToMillis(Duration duration) =>
    duration.inMicroseconds / Duration.microsecondsPerMillisecond;

double _averageMillis(Iterable<Duration> durations) {
  final values = durations
      .map((duration) => duration.inMicroseconds)
      .where((value) => value > 0)
      .toList();
  if (values.isEmpty) {
    return 0;
  }
  final total = values.reduce((a, b) => a + b);
  return total / values.length / Duration.microsecondsPerMillisecond;
}

int _countOverBudget(Iterable<Duration> durations, Duration budget) =>
    durations.where((duration) => duration > budget).length;

double _bytesToMegabytes(num bytes) => bytes / (1024 * 1024);

void main() {
  _binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.benchmark;

  setUpAll(() {
    HydratedBloc.storage = _InMemoryHydratedStorage();
  });

  tearDownAll(() {
    debugPrint('PERFORMANCE_METRICS:${jsonEncode(_performanceReport)}');
  });

  testWidgets('startup first frame stays under budget', (tester) async {
    final watchResult = await _binding.watchPerformance(() async {
      await tester.pumpWidget(App());
      await tester.pumpAndSettle();
    }, reportKey: 'startup_timeline');

    final frameTimings = watchResult.frameTimings;
    expect(frameTimings, isNotEmpty,
        reason: 'Performance tracing did not capture any frames.');

    final FrameTiming firstFrame = frameTimings.first;
    final double firstFrameBuildMillis =
        _durationToMillis(firstFrame.buildDuration);
    final double firstFrameRasterMillis =
        _durationToMillis(firstFrame.rasterDuration);

    const double maxFirstFrameBuildMillis = 180;
    const double maxFirstFrameRasterMillis = 180;

    _recordMetrics('startup', <String, Object?>{
      'first_frame_build_millis': firstFrameBuildMillis,
      'first_frame_raster_millis': firstFrameRasterMillis,
      'frame_count': frameTimings.length,
      'timeline': watchResult.timelineSummary?.summaryJson,
    });

    expect(
      firstFrameBuildMillis,
      lessThanOrEqualTo(maxFirstFrameBuildMillis),
      reason:
          'The first frame took ${firstFrameBuildMillis.toStringAsFixed(2)}ms to build (budget $maxFirstFrameBuildMillis ms).',
    );

    expect(
      firstFrameRasterMillis,
      lessThanOrEqualTo(maxFirstFrameRasterMillis),
      reason:
          'The first frame took ${firstFrameRasterMillis.toStringAsFixed(2)}ms to rasterize (budget $maxFirstFrameRasterMillis ms).',
    );
  });

  testWidgets('scrolling remains smooth under interaction budget',
      (tester) async {
    final watchResult = await _binding.watchPerformance(() async {
      await tester.pumpWidget(App());
      await tester.pumpAndSettle();

      final Finder scrollable = find.byType(Scrollable).first;
      await tester.fling(scrollable, const Offset(0, -600), 1000);
      await tester.pumpAndSettle();
      await tester.fling(scrollable, const Offset(0, 600), 1000);
      await tester.pumpAndSettle();
    }, reportKey: 'scroll_timeline');

    final frameTimings = watchResult.frameTimings
        .where((timing) => timing.buildDuration > Duration.zero)
        .toList();
    expect(frameTimings, isNotEmpty,
        reason: 'Scroll trace did not include any frame timings.');

    final averageBuildMillis =
        _averageMillis(frameTimings.map((timing) => timing.buildDuration));
    final averageRasterMillis =
        _averageMillis(frameTimings.map((timing) => timing.rasterDuration));
    final worstBuildMillis = frameTimings
        .map((timing) => _durationToMillis(timing.buildDuration))
        .reduce(math.max);
    final worstRasterMillis = frameTimings
        .map((timing) => _durationToMillis(timing.rasterDuration))
        .reduce(math.max);

    const Duration frameBudget = Duration(milliseconds: 16);
    final int jankyFrameCount = _countOverBudget(
      frameTimings.map((timing) => timing.buildDuration),
      frameBudget,
    );
    final double jankPercentage =
        (jankyFrameCount / frameTimings.length) * 100;

    const double maxAverageBuildMillis = 24;
    const double maxAverageRasterMillis = 28;
    const double maxJankPercentage = 20;

    _recordMetrics('scroll', <String, Object?>{
      'average_build_millis': averageBuildMillis,
      'average_raster_millis': averageRasterMillis,
      'worst_build_millis': worstBuildMillis,
      'worst_raster_millis': worstRasterMillis,
      'janky_frame_percentage': jankPercentage,
      'frame_count': frameTimings.length,
    });

    expect(
      averageBuildMillis,
      lessThanOrEqualTo(maxAverageBuildMillis),
      reason:
          'Average scroll build time ${averageBuildMillis.toStringAsFixed(2)}ms exceeded the $maxAverageBuildMillis ms budget.',
    );
    expect(
      averageRasterMillis,
      lessThanOrEqualTo(maxAverageRasterMillis),
      reason:
          'Average scroll raster time ${averageRasterMillis.toStringAsFixed(2)}ms exceeded the $maxAverageRasterMillis ms budget.',
    );
    expect(
      jankPercentage,
      lessThanOrEqualTo(maxJankPercentage),
      reason:
          'Scroll jank affected ${jankPercentage.toStringAsFixed(2)}% of frames (budget $maxJankPercentage%).',
    );
  });

  testWidgets('memory footprint is within limits after warm-up',
      (tester) async {
    await tester.pumpWidget(App());
    await tester.pumpAndSettle();

    final VmService? vmService = await _binding.vmService;
    expect(vmService, isNotNull,
        reason: 'VM service was not available for memory collection.');
    final VM vm = await vmService!.getVM();

    final Iterable<IsolateRef> isolates = vm.isolates ?? const <IsolateRef>[];
    final Map<String, Object?> isolateMetrics = <String, Object?>{};
    int totalHeapUsageBytes = 0;
    int totalExternalUsageBytes = 0;

    for (final IsolateRef isolate in isolates) {
      final String? isolateId = isolate.id;
      if (isolateId == null) {
        continue;
      }
      final MemoryUsage usage = await vmService.getMemoryUsage(isolateId);
      totalHeapUsageBytes += usage.heapUsage ?? 0;
      totalExternalUsageBytes += usage.externalUsage ?? 0;
      isolateMetrics[isolate.name ?? isolateId] = <String, num?>{
        'heap_usage_bytes': usage.heapUsage,
        'external_usage_bytes': usage.externalUsage,
      };
    }

    final double totalHeapUsageMb =
        _bytesToMegabytes(totalHeapUsageBytes.toDouble());
    final double totalExternalUsageMb =
        _bytesToMegabytes(totalExternalUsageBytes.toDouble());

    const double maxHeapUsageMb = 256;
    const double maxExternalUsageMb = 128;

    _recordMetrics('memory', <String, Object?>{
      'heap_usage_mb': totalHeapUsageMb,
      'external_usage_mb': totalExternalUsageMb,
      'isolates': isolateMetrics,
    });

    expect(
      totalHeapUsageMb,
      lessThanOrEqualTo(maxHeapUsageMb),
      reason:
          'Total heap usage ${totalHeapUsageMb.toStringAsFixed(2)}MB exceeded the $maxHeapUsageMb MB budget.',
    );
    expect(
      totalExternalUsageMb,
      lessThanOrEqualTo(maxExternalUsageMb),
      reason:
          'External memory usage ${totalExternalUsageMb.toStringAsFixed(2)}MB exceeded the $maxExternalUsageMb MB budget.',
    );
  });
}
