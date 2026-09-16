# Store release source

This directory and the Fastlane-compatible metadata directories are the reviewed source for manual publication. Fastlane is not used to publish.

## Positioning and categories

- Audience: backpackers first, with plain wording for independent travelers.
- App Store primary category: Travel.
- App Store secondary category: Utilities.
- Google Play category: Travel & Local.

## Upload-ready assets

- Google Play artwork: `store/assets/google_play/<locale>/`.
- App Store artwork: `store/assets/app_store/<locale>/`.
- `store/creative_copy.json` contains the reviewed localized text used in the artwork.
- `store/assets/source/` contains the background and current Android and iPhone captures used by the generator.

## Regenerating store creatives

The generated screenshots and feature graphics are committed to the repository so publishing remains manual and does not require running the generator. Regenerate them whenever the app UI, campaign copy, background, or mockup treatment changes.

### Prerequisites

Run the generator on macOS from the repository root. It requires:

- ImageMagick 7, exposed as `magick`.
- The macOS font `/System/Library/Fonts/Supplemental/Arial Unicode.ttf`.
- FVM and the repository's configured Dart SDK.

### Source files

Update `store/creative_copy.json` when screenshot or feature-graphic text changes. Update the captures and background under `store/assets/source/` when the app UI or visual treatment changes.

Replace captures in place without cropping away the platform status or navigation areas. Android captures must use Android chrome; iOS captures must use current iPhone chrome, including the Dynamic Island. Keep the numbered filenames and screen order unchanged unless the `_sources` list in `tools/generate_store_creatives.dart` and the `screens` array in `store/creative_copy.json` are updated together.

Edit all four locale entries in `store/creative_copy.json` when copy changes, and increment its `version`. Use `\n` in a feature headline when a deliberate line break is required. Screenshot captions and feature-graphic text come from this manifest; the UI inside each device comes from the source capture itself.

### Generate

Generate every Google Play and App Store asset:

```sh
fvm dart run tools/generate_store_creatives.dart
```

To update only one platform while iterating:

```sh
fvm dart run tools/generate_store_creatives.dart google
fvm dart run tools/generate_store_creatives.dart apple
```

The script adds the Android or iPhone frame, background treatment, localized headline, and shadow, then replaces the generated files under `store/assets/google_play/` and `store/assets/app_store/`.

### Review

The generator stops immediately if required input, localized copy, or an ImageMagick operation fails. A successful run confirms that every requested output was rendered; store-specific copy limits should be checked in App Store Connect and Play Console when uploading.

Before committing, visually inspect the images and feature graphics in every generated locale. Confirm that:

- Text is readable and is not clipped.
- The app UI is current and contains no test or personal data.
- Android assets show Android hardware chrome and Apple assets show the iPhone frame.
- The image order matches `store/creative_copy.json`.
- The generated source inputs and outputs are included in the same commit.

## Privacy declarations

For the currently shipped build that contains Firebase Analytics, correct Google Play’s Data safety form immediately to match that binary’s actual Analytics collection. Do not apply the next-build declaration to the old binary.

For the next Crashlytics-only binary:

- Google Play: declare crash logs/diagnostics, installation identifiers, and required session metadata as collected for app functionality/app stability; not shared by TravelRates; not used for advertising; encrypted in transit. Answer deletion questions according to Google’s Crashlytics disclosure guidance and the app’s no-account design.
- App Store: retain only the non-linked Diagnostics, Usage Data, and Identifiers required by Crashlytics/Firebase Sessions. Tracking is disabled. Do not declare analytics or advertising data.
- Publish the reviewed text from `privacy_policy.md` on the existing privacy-policy URL before release.

## Coordinated rollout

1. Upload the Apple binary and localized metadata/image sets, submit for review, and hold for manual release.
2. Send deliberate fatal and nonfatal test crashes from Android internal testing and TestFlight. Confirm reports arrive and symbols are readable before production rollout.
3. Preview every localized listing and verify that each image matches the current app and locale.
4. Once Apple is ready, manually release Apple and publish both refreshed listings together.
5. If evaluating the impact, record the preceding 28-day baseline for impressions, search terms, product-page conversion, and acquisitions. Compare it with the same measures 7, 14, and 28 days after release.
