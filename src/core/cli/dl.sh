#!/usr/bin/env bash
# shellcheck disable=SC1091

. "$WS_ROOT_UNIX/core/init.sh"

run_step start_docker
FORCE=1 run_step docker_login
