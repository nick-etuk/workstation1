#!/usr/bin/env bash
# shellcheck disable=SC1091

if [ -z "${INIT_UNIX+set}" ]; then
    script_dir=$(dirname "$(realpath "$0")")
    cd "$script_dir/.." || exit
    . ./init.sh || exit 1
fi

simple_run_step "$@"
exit 0
