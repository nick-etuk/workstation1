#!/usr/bin/env bash

get_current_project() {
    local second_line
    local second_column

    CURRENT_PROJECT=$(get_config 'current_project')
    if [ -n "$CURRENT_PROJECT" ]; then
        return
    fi

    second_line=$(sed -n '2p' "$WORKING_DIR/project_registry.csv")
    second_column=$(echo "$second_line" | cut -d, -f2)
    CURRENT_PROJECT=$second_column
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