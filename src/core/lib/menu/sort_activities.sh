#!/usr/bin/env bash

sort_activities() {
    local registry_file
    local project_config_file
    local project_sort_order
    local activity_sort_order
    local activity_files
    local activity_id
    local project_config_files=()
    local project_id
    local project_dir

    [ -n "$(ls -A "$WORKING_DIR/activity_sort")" ] &&  rm -- "$WORKING_DIR"/activity_sort/*

    registry_file="$WORKING_DIR/project_registry.csv"
    debug "registry file: $registry_file"
    if [ -f "$registry_file" ]; then
        while IFS=, read -r project_id project_path; do
        [ "$project_id" = 'id' ] && continue  # Skip header line
        [ -z "$project_id" ] && continue  # Skip empty lines

        if [ ! -d "$project_path" ]; then
            info "Directory $project_path does not exist, skipping"
            continue
        fi
            project_config_files+=($(find "$project_path" -name "ws1_project.json" -type f))
        done < "$registry_file"
    fi
    debug "project config files: ${project_config_files[*]}"
    if [ ${#project_config_files[@]} -eq 0 ]; then
        info "No projects found in $WS_ROOT_UNIX"
        return
    fi

    for project_config_file in "${project_config_files[@]}"; do
        project_id=$(jq -r '.id' "$project_config_file")
        [ "$project_id" = 'null' ] && project_id=$(basename "$(dirname "$project_config_file")")

        project_sort_order=$(jq -r '.sortOrder' "$project_config_file")
        [ "$project_sort_order" = 'null' ] && project_sort_order=999

        cp "$project_config_file" "$WORKING_DIR/activity_sort/$project_sort_order-$project_id-ws1.config.json"

        project_dir=$(dirname "$project_config_file")

        activity_files=$(find "$project_dir" -name "*activity*.json" -type f)
        if [ -z "$activity_files" ]; then
            info "No activity files found for $project_dir"
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
