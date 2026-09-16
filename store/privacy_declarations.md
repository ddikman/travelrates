# Store privacy declarations

The currently published Google Play binary still contains Analytics and must be declared according to that shipped binary until it is replaced. Google’s form must always describe the binary users can actually download.

## Immediate Google Play correction for the shipped Analytics build

Until the new binary is published, replace the current “no data collected” answer with a conservative declaration covering the data that the shipped implementation sends through Firebase Analytics:

- App activity: app interactions and other actions, including app open, currency selection/removal/reordering, review-prompt response, and conversion events.
- Financial info: other financial information, because the shipped conversion event includes the entered amount and currency code.
- Approximate location and device or other identifiers collected automatically by the Analytics SDK where available.
- App/device metadata associated with Analytics events.

Mark these items as collected, not shared by TravelRates with third parties, required because that binary has no opt-out, encrypted in transit, and used for Analytics. Do not select advertising purposes unless the Firebase/Google Analytics project is in fact linked to an advertising product or used for advertising audiences. Confirm the final choices against the exact questionnaire currently shown in Play Console.

The remaining sections describe the new Crashlytics-only binary introduced by this change.

## Google Play Data safety

Declare the following as collected for **App functionality / Analytics: app stability only**:

- Crash logs and diagnostics.
- Device or other identifiers (the Crashlytics installation identifier).
- Required Firebase Sessions metadata associated with a crash-reporting session.

For each item:

- Collected: Yes.
- Shared: No.
- Processed ephemerally: No.
- Required or optional: Required for production crash reporting.
- Advertising or marketing: No.
- Fraud prevention, security, or compliance: No.
- Encrypted in transit: Yes.
- Users can request deletion: link to the published privacy-policy contact route; Crashlytics reports and associated identifiers expire after 90 days.

Do not declare usage analytics, advertising data, user IDs, account data, financial information, entered amounts, selected currencies, contacts, location, browsing history, or search history for the new binary.

## App Store privacy

Tracking: **No**.

Data not linked to the user and collected for **App Functionality**:

- Diagnostics: Crash Data and Performance Data required by Crashlytics.
- Identifiers: Device ID (the installation identifier required by Crashlytics/Firebase Installations).
- Usage Data: Other Usage Data limited to Firebase Sessions metadata attached to crash-reporting sessions.

Do not select third-party advertising, developer advertising or marketing, analytics, product personalization, or cross-app tracking purposes. Do not declare account information, purchases, financial information, entered amounts, or selected currencies.

## Release check

Before submission, compare these selections with the Firebase SDK disclosures generated for the exact release dependency versions in `pubspec.lock` and `ios/Podfile.lock`. Store questionnaires and SDK behavior can change, so the store owner must confirm the console wording at submission time.
