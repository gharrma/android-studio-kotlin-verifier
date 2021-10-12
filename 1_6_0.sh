#!/usr/bin/env bash
set -eu

mkdir -p out/203-1.6.0-RC
mkdir -p out/211-1.6.0-RC

./run_with_urls.sh out/203-1.6.0-RC \
    'https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2020.3.1.25/android-studio-2020.3.1.25-linux.tar.gz' \
    'https://plugins.jetbrains.com/plugin/download?rel=true&updateId=140918' 2>&1 > out/203-1.6.0-RC/log.txt &

./run_with_urls.sh out/211-1.6.0-RC \
    'https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2021.1.1.13/android-studio-2021.1.1.13-linux.tar.gz' \
    'https://plugins.jetbrains.com/plugin/download?rel=true&updateId=140919' 2>&1 > out/211-1.6.0-RC/log.txt &

wait $(jobs -p)

cat out/{203,211}-1.6.0-RC/new-errors.txt
