#!/usr/bin/env bash

sort_activities() {
    local project_path
    local project_config_file
    local project_sort_order
    local activity_sort_order
    local activity_files
    local activity_id
    local project_id

    [ -n "$(ls -A "$WORKING_DIR/activity_sort")" ] &&  rm -- "$WORKING_DIR"/activity_sort/*

    get_project_paths

    for project_path in "${PROJECT_PATHS[@]}"; do
        project_config_file=$(find "$project_path" -name "ws1_project.json" -type f)
        if [ -z "$project_config_file" ]; then
            warn "No project config file found in $project_path, skipping"
            continue
        fi
        project_id=$(jq -r '.id' "$project_config_file")
        [ "$project_id" = 'null' ] && project_id=$(basename "$(dirname "$project_config_file")")

        project_sort_order=$(jq -r '.sortOrder' "$project_config_file")
        [ "$project_sort_order" = 'null' ] && project_sort_order=999

        cp "$project_config_file" "$WORKING_DIR/activity_sort/$project_sort_order-$project_id-ws1.config.json"

        activity_files=$(find "$project_path" -name "*activity*.json" -type f)
        if [ -z "$activity_files" ]; then
            info "No activity files found for $project_path"
            continue
        fi
        for activity_file in $activity_files; do
            activity_sort_order=$(jq -r '.sortOrder' "$activity_file")
            [ "$activity_sort_order" = 'null' ] && activity_sort_order=999
            activity_id=$(jq -r '.id' "$activity_file")
            [ "$activity_id" = 'null' ] && activity_id=$(basename "$(dirname "$activity_file")")
            cp "$activity_file" "$WORKING_DIR/activity_sort/$project_sort_order-$project_id-$activity_sort_order-$activity_id-activity.json"
        done
    done
}
