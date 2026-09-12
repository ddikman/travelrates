#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
manifest="$repo_root/store/creative_copy.json"
background="$repo_root/assets/store/source/beach-left-background.png"
font="/System/Library/Fonts/Supplemental/Arial Unicode.ttf"
temp_dir="$(mktemp -d)"
trap 'rm -rf "$temp_dir"' EXIT

google_locales=(en-US sv-SE ja-JP fr-FR)
apple_locales=(en-US sv-SE ja-JP fr-FR)
sources=(01-compare 02-offline 03-search 04-calculator 05-appearance)
scope="${1:-all}"

if [[ "$scope" != "all" && "$scope" != "google" && "$scope" != "apple" ]]; then
  echo "Usage: $0 [all|google|apple]" >&2
  exit 2
fi

make_text() {
  local text="$1"
  local width="$2"
  local height="$3"
  local point_size="$4"
  local output="$5"
  magick -background none -fill white -font "$font" -pointsize "$point_size" \
    -gravity center -interline-spacing 8 -size "${width}x${height}" \
    "caption:$text" "$output"
}

make_device_mockup() {
  local platform="$1"
  local source="$2"
  local maximum_width="$3"
  local maximum_height="$4"
  local output="$5"
  local content="$temp_dir/mockup-content-${platform}.png"
  local mask="$temp_dir/mockup-mask-${platform}.png"

  magick "$source" -resize "${maximum_width}x${maximum_height}" +repage "$content"

  local content_width content_height radius bezel frame_width frame_height
  local side_gutter canvas_width shell_x
  content_width="$(magick identify -format '%w' "$content")"
  content_height="$(magick identify -format '%h' "$content")"
  if [[ "$platform" == "ios" ]]; then
    radius=$((content_width * 8 / 100))
    bezel=$((content_width * 2 / 100))
    side_gutter=$((content_width * 2 / 100))
  else
    radius=$((content_width * 6 / 100))
    bezel=$((content_width * 3 / 100))
    side_gutter=0
  fi
  frame_width=$((content_width + bezel * 2))
  frame_height=$((content_height + bezel * 2))
  canvas_width=$((frame_width + side_gutter * 2))
  shell_x=$side_gutter

  magick -size "${content_width}x${content_height}" xc:none \
    -fill white -stroke none \
    -draw "roundrectangle 0,0,$((content_width - 1)),$((content_height - 1)),$radius,$radius" \
    "$mask"
  magick "$content" "$mask" -alpha off -compose CopyOpacity -composite "$content"

  if [[ "$platform" == "ios" ]]; then
    local action_y volume_up_y volume_down_y power_y
    action_y=$((frame_height * 16 / 100))
    volume_up_y=$((frame_height * 22 / 100))
    volume_down_y=$((frame_height * 29 / 100))
    power_y=$((frame_height * 23 / 100))

    magick -size "${canvas_width}x${frame_height}" xc:none \
      -fill '#858F96' -stroke '#D9DEE1' -strokewidth 2 \
      -draw "roundrectangle 1,$action_y,$((side_gutter + 5)),$((action_y + frame_height * 3 / 100)),5,5" \
      -draw "roundrectangle 1,$volume_up_y,$((side_gutter + 5)),$((volume_up_y + frame_height * 6 / 100)),5,5" \
      -draw "roundrectangle 1,$volume_down_y,$((side_gutter + 5)),$((volume_down_y + frame_height * 6 / 100)),5,5" \
      -draw "roundrectangle $((canvas_width - side_gutter - 6)),$power_y,$((canvas_width - 2)),$((power_y + frame_height * 9 / 100)),5,5" \
      -fill '#080B0E' -stroke '#D5DADD' -strokewidth 7 \
      -draw "roundrectangle $((shell_x + 4)),4,$((shell_x + frame_width - 5)),$((frame_height - 5)),$((radius + bezel)),$((radius + bezel))" \
      -fill none -stroke '#667078' -strokewidth 3 \
      -draw "roundrectangle $((shell_x + bezel - 2)),$((bezel - 2)),$((shell_x + frame_width - bezel + 1)),$((frame_height - bezel + 1)),$((radius + 2)),$((radius + 2))" \
      "$content" -gravity northwest -geometry "+$((shell_x + bezel))+$bezel" -composite \
      "$output"
  else
    magick -size "${frame_width}x${frame_height}" xc:none \
      -fill '#11171D' -stroke '#C4CCD2' -strokewidth 4 \
      -draw "roundrectangle 2,2,$((frame_width - 3)),$((frame_height - 3)),$((radius + bezel)),$((radius + bezel))" \
      -fill none -stroke '#49545D' -strokewidth 3 \
      -draw "roundrectangle $((bezel - 2)),$((bezel - 2)),$((frame_width - bezel + 1)),$((frame_height - bezel + 1)),$((radius + 2)),$((radius + 2))" \
      "$content" -gravity northwest -geometry "+$bezel+$bezel" -composite \
      "$output"
  fi

  if [[ "$platform" == "android" ]]; then
    local camera_x camera_y camera_radius
    camera_x=$((frame_width / 2))
    camera_y=$((bezel + content_width * 2 / 100))
    camera_radius=$((content_width * 7 / 1000))
    magick "$output" -fill '#090D10' -stroke '#66727B' -strokewidth 2 \
      -draw "circle $camera_x,$camera_y $((camera_x + camera_radius)),$camera_y" \
      "$output"
  fi
}

