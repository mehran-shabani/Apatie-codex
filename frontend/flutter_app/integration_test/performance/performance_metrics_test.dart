import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vm_service/vm_service.dart' as vm;
import 'package:vm_service/vm_service_io.dart' as vm_io;

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
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

final Map<String, dynamic> _performanceReport = <String, dynamic>{};
vm.VmService? _vmService;

class _FramePerformanceSummary {
  _FramePerformanceSummary({
    required this.buildDurations,
    required this.rasterDurations,
    required this.report,
  });

  final List<Duration> buildDurations;
  final List<Duration> rasterDurations;
  final Map<String, dynamic> report;

  int get frameCount =>
      (report['frame_count'] as num?)?.toInt() ?? buildDurations.length;

  Duration get firstBuildDuration => buildDurations.first;
  Duration get firstRasterDuration => rasterDurations.first;

  Iterable<Duration> get nonZeroBuildDurations =>
      buildDurations.where((duration) => duration > Duration.zero);

  Iterable<Duration> get nonZeroRasterDurations =>
      rasterDurations.where((duration) => duration > Duration.zero);

  static _FramePerformanceSummary fromBindingReport(
    IntegrationTestWidgetsFlutterBinding binding,
    String reportKey,
  ) {
    final Map<String, dynamic>? reportData = binding.reportData;
    expect(reportData, isNotNull,
        reason: 'Performance tracing did not produce any report data.');

    final Object? rawSummary = reportData![reportKey];
    expect(rawSummary, isNotNull,
        reason: 'Performance tracing did not produce a report for $reportKey.');
    expect(rawSummary, isA<Map<dynamic, dynamic>>(),
        reason: 'Performance report for $reportKey was not a map.');

    final Map<String, dynamic> summaryMap =
        Map<String, dynamic>.from(rawSummary as Map<dynamic, dynamic>);

    final List<Duration> buildDurations =
        _durationsFromMicros(summaryMap['frame_build_times']);
    final List<Duration> rasterDurations =
        _durationsFromMicros(summaryMap['frame_rasterizer_times']);

    return _FramePerformanceSummary(
      buildDurations: buildDurations,
      rasterDurations: rasterDurations,
      report: summaryMap,
    );
  }
}

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

List<Duration> _durationsFromMicros(dynamic rawValues) {
  if (rawValues is Iterable) {
    return rawValues
        .map((dynamic value) => Duration(
            microseconds: value is int ? value : (value as num).round()))
        .toList();
  }
  return <Duration>[];
}

Future<vm.VmService> _ensureVmService() async {
  if (_vmService != null) {
    return _vmService!;
  }

  final developer.ServiceProtocolInfo info = await developer.Service.getInfo();
  final Uri? serverUri = info.serverUri;
  if (serverUri == null) {
    throw StateError('Unable to locate VM service URI for memory inspection.');
  }

  final String host =
      serverUri.host.isEmpty ? '127.0.0.1' : serverUri.host;
  final String wsUri =
      'ws://$host:${serverUri.port}${serverUri.path}ws';

  _vmService = await vm_io.vmServiceConnectUri(wsUri);
  return _vmService!;
}

void main() {
  _binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.benchmark;

  setUpAll(() {
    HydratedBloc.storage = _InMemoryHydratedStorage();
  });

  tearDownAll(() {
    debugPrint('PERFORMANCE_METRICS:${jsonEncode(_performanceReport)}');
  });

  testWidgets('startup first frame stays under budget', (tester) async {
    await _binding.watchPerformance(() async {
      await tester.pumpWidget(App());
      await tester.pumpAndSettle();
    }, reportKey: 'startup_timeline');

    final _FramePerformanceSummary startupSummary =
        _FramePerformanceSummary.fromBindingReport(
      _binding,
      'startup_timeline',
    );

    expect(startupSummary.frameCount, greaterThan(0),
        reason: 'Performance tracing did not capture any frames.');

    final double firstFrameBuildMillis =
        _durationToMillis(startupSummary.firstBuildDuration);
    final double firstFrameRasterMillis =
        _durationToMillis(startupSummary.firstRasterDuration);

    const double maxFirstFrameBuildMillis = 180;
    const double maxFirstFrameRasterMillis = 180;

    _recordMetrics('startup', <String, Object?>{
      'first_frame_build_millis': firstFrameBuildMillis,
      'first_frame_raster_millis': firstFrameRasterMillis,
      'frame_count': startupSummary.frameCount,
      'frame_summary': startupSummary.report,
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
    await _binding.watchPerformance(() async {
      await tester.pumpWidget(App());
      await tester.pumpAndSettle();

      final Finder scrollable = find.byType(Scrollable).first;
      await tester.fling(scrollable, const Offset(0, -600), 1000);
      await tester.pumpAndSettle();
      await tester.fling(scrollable, const Offset(0, 600), 1000);
      await tester.pumpAndSettle();
    }, reportKey: 'scroll_timeline');

    final _FramePerformanceSummary scrollSummary =
        _FramePerformanceSummary.fromBindingReport(
      _binding,
      'scroll_timeline',
    );

    final List<Duration> buildDurations =
        scrollSummary.nonZeroBuildDurations.toList();
    final List<Duration> rasterDurations =
        scrollSummary.nonZeroRasterDurations.toList();

    expect(buildDurations, isNotEmpty,
        reason: 'Scroll trace did not include any frame timings.');
    expect(rasterDurations, isNotEmpty,
        reason: 'Scroll trace did not include any raster timings.');

    final averageBuildMillis =
        _averageMillis(buildDurations);
    final averageRasterMillis =
        _averageMillis(rasterDurations);
    final double worstBuildMillis =
        buildDurations.map(_durationToMillis).reduce(math.max);
    final double worstRasterMillis =
        rasterDurations.map(_durationToMillis).reduce(math.max);

    const Duration frameBudget = Duration(milliseconds: 16);
    final int jankyFrameCount = _countOverBudget(
      buildDurations,
      frameBudget,
    );
    final double jankPercentage =
        (jankyFrameCount / buildDurations.length) * 100;

    const double maxAverageBuildMillis = 24;
    const double maxAverageRasterMillis = 28;
    const double maxJankPercentage = 20;

    _recordMetrics('scroll', <String, Object?>{
      'average_build_millis': averageBuildMillis,
      'average_raster_millis': averageRasterMillis,
      'worst_build_millis': worstBuildMillis,
      'worst_raster_millis': worstRasterMillis,
      'janky_frame_percentage': jankPercentage,
      'frame_count': scrollSummary.frameCount,
      'frame_summary': scrollSummary.report,
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

    final vm.VmService vmService = await _ensureVmService();
    final vm.VM vmInstance = await vmService.getVM();

    final Iterable<vm.IsolateRef> isolates =
        vmInstance.isolates ?? const <vm.IsolateRef>[];
    final Map<String, Object?> isolateMetrics = <String, Object?>{};
    int totalHeapUsageBytes = 0;
    int totalExternalUsageBytes = 0;

    for (final vm.IsolateRef isolate in isolates) {
      final String? isolateId = isolate.id;
      if (isolateId == null) {
        continue;
      }
      final vm.MemoryUsage usage =
          await vmService.getMemoryUsage(isolateId);
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
