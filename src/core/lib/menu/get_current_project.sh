#!/usr/bin/env bash

get_current_project() {
    local first_line
    local first_column

    CURRENT_PROJECT=$(get_config 'current_project')
    if [ -n "$CURRENT_PROJECT" ]; then
        return
    fi

    # second_line=$(sed -n '2p' "$WORKING_DIR/project_registry.csv")
    # second_column=$(echo "$second_line" | cut -d, -f2)
    # second_column=${second_column//\"/}
    # CURRENT_PROJECT=$second_column

    registry_file="$WORKING_DIR/project_registry_display_ordered.csv"
    [ -f "$registry_file" ] || error "Project registry file not found: $registry_file"
    first_line=$(sed -n '1p' "$registry_file")
    first_column=$(echo "$first_line" | cut -d, -f1)
    first_column=${first_column//\"/}
    CURRENT_PROJECT=$first_column

    debug "Current project from first line in project registry:$CURRENT_PROJECT"
    set_config 'current_project' "$CURRENT_PROJECT"
    
    CURRENT_ACTIVITY=$(get_config 'current_activity')
    if [ -z "$CURRENT_ACTIVITY" ]; then
        echo "No current activity found in config, getting first activity"
        get_first_activity "$CURRENT_PROJECT"
        if [ -n "$CURRENT_ACTIVITY" ]; then
            set_config 'current_activity' "$CURRENT_ACTIVITY"
        else
            echo "No activities found for project $CURRENT_PROJECT"
        fi
    fi
}