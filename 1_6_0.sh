#!/usr/bin/env bash
set -eu

mkdir -p out/203-1.6.0-RC2
mkdir -p out/211-1.6.0-RC2
mkdir -p out/212-1.6.0-RC2

./run_with_urls.sh out/203-1.6.0-RC2 \
    'https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2020.3.1.25/android-studio-2020.3.1.25-linux.tar.gz' \
    'https://plugins.jetbrains.com/plugin/download?rel=true&updateId=144126' 2>&1 > out/203-1.6.0-RC2/log.txt &

./run_with_urls.sh out/211-1.6.0-RC2 \
    'https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2021.1.1.16/android-studio-2021.1.1.16-linux.tar.gz' \
    'https://plugins.jetbrains.com/plugin/download?rel=true&updateId=144127' 2>&1 > out/211-1.6.0-RC2/log.txt &

./run_with_urls.sh out/212-1.6.0-RC2 \
    'https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2021.2.1.4/android-studio-2021.2.1.4-linux.tar.gz' \
    'https://plugins.jetbrains.com/plugin/download?rel=true&updateId=144128' 2>&1 > out/212-1.6.0-RC2/log.txt &

wait $(jobs -p)

cat out/{203,211,212}-1.6.0-RC2/new-errors.txt
