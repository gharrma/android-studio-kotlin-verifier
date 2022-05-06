#!/usr/bin/env bash
set -eu

function check_ide {
    [[ $# -eq 3 ]] || { echo "Usage: check_ide platform_version studio_link kotlin_link"; exit 1; }
    OUT="out/$1"
    mkdir -p "$OUT"
    ./run_with_urls.sh "$OUT" "$2" "$3" > "$OUT/log.txt" 2>&1 &
}

echo "Scheduling verifications."

check_ide '212' \
    'https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2021.2.1.15/android-studio-2021.2.1.15-linux.tar.gz' \
    'https://plugins.jetbrains.com/plugin/download?rel=true&updateId=183059'

echo "Waiting for verifications to complete."
wait $(jobs -p)
echo "Verifications finished."

find out -name new-errors.txt | xargs cat
