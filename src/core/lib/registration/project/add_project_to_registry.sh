#!/usr/bin/env bash

add_project_to_registry() {
    local project_id="$1"
    local project_path="$2"
    local title="${3:-$project_id}"  # Default to project_id if title not provided
    local display_order
    local sort_order
    local registry_file="${WORKING_DIR}/project_registry.csv"

    if [ ! -d "$project_path" ]; then
        error "Project path '$project_path' does not exist"
    fi

    if [ ! -f "$registry_file" ]; then
        info "Creating project registry"
        touch "$registry_file"
        echo '"project_id","sort_order","display_order","path","title"' > "$registry_file"
    fi

    # Remove trailing slash
    project_path="${project_path%/}"

    if grep -q "$project_path" "$registry_file"; then
        info "Project $project_id already registered"
        return
    fi

    info "Registering Project $project_id at $project_path"
    CURRENT_PROJECT="$project_id"

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

    display_order=$(grep -c '^' "$registry_file")  # Count existing lines for display order

    echo "\"$project_id\",\"$sort_order\",\"$display_order\",\"$project_path\",\"$title\"" >> "$registry_file"
    
    # Sort the registry file by sort_order, and again by display_order
    sort -t, -k2,2 "$registry_file" -o "$registry_file"
    sort -t, -k3,3 "$registry_file" -o "$WORKING_DIR/project_registry_display_ordered.csv"
    
    info "Project $project_id added to registry"
}