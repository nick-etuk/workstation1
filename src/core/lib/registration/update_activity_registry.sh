#!/usr/bin/env bash

update_activity_registry() {
    local project_id
    local project_path
    local project_sort_order
    local project_display_order
    local project_title
    local project_registry
    local option_num
    local activity_registry
    local activity_id
    local activity_title
    local activity_sort_order
    local activity_files

    # [ -n "$(ls -A "$WORKING_DIR/activity_sort")" ] &&  rm -- "$WORKING_DIR"/activity_sort/*
    
    activity_registry="$WORKING_DIR/activity_registry.csv"
    [ -f "$activity_registry" ] && rm -- "$activity_registry"
    touch "$activity_registry"
    echo '"activity_id","project_id","display_order","option_num","path","title"' > "$activity_registry"

    option_num=0
    project_registry="$WORKING_DIR/project_registry.csv"
    [ -f "$project_registry" ] || error "Project registry not found at $project_registry"

    while IFS=, read -r project_id project_sort_order project_display_order project_path project_title; do
        [ "$project_id" = '"project_id"' ] && continue  # Skip header line
        [ -z "$project_id" ] && continue  # Skip empty lines
        project_id=${project_id//\"/}
        project_sort_order=${project_sort_order//\"/}
        project_display_order=${project_display_order//\"/}
        project_path=${project_path//\"/}
        project_title=${project_title//\"/}

        if [ ! -d "$project_path" ]; then
            info "Directory $project_path does not exist, skipping"
            continue
        fi

        # cp "$project_config_file" "$WORKING_DIR/activity_sort/$project_sort_order-$project_id-ws1_project.json"

        activity_files=$(find "$project_path" -name "*activity*.json" -type f)
        if [ -z "$activity_files" ]; then
            info "No activity files found for $project_path"
            continue
        fi
        for activity_file in $activity_files; do
            option_num=$((option_num + 1))
            activity_id=$(jq -r '.id' "$activity_file")
            activity_title=$(jq -r '.title' "$activity_file")
            activity_sort_order=$(jq -r '.sortOrder' "$activity_file")
            [ "$activity_sort_order" = 'null' ] && activity_sort_order=999
            # cp "$activity_file" "$WORKING_DIR/activity_sort/$project_sort_order-$project_id-$activity_sort_order-$activity_id-activity.json"
            echo "\"$activity_id\",\"$project_id\",\"$activity_sort_order\",\"$option_num\",\"$activity_file\",\"$activity_title\"" >> "$activity_registry"

        done
    done < "$project_registry"

    sort -t, -k3,3 "$activity_registry" -o "$activity_registry"
}
