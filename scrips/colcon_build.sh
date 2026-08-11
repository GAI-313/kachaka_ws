#!/usr/bin/bash

docker compose --env-file ./docker_env run --rm erasers_kachaka bash -ic \
    "colcon build --symlink-install --packages-up-to erasers_kachaka_bringup --merge-install --cmake-clean-cache --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Release"
