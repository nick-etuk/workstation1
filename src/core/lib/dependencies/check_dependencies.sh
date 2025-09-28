#!/usr/bin/env bash

check_dependencies() {
    local step
    local config_file
    local exit_status
    # local args
    local dependencies

    step=$1
    shift
    # args=( "$@" )
    
    config_file=$(get_step_path "$step")

    [ -f "$config_file" ] || return

    dependencies=$(jq -r '.dependencies' "$config_file")
    [ "$dependencies" = "null" ] && return

    dependencies=$(echo "$dependencies" | jq -r '. | .[]')

    # for dependency in "${dependencies[@]}"; do
    for dependency in $dependencies; do
        done_len="${#DONE_DEPENDENCIES[@]}"

        # Move on if dependency is in the list of done dependencies 
        if [ "$done_len" -gt 0 ] && [[ " ${DONE_DEPENDENCIES[*]} " =~ [[:space:]]${dependency}[[:space:]] ]]; then
            # debug "dependency check $dependency already done"
            continue
        fi

        # if [ "$arg_len" -eq 0 ]; then
        #     assert_step_done "$dependency"
        # else
        #     if [ "$dependency" = build_backend ]; then
        #         debug "arg_len:$arg_len"
        #         debug "args"
        #         for arg in "${args[@]}"; do
        #             debug "arg: [$arg]"
        #         done
        #         assert_step_done "$dependency" images ${args[1]}
        #     else
        #         assert_step_done "$dependency" ${args[*]}
        #     fi
        # fi
        # if [ "$dependency" = build_backend ]; then
        #     # debug "arg_len:$arg_len"
        #     # for arg in ${args[@]+"${args[@]}"}; do debug "arg: [$arg]"; done
        #     assert_step_done "$dependency" images "${args[0]}"
        # else
        #     assert_step_done "$dependency" ${args[@]+"${args[@]}"}
        # fi
        # dependency_args=("${args[@]:1}")
        # for arg in ${dependency_args[@]+"${dependency_args[@]}"}; do debug "dep arg: $arg"; done
        
        # assert_step_done "$dependency" ${dependency_args[@]+"${dependency_args[@]}"}
        assert_step_done "$dependency" "$@"

        exit_status=$?
        if [ "$exit_status" -eq 0 ] ; then
            DONE_DEPENDENCIES+=("$dependency")
            continue
        fi

        if is_parallel_step "$dependency"; then
            # wait_for_parallel_step "$dependency" ${args[@]+"${args[@]}"}
            # wait_for_parallel_step "$dependency" ${dependency_args[@]+"${dependency_args[@]}"}
            wait_for_parallel_step "$dependency" "$@"
            exit_status=$WAIT_FOR_STEP_STATUS

            if [ "$exit_status" -eq 0 ] ; then
                DONE_DEPENDENCIES+=("$dependency")
                continue
            fi
        fi

        warn "$step not attempted because $dependency is not done"
        return 1
    done
}
