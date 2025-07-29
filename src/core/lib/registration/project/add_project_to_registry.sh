#!/usr/bin/env bash

add_project_to_registry() {
    local project_id="$1"
    local project_path="$2"
    local registry_file="${WORKING_DIR}/project_registry.csv"

    if [ ! -d "$project_path" ]; then
        error "Project path '$project_path' does not exist"
    fi

    if [ ! -f "$registry_file" ]; then
        info "Creating project registry"
        touch "$registry_file"
        echo 'id,path' >> "$registry_file"
    fi

    # Remove trailing slash
    project_path="${project_path%/}"

    if ! grep -q "$project_path" "$registry_file"; then
        echo "$project_id,$project_path" >> "$registry_file"
        info "Project $project_id added to registry"
    else
        info "Project $project_id already registered"
    fi
}