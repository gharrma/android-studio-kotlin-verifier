#!/usr/bin/env bash
set -eu

./run_with_urls.sh out/202-1.5.30-RC \
    'https://redirector.gvt1.com/edgedl/android/studio/ide-zips/4.2.2.0/android-studio-ide-202.7486908-linux.tar.gz' \
    'https://plugins.jetbrains.com/plugin/download?rel=true&updateId=131851' &

./run_with_urls.sh out/203-1.5.30-RC \
    'https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2020.3.1.22/android-studio-2020.3.1.22-linux.tar.gz' \
    'https://plugins.jetbrains.com/plugin/download?rel=true&updateId=131852' &

./run_with_urls.sh out/211-1.5.30-RC \
    'https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2021.1.1.7/android-studio-2021.1.1.7-linux.tar.gz' \
    'https://plugins.jetbrains.com/plugin/download?rel=true&updateId=131853' &

wait $(jobs -p)
