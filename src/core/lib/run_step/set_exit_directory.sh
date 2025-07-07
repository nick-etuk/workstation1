#!/usr/bin/env bash

set_exit_directory() {
    libraries=(
        get_shell_version 
        detect_os
        logging
        config_dynamic 
        split_string 
        get_default_package 
        get_first_activity 
        get_package_dir
        config_base
    )

    for lib in "${libraries[@]}"; do
        script=$(find "$WS_ROOT_UNIX/core/lib" -name "$lib.sh" -type f)
        . "$script"
    done
    get_shell_version
    detect_os
    CURRENT_PACKAGE=$(get_config 'current_package')
    if [ -z "$CURRENT_PACKAGE" ]; then 
        get_default_package

        if [ -n "$CURRENT_PACKAGE" ]; then
            set_config 'current_package' "$CURRENT_PACKAGE"
        else
            echo "No default package found, please set a package first"
            return
        fi
    fi

    CURRENT_ACTIVITY=$(get_config 'current_activity')
    if [ -z "$CURRENT_ACTIVITY" ]; then
        echo "No current activity found in config, getting first activity"
        get_first_activity "$CURRENT_PACKAGE"
        if [ -n "$CURRENT_ACTIVITY" ]; then
            set_config 'current_activity' "$CURRENT_ACTIVITY"
        else
            echo "No activities found for package $CURRENT_PACKAGE"
            return
        fi
    fi

    get_package_dir "$CURRENT_PACKAGE"
    activity_files=$(find "$PACKAGE_DIR" -name "*activity*.json" -type f | sort)
    if [ -z "$activity_files" ]; then
        echo "No activities items found for $CURRENT_PACKAGE"
        return
    fi

    EXIT_DIR=''
    for activity_file in $activity_files; do
        activity_id=$(jq -r '.id' "$activity_file")
        if [ "$activity_id" = "$CURRENT_ACTIVITY" ]; then
            repo_path=$(jq -r '.repoPath' "$activity_file")
            if [ "$repo_path" = 'null' ] ; then
                echo "No repo path found in $activity_file"
                return
            fi
            EXIT_DIR=$(eval echo "$repo_path") # Expand any variables in the path
            return
        fi
    done
}
