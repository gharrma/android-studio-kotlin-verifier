#!/usr/bin/env bash
set -eu

[[ $# -eq 3 ]] || { echo "Usage: $0 out-dir link-to-studio-linux link-to-kotlin-plugin"; exit 1; }

OUT="$1"
STUDIO_LINK="$2"
KOTLIN_LINK="$3"

STUDIO_TAR="$OUT/android-studio.tar.gz"
KOTLIN_ZIP="$OUT/kotlin-plugin.zip"

STUDIO="$OUT/android-studio"
KOTLIN="$OUT/Kotlin"

mkdir -p "$OUT"

echo "Downloading files (if needed) into $OUT"
[[ -f "$STUDIO_TAR" ]] || curl --location "$STUDIO_LINK" -o "$STUDIO_TAR"
[[ -f "$KOTLIN_ZIP" ]] || curl --location "$KOTLIN_LINK" -o "$KOTLIN_ZIP"

echo "Extracting files (if needed) into $OUT"
[[ -d "$STUDIO" ]] || tar -C "$OUT" -xf "$STUDIO_TAR"
[[ -d "$KOTLIN" ]] || unzip -d "$OUT" "$KOTLIN_ZIP"

[[ -d "$STUDIO" ]] || { echo "Expected to find $STUDIO after extracting"; exit 1; }
[[ -d "$KOTLIN" ]] || { echo "Expected to find $KOTLIN after extracting"; exit 1; }

./gradlew run --args="'$STUDIO' '$KOTLIN' '$OUT'"
