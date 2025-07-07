#!/usr/bin/env bash

run_activity() {
    local activity_id
    local activity_args
    local steps
    local raw_steps
    
    if [ -z ${1+empty_string} ];then
        error "No menu id provided"
    fi

    activity_id=$1
    # args=("$@")
    # activity_args=("${args[@]:1}")
    shift
    activity_args=("$@")
    debug "Running activity $activity_id ${activity_args[*]+"${activity_args[*]}"}"

    get_menu_file "$activity_id"
    [ ! -f "$MENU_FILE" ] && error "Menu file not found: $MENU_FILE"

    raw_steps=$(jq '.steps' "$MENU_FILE")
    if [ "$raw_steps" = "null" ]; then
        warn "No steps found in $MENU_FILE"
        return
    fi
    steps=$(replace "$raw_steps" ' ' '~')
    steps=$(replace "$steps" '~~' ' ') #todo: do this better

    steps=$(echo "$steps" | jq -r '.| .[]')

    # steps=$(replace "$steps" ' ' '~')
    # for step in $steps; do
    #     if [[ ! $stage == *~* ]]; then
    #         debug "stage: $stage"
    #         run_stage "$stage"
    #         continue
    #     fi
    #     stage_name="${stage%~*}"
    #     stage_args="${stage#*~}"
    #     debug "stage: $stage_name args: $stage_args"
    #     run_stage "$stage_name" "$stage_args"
    # done

    # for step in $steps; do
    [ "$SHELL_NAME" = 'zsh' ] && error "Zsh is not supported for this function. Please use Bash."
    for step in $steps; do
        # step_args=()
        # for step_arg in $step; do step_args+=("$step_arg"); done
        IFS='~' read -ra split_string <<< "$step"

        run_step "${split_string[@]}" "${activity_args[@]+"${activity_args[@]}"}"
    done
}