#!/usr/bin/env bash

is_parallel_step() {
    local step
    local config_file
    local is_parallel

    step=$1
    config_file=$(get_step_path "$step")
    [ -f "$config_file" ] || return 1

    is_parallel=$(jq -r '.parallel' "$config_file")
    [ "$is_parallel" = 'true' ] && return 0
    return 1
}
