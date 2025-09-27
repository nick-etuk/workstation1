#!/usr/bin/env bash

set_exit_directory() {
    # Get the current activity
    # and switch to the directory of the activity
    # If no activity is set, get the first activity

    libraries=(
        get_shell_version 
        detect_os
        logging
        config_dynamic 
        split_string 
        get_default_project 
        get_first_activity
        get_activity_file
        # get_project_paths
        config_base
    )

    for lib in "${libraries[@]}"; do
        script=$(find "$WS_ROOT_UNIX/core/lib" -name "$lib.sh" -type f)
        . "$script"
    done
    get_shell_version
    detect_os
    # get_current_project
    
    if [ -z "$CURRENT_PROJECT" ]; then 
        echo "No current project"
        return
    fi
    
    if [ -z "$CURRENT_ACTIVITY" ]; then 
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