make_store_screenshot() {
  local platform="$1"
  local locale="$2"
  local index="$3"
  local width="$4"
  local height="$5"
  local source="$repo_root/assets/store/source/$platform/${sources[$((index - 1))]}.png"
  local output_dir="$repo_root/assets/store/google_play/$locale"
  if [[ "$platform" == "ios" ]]; then
    output_dir="$repo_root/assets/store/app_store/$locale"
  fi
  local output="$output_dir/$index.png"
  local caption
  caption="$(jq -r ".locales[\"$locale\"].screenshots[$((index - 1))]" "$manifest")"

  mkdir -p "$output_dir"
  local top_height=$((height * 17 / 100))
  local screen_width=$((width * 68 / 100))
  local screen_height=$((height * 75 / 100))
  local screen_y=$((height * 22 / 100))
  local headline="$temp_dir/headline-${platform}-${locale}-${index}.png"
  local screen="$temp_dir/screen-${platform}-${locale}-${index}.png"

  make_text "$caption" $((width * 88 / 100)) "$top_height" $((width * 54 / 1000)) "$headline"
  make_device_mockup "$platform" "$source" "$screen_width" "$screen_height" "$screen"

  local mockup_width mockup_x
  mockup_width="$(magick identify -format '%w' "$screen")"
  mockup_x=$(((width - mockup_width) / 2))

  magick "$background" -resize "${width}x${height}^" -gravity center \
    -extent "${width}x${height}" -fill '#062F3D92' -colorize 38 \
    "$headline" -gravity north -geometry +0+$((height * 3 / 100)) -composite \
    \( "$screen" -background '#00151FAA' -shadow 72x26+0+30 \) \
    -gravity northwest -geometry "+$mockup_x+$screen_y" -composite \
    "$screen" -gravity northwest -geometry "+$mockup_x+$screen_y" -composite \
    -strip "$output"
}

make_feature_graphic() {
  local locale="$1"
  local output_dir="$repo_root/assets/store/google_play/$locale"
  local headline tagline
  headline="$(jq -r ".locales[\"$locale\"].featureHeadline" "$manifest")"
  tagline="$(jq -r ".locales[\"$locale\"].featureTagline" "$manifest")"
  mkdir -p "$output_dir"
  make_text "$headline" 900 220 48 "$temp_dir/feature-headline-$locale.png"
  make_text "$tagline" 900 80 27 "$temp_dir/feature-tagline-$locale.png"
  magick "$background" -resize '1024x500^' -gravity center -extent 1024x500 \
    -fill '#062F3DA0' -colorize 44 \
    "$temp_dir/feature-headline-$locale.png" -gravity north -geometry +0+55 -composite \
    "$temp_dir/feature-tagline-$locale.png" -gravity south -geometry +0+55 -composite \
    -strip "$output_dir/featureGraphic.png"
}

if [[ "$scope" == "all" || "$scope" == "google" ]]; then
  for locale in "${google_locales[@]}"; do
    for index in 1 2 3 4 5; do
      make_store_screenshot android "$locale" "$index" 1440 2560
    done
    make_feature_graphic "$locale"
  done
fi

if [[ "$scope" == "all" || "$scope" == "apple" ]]; then
  for locale in "${apple_locales[@]}"; do
    for index in 1 2 3 4 5; do
      make_store_screenshot ios "$locale" "$index" 1320 2868
    done
  done
fi

echo "Generated localized store creatives under assets/store."
