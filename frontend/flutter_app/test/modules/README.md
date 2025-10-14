# Module Interaction Test Coverage

This document summarizes the behavioral widget tests that exercise the major user journeys for the Apatie modules. Every scenario runs in both left-to-right (English) and right-to-left (Persian) locales, with reduced-motion preferences applied in the RTL configuration to validate accessibility fallbacks.

## Appointments
- **Flow progression & loading:** `appointments_accessibility_test.dart` validates the stepper progress indicator across all three steps and asserts that motion-aware transitions honor reduced-motion settings.
- **Keyboard focus & announcements:** The test captures accessibility announcements emitted when focus traverses from the search field through list options and action buttons, ensuring FocusTraversalGroup ordering works for keyboard users.
- **Error recovery & summary:** Selecting services, experts, and slots replaces the placeholder error hints ("هنوز انتخاب نشده است") in the summary card, confirming that completion feedback renders without residual error banners.

## Services
- **Floating window accessibility:** `services_accessibility_test.dart` inspects the draggable window animation duration under motion reduction and checks status labels while toggling between expanded and minimized states.
- **Keyboard focus & notifications:** The test verifies focus announcements on compact buttons, the warning banner shown in minimized mode, and the SnackBar that confirms monitoring completion, including dismissal after its timeout.
- **Loading indicators:** Both the primary monitoring card and the floating window progress bars are asserted to expose their expected completion percentages.

## Marketplace
- **Horizontal card interactions:** `marketplace_accessibility_test.dart` covers keyboard focus over action buttons, option selection feedback, and progress indicators that adjust when a new package is highlighted.
- **Dialog accessibility:** Opening the dialog card pattern validates reduced-motion fade timing, focus traversal inside the dialog actions, and the closing announcement when the confirmation action is activated.
- **Localization surface:** Headline expectations ensure each locale renders localized guidance so assistive announcements pair with the correct visible copy.

All tests run via `flutter test test/modules` and can be extended with additional scenarios per module as new behaviors are introduced.
