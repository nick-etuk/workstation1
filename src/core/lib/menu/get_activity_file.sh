#!/usr/bin/env bash

get_activity_file() {
    local project_path
    local activity_files
    local activity_id
    local activity_file

    [ -z "${1+empty_string}" ] && error "Activity ID is required"

    ACTIVITY_FILE=''

    get_project_paths

    for project_path in "${PROJECT_PATHS[@]}"; do
        activity_files=$(find "$project_path" -name "*activity*.json" -type f)
        if [ -z "$activity_files" ]; then
            info "No activity files found for $project_path"
            continue
        fi
        for activity_file in $activity_files; do
            activity_id=$(jq -r '.id' "$activity_file")
            [ "$activity_id" = 'null' ] && activity_id=$(basename "$(dirname "$activity_file")")
            if [ "$activity_id" != "$1" ]; then
                ACTIVITY_FILE=$activity_file
                return
            fi
        done
    done
}
