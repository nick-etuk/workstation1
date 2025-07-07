#!/usr/bin/env bash

sort_activities() {
    local registry_file
    local package_config_file
    local package_sort_order
    local activity_sort_order
    local activity_files
    local activity_id
    local package_config_files=()
    local package_id
    local package_dir

    [ -n "$(ls -A "$WORKING_DIR/activity_sort")" ] &&  rm -- "$WORKING_DIR"/activity_sort/*

    registry_file="$WORKING_DIR/app_directories.txt"
    debug "registry file: $registry_file"
    if [ -f "$registry_file" ]; then
        while IFS= read -r app_directory; do
        debug "app directory: $app_directory"
        if [ ! -d "$app_directory" ]; then
            info "Directory $app_directory does not exist, skipping"
            continue
        fi
            package_config_files+=($(find "$app_directory" -name "ws1.config.json" -type f))
        done < "$registry_file"
    fi
    debug "package config files: ${package_config_files[*]}"
    if [ ${#package_config_files[@]} -eq 0 ]; then
        info "No packages found in $WS_ROOT_UNIX"
        return
    fi

    for package_config_file in "${package_config_files[@]}"; do
        package_id=$(jq -r '.id' "$package_config_file")
        [ "$package_id" = 'null' ] && package_id=$(basename "$(dirname "$package_config_file")")

        package_sort_order=$(jq -r '.sortOrder' "$package_config_file")
        [ "$package_sort_order" = 'null' ] && package_sort_order=999

        cp "$package_config_file" "$WORKING_DIR/activity_sort/$package_sort_order-$package_id-ws1.config.json"

        package_dir=$(dirname "$package_config_file")

        activity_files=$(find "$package_dir" -name "*activity*.json" -type f)
        if [ -z "$activity_files" ]; then
            info "No activity files found for $package_dir"
            continue
        fi
        for activity_file in $activity_files; do
            activity_sort_order=$(jq -r '.sortOrder' "$activity_file")
            [ "$activity_sort_order" = 'null' ] && activity_sort_order=999
            activity_id=$(jq -r '.id' "$activity_file")
            [ "$activity_id" = 'null' ] && activity_id=$(basename "$(dirname "$activity_file")")
            cp "$activity_file" "$WORKING_DIR/activity_sort/$package_sort_order-$package_id-$activity_sort_order-$activity_id-activity.json"
        done
    done
}
