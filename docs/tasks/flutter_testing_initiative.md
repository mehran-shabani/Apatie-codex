# Flutter Testing & Performance Initiative Tasks

This initiative delivers the four-step testing and monitoring plan requested for the Flutter design system. The tasks below are ordered for sequential execution and include owners, prerequisites, deliverables, and acceptance criteria.

## Task 1 — Add Visual & Performance Testing Dependencies
- **Owner:** Frontend tooling engineer
- **Prerequisites:** Familiarity with the existing Flutter project setup and dependency management.
- **Description:**
  - Update `frontend/flutter_app/pubspec.yaml` by adding the `golden_toolkit`, `integration_test`, and any supporting packages required for golden tests (e.g., font assets).
  - Run `flutter pub get` to lock dependencies and update `pubspec.lock` if present.
  - Smoke-check the new dependency graph with `flutter test` to ensure existing tests keep passing.
- **Deliverables:**
  - Updated dependency definitions committed to source control.
  - Verified lockfile and `flutter test` output attached to the change.
- **Acceptance Criteria:**
  - `pubspec.yaml` contains the new test dependencies without version conflicts.
  - `flutter test` completes successfully in CI and locally.

## Task 2 — Record Golden Tests for Components & Patterns
- **Owner:** Flutter UI engineer
- **Prerequisites:** Completion of Task 1 and availability of golden testing dependencies.
- **Description:**
  - Create `test/design_system/` scaffolding with a shared golden configuration helper.
  - Author golden tests for each core component (buttons, inputs, cards, labels, notifications, navigation, lists, option rows, dialogs, loaders) covering normal, hover, compact, disabled, success, warning, error, and loading states.
  - Capture golden scenarios for the four primary UI patterns (full-screen flow, floating window, dialog card, horizontal card rail) in separate test files.
  - Document update instructions for regenerating golden baselines (`flutter test --update-goldens`).
- **Deliverables:**
  - New golden test files and configuration under `test/design_system/`.
  - README or inline documentation explaining how to update goldens.
  - Fresh baseline images committed after running `--update-goldens`.
- **Acceptance Criteria:**
  - All golden tests pass locally and in CI without missing assets.
  - Each component and pattern state enumerated in the planning document appears in at least one golden screenshot.

## Task 3 — Expand Behavioral Module Tests
- **Owner:** Flutter QA engineer
- **Prerequisites:** Completion of Task 1 to ensure dependencies are in place.
- **Description:**
  - Add widget tests under `test/modules/` that simulate keyboard focus changes, announcement flows, error handling, and loading progressions for each major module (Appointments, Services, Marketplace).
  - Validate interactions in both LTR and RTL contexts, including reduced-motion settings.
  - Use test bindings to assert SnackBars, notifications, error banners, and loading indicators appear/disappear as expected.
- **Deliverables:**
  - New behavioral test files with comprehensive coverage of focus, notifications, errors, and loading flows.
  - Test documentation describing scenarios and coverage per module.
- **Acceptance Criteria:**
  - `flutter test test/modules` passes locally and in CI.
  - Focus traversal, accessibility feedback, and loading states are asserted in the new tests for every module.

## Task 4 — Measure Performance & Wire to CI
- **Owner:** Frontend performance engineer / DevOps
- **Prerequisites:** Completion of Task 1 for dependency readiness; coordination with DevOps for CI changes.
- **Description:**
  - Implement integration tests under `integration_test/performance/` that gather first-frame, scroll smoothness, and memory metrics using `IntegrationTestWidgetsFlutterBinding`.
  - Report metrics through `binding.reportData` and enforce thresholds with expectations.
  - Create a script (e.g., `scripts/parse_performance_metrics.py`) that converts JSON output into CI-friendly logs or artifacts.
  - Update the `frontend` CI workflow to run the performance suite and publish the metrics artifact.
  - Document the process for updating thresholds and interpreting failures.
- **Deliverables:**
  - Performance integration tests, parsing script, and updated CI workflow file.
  - Documentation outlining how metrics feed into release quality gates.
- **Acceptance Criteria:**
  - CI runs performance tests after unit/widget suites and uploads metrics artifacts.
  - Tests fail when metrics exceed thresholds, providing actionable log output.
  - Documentation is available for adjusting thresholds and consuming reports.
