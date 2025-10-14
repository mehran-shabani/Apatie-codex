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
