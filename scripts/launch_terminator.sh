#!/usr/bin/bash

docker stop kachaka_terminator
docker compose --env-file ./docker_env run -d --name kachaka_terminator --rm erasers_kachaka bash -ic "terminator"
