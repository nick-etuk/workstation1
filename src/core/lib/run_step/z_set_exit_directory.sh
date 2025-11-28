#!/usr/bin/env bash

set_exit_directory() {
    # Get the current activity
    # and switch to the directory of the activity
    # If no activity is set, get the first activity

    libraries=(
        logging
        config_dynamic 
        get_activity_file
        get_current_project 
        get_current_activity
        config_base # import this last
    )

    script=$(find "$WS_ROOT_UNIX" -name "init.sh" -type f -not -path '.venv_ws1/*')
    WS_ROOT_SCRIPT=$(dirname "$script")
    for lib in "${libraries[@]}"; do
        script=$(find "$WS_ROOT_SCRIPT" -name "$lib.sh" -type f)
        . "$script"
    done

    get_current_project
    if [ -z "${CURRENT_PROJECT+empty_string}" ]; then
        echo "No current project"
        return
    fi

    get_current_activity
    if [ -z "${CURRENT_ACTIVITY+empty_string}" ]; then
        echo "No current activity"
        return
    fi

    EXIT_DIR=''
    get_activity_file "$CURRENT_ACTIVITY"
    repo_path=$(jq -r '.repoPath' "$ACTIVITY_FILE")
    if [ "$repo_path" = 'null' ] ; then
        echo "No repo path found in $ACTIVITY_FILE"
        return
    fi
    EXIT_DIR=$(eval echo "$repo_path") # Expand any variables in the path
}
