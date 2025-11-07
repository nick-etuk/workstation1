#!/usr/bin/env bash
# shellcheck disable=SC2034,SC1091

empty_string=''

if [ -z "${INIT_UNIX+empty_string}" ]; then
    script_dir=$(dirname "$(realpath "$0")")
    cd "$script_dir/.." || exit
    . ./init.sh || exit 1
fi

step_script=$1
shift
step_args=("$@")
debug "ws_run_step.sh executing step script: $step_script with args: ${step_args[*]+"${step_args[*]}"}"
source "$step_script" "${step_args[@]}"
exit 0
