#!/usr/bin/env bash
# shellcheck disable=SC1091

script=$(find "$WS_ROOT_UNIX" -name 'init.sh' -not -path '.venv/*')
. "$script"

run_step start_docker
FORCE=1 run_step docker_login
