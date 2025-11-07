#!/usr/bin/env bash

run_checks() {
    local checks
    local exit_status
    local empty_string=''

    if [ -z "${INIT_UNIX+empty_string}" ]; then
        script_dir=$(dirname "$(realpath "$0")")
        cd "$script_dir/.." || exit
        . ./init.sh || exit 1
    fi

    checks=("$@")

    for check in ${checks[@]+"${checks[@]}"}; do
        eval "$check" >/dev/null
        exit_status=$?

        if [ "$exit_status" -ne 0 ]; then
            echo "Check failed: $check"
            echo "Result: $exit_status"
            return 1
        fi
        echo "Check passed: $check"
    done

    return 0
}
run_checks "$@"
