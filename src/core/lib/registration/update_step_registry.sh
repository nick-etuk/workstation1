#!/usr/bin/env bash

get_project_steps() {
    local project_id
    local project_path
    local sort_order
    local step_id
    local step_file
    local step_dirs

    [ -z "${1+empty_string}" ] && error "Project ID is required"
    project_id=$1
    [ -z "${2+empty_string}" ] && error "Project path is required"
    project_path=$2

    # sort step registry by priority (current project=10, core=30, other projects=20).
    get_current_project
    case "$project_id" in
        "$CURRENT_PROJECT")
            sort_order=10
            ;;
        core)
            sort_order=30
            ;;
        *)
            sort_order=20
            ;;
    esac
    
    step_dirs=$(find "$project_path" -name "steps" -type d)
    if [ -z "$step_dirs" ]; then
        warn "No steps directory found in $project_path, skipping"
        return
    fi
    for step_dir in $step_dirs; do
        if [[ "$step_dir" == *"conf/project_template"* ]]; then
            continue
        fi
        steps=$(find "$step_dir" -name "*.json" -type f)
        if [ -z "$steps" ]; then
            info "No step files found in $step_dir"
            continue
        fi
        for step_file in $steps; do
            if [[ "$step_file" == *"__test"* ]]; then
                continue  # Skip tests
            fi
            step_id=$(basename "$step_file")
            step_id=${step_id%.json}  # Remove .json extension
            description=$(get_step_description "$step_id")
            echo "\"$step_id\",\"$project_id\",\"$sort_order\",\"$step_file\",\"$description\"" >> "$WORKING_DIR/tmp.csv"
        done
    done
}

update_step_registry() {
    return
    local step_registry
    local project_registry
    local project_id
    local project_path  

    step_registry="$WORKING_DIR/tmp.csv"
    rm -f "$step_registry"
    touch "$step_registry"

    project_registry="$WORKING_DIR/project_registry.csv"
    [ -f "$project_registry" ] || error "Project registry file $project_registry not found"

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
        get_project_steps "$project_id" "$project_path"
    done < "$project_registry"
    get_project_steps "core" "$WS_ROOT_SCRIPT"


    # cat "$WORKING_DIR/step_registry.csv" | (sed -u 1q; sort)
    # (sed -u 1q; sort) < "$WORKING_DIR/step_registry.csv"
    
    sort -t, -k3,3n -k1,1 "$WORKING_DIR/tmp.csv" -o "$WORKING_DIR/tmp.csv"
    step_registry="$WORKING_DIR/step_registry.csv"
    rm -f "$step_registry"
    touch "$step_registry"
    echo '"step_id","project_id","sort_order","path","description"' > "$step_registry"
    cat "$WORKING_DIR/tmp.csv" >> "$step_registry"
    rm -f "$WORKING_DIR/tmp.csv"
}
