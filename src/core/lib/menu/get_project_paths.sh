#!/usr/bin/env bash

get_project_paths() {
    local registry_file
    local project_id
    local project_path
    local filter=''
    local calling_function

    if [ -n "${PROJECT_PATHS+empty_string}" ]; then
        info "Project paths already populated"

        if [ -z ${FUNCNAME[0]+empty_string} ]; then
            # Called by a top-level script, not a function
            calling_function=''
        else
            # Called by a function
            calling_function=${FUNCNAME[1]}
            [ "$SHELL_NAME" = 'zsh' ] && calling_function=${FUNCNAME[2]}
        fi
        info "Called by $calling_function"
        info "Project paths: ${PROJECT_PATHS[*]}"
        return
    fi

    [ -n "${1+empty_string}" ] && filter="$1"
    
    PROJECT_PATHS=()
    registry_file="$WORKING_DIR/project_registry.csv"
    [ -f "$registry_file" ] || error "Registry file $registry_file not found"

    while IFS=, read -r sort_order project_id project_path; do
        [ "$project_id" = 'project_id' ] && continue  # Skip header line
        [ -z "$project_id" ] && continue  # Skip empty lines

        if [ ! -d "$project_path" ]; then
            info "Directory $project_path does not exist, skipping"
            continue
        fi
        if [ -n "$filter" ] && [ "$project_id" = "$filter" ]; then
            PROJECT_PATHS+=("$project_path")
            return
        fi
        PROJECT_PATHS+=("$project_path")
    done < "$registry_file"
}
