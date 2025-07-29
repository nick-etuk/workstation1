#!/usr/bin/env bash

function get_step_file {
    local step
    local extension
    local file_path=''

    step=$1
    extension=$2

    for project_path in "${PROJECT_PATHS[@]}"; do
        file_path=$(find "$project_path" -name "$step.$extension" -type f)
        if [ -f "$file_path" ]; then
            echo "$file_path"
            return
        fi
    done
    # if [ ! -z ${CURRENT_PROJECT+empty} ]; then
    #     file_path=$(find "$WS_ROOT_UNIX/$CURRENT_PROJECT/steps" -name "$step.$extension" -type f)
    # fi

    # [ -f "$file_path" ] || file_path=$(find "$WS_ROOT_UNIX" -path '*steps*' -name "$step.$extension" -type f)

    if [ ! -f "$file_path" ]; then
        file_path=$(find "$WS_ROOT_UNIX/core/steps" -name "$step.$extension" -type f)
        [ -f "$file_path" ] || warn "Step file $step.$extension not found"
    fi
    echo "$file_path"
}

function get_step_path {
    local step
    local file_path

    step=$1
    file_path=$(get_step_file "$step" "sh")
    [ -f "$file_path" ] &&  dirname "$file_path"
}

function get_step_config {
    local step
    local file_path

    step=$1
    file_path=$(get_step_file "$step" "json")
    [ -f "$file_path" ] &&  echo "$file_path"
}
