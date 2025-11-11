#!/usr/bin/env bash

function create_registries {
    return
    local registry_file

    registry_file="$WORKING_DIR/project_registry.csv"
    if [ ! -f "$registry_file" ]; then
        warn "Creating project registry"
        touch "$registry_file"
        echo '"project_id","sort_order","display_order","path","title"' > "$registry_file"
    fi

    if [  ! -d "$REPO_DIR/workstation1-template-web" ]; then
        info "Cloning template projects"
        clone_templates
    fi

    if ! grep -q "$REPO_DIR/workstation1-template-web" "$registry_file"; then
        add_project_to_registry 'template-web' "$REPO_DIR/workstation1-template-web" 'Web App'
    fi

    registry_file="$WORKING_DIR/activity_registry.csv"
    if [ ! -f "$registry_file" ]; then
        warn "Creating activity registry"
        update_activity_registry
    fi

    registry_file="$WORKING_DIR/step_registry.csv"
    if [ ! -f "$registry_file" ]; then
        warn "Creating step registry"
        update_step_registry
    fi
}
