# Design system golden tests

This directory hosts the visual regression suite that protects the Apatie design system. It relies on Flutter golden tests to render widgets and compare them against the PNG baselines stored under [`test/design_system/goldens/`](goldens/).

## Prerequisites

Before running the suite you need:

- Flutter `stable` channel (3.x or newer) available on your `PATH`.
- All Flutter dependencies installed via `flutter pub get` from the `frontend/flutter_app` directory.
- A workstation capable of rendering Skia images. Golden tests must be executed on macOS, Linux, or Windows—headless Linux builds work in CI.
- [`flutter_test`](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html) and the [`golden_toolkit`](https://pub.dev/packages/golden_toolkit) packages pulled in through `pubspec.yaml`.

Ensure no assets referenced by the widgets are missing. A failing test that logs `Unable to load asset` indicates an asset path mismatch or an unregistered file in `pubspec.yaml`.

## Running the tests

From the repository root run:

```bash
cd frontend/flutter_app
flutter test
```

The command executes the entire Flutter test suite, including the design system goldens. CI runs the same command in [`.github/workflows/frontend.yml`](../../.github/workflows/frontend.yml), so the suite must stay green to merge.

## Updating golden baselines

Whenever you intentionally change the design system visuals, refresh the snapshots:

```bash
cd frontend/flutter_app
flutter test --update-goldens
```

The command regenerates the PNGs under [`test/design_system/goldens/`](goldens/). Review every new or modified image to confirm the visual changes are expected. We recommend using an image diff tool locally or inspecting the generated files in your IDE.

### Handling visual diffs

If CI reports a golden mismatch:

1. Pull the failing branch locally and reproduce the failure with `flutter test`.
2. If the difference is expected, regenerate the baselines with `flutter test --update-goldens`, review the images, and commit the updated PNGs.
3. If the difference is unexpected, debug the widgets first—do **not** update the baselines until the bug is fixed.

Make sure the regenerated goldens are committed alongside the code changes. CI will surface missing files or assets as test failures.

## Asset hygiene

Golden tests require a deterministic asset bundle. Keep the following checklist in mind:

- Register new image or font assets in `pubspec.yaml`.
- Prefer deterministic data (for example, hard-coded timestamps) to avoid flaky renders.
- Run `flutter clean` if goldens pick up stale artifacts, then re-run `flutter pub get` and the tests.

## Additional tooling

A helper script at [`frontend/update_pattern_goldens.sh`](../update_pattern_goldens.sh) demonstrates how to batch-update pattern goldens. Follow the same review process—inspect the generated images before committing.

For broader contributor guidance, see the [root README golden testing section](../../README.md#design-system-golden-tests).
