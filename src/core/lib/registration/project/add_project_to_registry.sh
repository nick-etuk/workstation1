#!/usr/bin/env bash

add_project_to_registry() {
    local project_id="$1"
    local display_order="${2:-999}"  # Default to 999 if not provided
    local project_path="$3"
    local title="$4"
    local sort_order
    local registry_file="${WORKING_DIR}/project_registry.csv"

    if [ ! -d "$project_path" ]; then
        error "Project path '$project_path' does not exist"
    fi

    if [ ! -f "$registry_file" ]; then
        info "Creating project registry"
        touch "$registry_file"
        echo 'project_id,sort_order,display_order,path,title' > "$registry_file"
    fi

    # Remove trailing slash
    project_path="${project_path%/}"

    if grep -q "$project_path" "$registry_file"; then
        info "Project $project_id already registered"
        return
    fi
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
    echo "$project_id,$sort_order,$display_order,$project_path,$title" >> "$registry_file"
    info "Project $project_id added to registry"
}