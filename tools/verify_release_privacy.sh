#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
android_apk="${1:-$repo_root/build/app/outputs/flutter-apk/app-release.apk}"
ios_app="${2:-$repo_root/build/ios/iphoneos/Runner.app}"
android_sdk="${ANDROID_HOME:-/Users/ddikman/Library/Android/sdk}"
apkanalyzer="$android_sdk/cmdline-tools/latest/bin/apkanalyzer"

fail() {
  echo "Release privacy verification failed: $1" >&2
  exit 1
}

[[ -f "$android_apk" ]] || fail "missing Android release APK at $android_apk"
[[ -d "$ios_app" ]] || fail "missing iOS release app at $ios_app"
[[ -x "$apkanalyzer" ]] || fail "apkanalyzer is unavailable at $apkanalyzer"

if rg -n -i 'firebase_analytics|FirebaseAnalytics' \
  "$repo_root/pubspec.yaml" "$repo_root/ios/Podfile.lock" >/dev/null; then
  fail "Analytics remains in a dependency manifest"
fi

permissions="$($apkanalyzer manifest permissions "$android_apk" 2>/dev/null)"
if grep -Fq 'com.google.android.gms.permission.AD_ID' <<<"$permissions"; then
  fail "Android release requests Advertising ID permission"
fi

if unzip -l "$android_apk" | rg -i \
  'firebase[_\.-]analytics|GoogleAppMeasurement|play-services-ads' >/dev/null; then
  fail "Android release contains an Analytics or advertising SDK"
fi

if find "$ios_app/Frameworks" -maxdepth 1 -type d | rg -i \
  'FirebaseAnalytics|GoogleAppMeasurement|GoogleAdsOnDeviceConversion' >/dev/null; then
  fail "iOS release contains an Analytics or advertising framework"
fi

[[ -f "$repo_root/build/app/outputs/mapping/release/mapping.txt" ]] || \
  fail "Android release mapping file is missing"
[[ -d "$repo_root/build/ios/Release-iphoneos/Runner.app.dSYM" ]] || \
  fail "iOS release dSYM is missing"

echo "Release artifacts contain Crashlytics without Analytics or Advertising ID permission."
