#!/usr/bin/env bash

function create_registries {
    local registry_file

    registry_file="${WORKING_DIR}/project_registry.csv"
    if [ ! -f "$registry_file" ]; then
        warn "Creating project registry"
        touch "$registry_file"
        echo '"project_id","sort_order","path","title"' > "$registry_file"
        # shellcheck disable=SC2016
        echo '"template-web",20,"$REPO_DIR/workstation1-template-web","Web App"' >> "$registry_file"
    fi

    if [  ! -d "$REPO_DIR/workstation1-template-web" ]; then
        info "Cloning template projects"
        clone_templates
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
