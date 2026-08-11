#!/usr/bin/bash

docker compose --env-file docker_env run --rm --name erasers_kachaka erasers_kachaka bash -ic "ros2 launch erasers_kachaka_bringup bringup.launch.py"
