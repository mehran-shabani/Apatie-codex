# apatie

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Design system golden tests

The visual regression suite that protects the Apatie design system lives under [`test/design_system/`](test/design_system/).

- Follow the [golden testing README](test/design_system/README.md) for prerequisites, local commands, and troubleshooting.
- Run `flutter test` before submitting a change—the command exercises golden tests locally and matches what runs in CI.
- When making intentional visual adjustments, regenerate baselines with `flutter test --update-goldens`, review the PNGs created under [`test/design_system/goldens/`](test/design_system/goldens/), and commit them with the code change.

## Performance integration tests

The performance suite under [`integration_test/performance/`](integration_test/performance/) measures start-up latency, scroll smoothness,
and memory consumption. The scenarios mirror our release quality gates and emit metrics through
`IntegrationTestWidgetsFlutterBinding.reportData` so CI can surface trends.

- **Run the suite locally** with `flutter test integration_test/performance`. The command enforces the same thresholds that run in CI.
- **Inspect metrics** by parsing the JSON log captured with `--machine` via `python scripts/parse_performance_metrics.py --input <log-file>`.
  Add `--markdown-output` or `--json-output` flags to generate artifacts for sharing.
- **Adjust thresholds** inside [`performance_metrics_test.dart`](integration_test/performance/performance_metrics_test.dart) when intentional
  regressions are justified. Update the surrounding documentation in the test to explain the new baseline and include rationale in your PR.
- **Investigate failures** by reviewing the rendered Markdown summary attached to CI (GitHub Step Summary) and the
  `frontend-performance-metrics` artifact, which contains the raw machine-readable metrics.
- After changing thresholds, validate locally and re-run CI to confirm the new limits capture the intended performance envelope.
