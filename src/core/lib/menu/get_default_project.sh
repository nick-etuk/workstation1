#!/usr/bin/env bash

get_default_project() {
    local project_config_files
    
    echo 'Current project not set. Getting default project...'
    
    # If there are no projects, exit
    # If there is one project, return that
    # If there is more than one...
    # Look in config.json for defaultProject.
    # If set, return that
    # Otherwise, return the first project

    project_config_files=$(find "$WS_ROOT_UNIX" -name "ws1_project.json" -type f)
    if [ -z "$project_config_files" ]; then
        echo "No projects found in $WS_ROOT_UNIX"
        return
    fi

    length=$(echo "$project_config_files" | wc -l)
    echo "project_config_files.len=$length"
    if [ "$length" -eq 1 ]; then
        CURRENT_PROJECT=$(jq -r '.id' "${project_config_files[0]}")
        echo "One project. Current project set to $CURRENT_PROJECT"
        return
    fi 

    echo 'Multiple projects'
    CURRENT_PROJECT=$(jq -r '.defaultProject' "$WS_ROOT_UNIX/config.json")
    if [ -n "$CURRENT_PROJECT" ] && [ "$CURRENT_PROJECT" != 'null' ]; then
        echo "Current project set to $CURRENT_PROJECT, the default project in config.json"
        return
    fi

    first_project=$(echo "$project_config_files" | head -n 1)
    CURRENT_PROJECT=$(jq -r '.id' "$first_project")
    echo "Current project set to first project - $CURRENT_PROJECT"
}