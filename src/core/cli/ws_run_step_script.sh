#!/usr/bin/env bash
# shellcheck disable=SC1091

# Run init, get context, then run step script.
if [ -z "${INIT_UNIX+set}" ]; then
    script_dir=$(dirname "$(realpath "$0")")
    cd "$script_dir/.." || exit
    . ./init.sh || exit 1
fi

step_script=$1
shift
step_args=("$@")

source "$step_script" "${step_args[*]+"${step_args[*]}"}"
