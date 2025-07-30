#!/usr/bin/env bash

function update_registries {
    local registry_file="${WORKING_DIR}/project_registry.csv"

    if [ ! -f "$registry_file" ]; then
        warn "Creating project registry"
        touch "$registry_file"
        echo 'sort_order,id,path' >> "$registry_file"
        echo "20,template-web,$REPO_DIR/workstation1-template-web" > "$registry_file"
    fi

    if [  ! -d "$REPO_DIR/workstation1-template-web" ]; then
        info "Cloning template projects"
        clone_templates
    fi
}
