# Store release source

This directory and the Fastlane-compatible metadata directories are the reviewed source for manual publication. Fastlane is not used to publish.

## Positioning and categories

- Audience: backpackers first, with plain wording for independent travelers.
- App Store primary category: Travel.
- App Store secondary category: Utilities.
- Google Play category: Travel & Local.

## Upload-ready assets

- Google Play: `assets/store/google_play/<locale>/` contains five 1440×2560 portrait screenshots and one 1024×500 feature graphic.
- App Store: `assets/store/app_store/<locale>/` contains one five-image 1320×2868 iPhone 6.9-inch set.
- `creative_copy.json` is the reviewed localized copy manifest used to generate the artwork.
- `assets/store/source/` contains the supplied beach photograph, its cleaned left-side campaign background, and the current Android/iPhone captures used by the generator. The generator adds the reusable device mockup frame deterministically.

## Regenerating store creatives

The generated screenshots and feature graphics are committed to the repository so publishing remains manual and does not require running the generator. Regenerate them whenever the app UI, campaign copy, background, or mockup treatment changes.

### Prerequisites

Run the generator on macOS from the repository root. It requires:

- ImageMagick 7, exposed as `magick`.
- `jq`.
- The macOS font `/System/Library/Fonts/Supplemental/Arial Unicode.ttf`.
- FVM and the repository's configured Flutter SDK for validation.

Install the command-line dependencies with Homebrew if needed:

```sh
brew install imagemagick jq
```

### Source files

The generator reads these versioned inputs:

```text
store/creative_copy.json
assets/store/source/beach-left-background.png
assets/store/source/android/01-compare.png
assets/store/source/android/02-offline.png
assets/store/source/android/03-search.png
assets/store/source/android/04-calculator.png
assets/store/source/android/05-appearance.png
assets/store/source/ios/01-compare.png
assets/store/source/ios/02-offline.png
assets/store/source/ios/03-search.png
assets/store/source/ios/04-calculator.png
assets/store/source/ios/05-appearance.png
```

Replace captures in place without cropping away the platform status or navigation areas. Android captures must use Android chrome; iOS captures must use current iPhone chrome, including the Dynamic Island. Keep the numbered filenames and screen order unchanged unless the `sources` array in `tools/generate_store_creatives.sh` and the `screens` array in `store/creative_copy.json` are updated together.

Edit all four locale entries in `store/creative_copy.json` when copy changes, and increment its `version`. Use `\n` in a feature headline when a deliberate line break is required. Screenshot captions and feature-graphic text come from this manifest; the UI inside each device comes from the source capture itself.

### Generate

Generate every Google Play and App Store asset:

```sh
tools/generate_store_creatives.sh
```

To update only one platform while iterating:

```sh
tools/generate_store_creatives.sh google
tools/generate_store_creatives.sh apple
```

The script adds the Android or iPhone frame, background treatment, localized headline, and shadow, then replaces the generated files under:

```text
assets/store/google_play/<locale>/
assets/store/app_store/<locale>/
```

Google output contains five 1440×2560 screenshots plus a 1024×500 feature graphic per locale. Apple output contains five 1320×2868 screenshots per locale.

### Validate and review

Run both checks after generation:

```sh
fvm dart run tools/validate_store_metadata.dart
fvm flutter test test/store_metadata_test.dart
```

The validator checks localization completeness, store limits, UTF-8 keyword byte limits, required English terms, banned stale claims, copy-manifest shape, and final image dimensions.

Before committing, visually inspect all five images and the feature graphic in every generated locale. Confirm that:

- Text is readable and is not clipped.
- The app UI is current and contains no test or personal data.
- Android assets show Android hardware chrome and Apple assets show the iPhone frame.
- The image order matches `store/creative_copy.json`.
- The generated source inputs and outputs are included in the same commit.

After creating Android and iOS release builds, run `tools/verify_release_privacy.sh`. It fails if Analytics, an advertising framework, or Android’s Advertising ID permission is present, and it confirms that Android mapping data and the Apple dSYM exist.

## Privacy declarations

For the currently shipped build that contains Firebase Analytics, correct Google Play’s Data safety form immediately to match that binary’s actual Analytics collection. Do not apply the next-build declaration to the old binary.

For the next Crashlytics-only binary:

- Google Play: declare crash logs/diagnostics, installation identifiers, and required session metadata as collected for app functionality/app stability; not shared by TravelRates; not used for advertising; encrypted in transit. Answer deletion questions according to Google’s Crashlytics disclosure guidance and the app’s no-account design.
- App Store: retain only the non-linked Diagnostics, Usage Data, and Identifiers required by Crashlytics/Firebase Sessions. Tracking is disabled. Do not declare analytics or advertising data.
- Publish the reviewed text from `privacy_policy.md` on the existing privacy-policy URL before release.

## Coordinated rollout

1. Upload the Apple binary and all four localized metadata/image sets, submit for review, and hold for manual release.
2. Send deliberate fatal and nonfatal test crashes from Android internal testing and TestFlight. Confirm reports arrive and symbols are readable before production rollout.
3. Preview every localized listing and verify that each image matches the current app and locale.
4. Once Apple is ready, manually release Apple and publish both refreshed listings together.
5. Record the preceding 28-day baseline for impressions, search terms, product-page conversion, and acquisitions. Record the same measures 7, 14, and 28 days after release and evaluate the refresh as one package.

Use `rollout_metrics.csv` for the baseline and follow-up snapshots.
