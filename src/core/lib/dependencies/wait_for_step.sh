#!/usr/bin/env bash

wait_for_step() {
    local step
    local pause=10
    local step
    local args
    local step_args

    step=$1
    args=( "$@" )
    step_args=("${args[@]:1}")
    debug "=>wait_for_step $step ${step_args[*]+"${step_args[*]}"}"
    for arg in ${step_args[@]+"${step_args[@]}"}; do debug "arg: $arg"; done

    sleep $pause
    if ! assert_step_done "$step" ${step_args[@]+"${step_args[@]}"}; then
        WAITED=$((WAITED+pause))
        if [ "$WAITED" -gt "$TIMEOUT" ]; then
            echo ''
            # echo -e "${YELLOW}$step not started after $TIMEOUT_MINUTES minutes. Please start it manually. ${NC}"
            WAIT_FOR_STEP_STATUS=1
            return 1
        fi 
        echo -n "."
        # wait_for_step "$step" ${args[@]+"${args[@]}"}
        wait_for_step "$step" "${step_args[@]+"${step_args[@]}"}"
    fi
    echo ''
}
