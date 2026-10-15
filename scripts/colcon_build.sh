#!/usr/bin/env bash

set -e

SERVICE="${1}"

if [ -z "${SERVICE}" ]; then
    echo "Select platform (desktop, headless)"
    exit 1
fi

shift

docker compose --env-file ./docker_env run --rm "${SERVICE}" bash -ic \
    "colcon build --symlink-install --packages-up-to erasers_kachaka_bringup --merge-install --cmake-clean-cache --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Release $*"

