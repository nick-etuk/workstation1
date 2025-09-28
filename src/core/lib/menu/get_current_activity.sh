#!/usr/bin/env bash

get_current_activity() {
    CURRENT_ACTIVITY=$(get_config 'current_activity')
    if [ -n "$CURRENT_ACTIVITY" ]; then
        return
    fi

    if [ -z "${CURRENT_PROJECT+empty_string}" ]; then
        get_current_project
    fi

    echo "Getting first activity of project $CURRENT_PROJECT"
    get_first_activity "$CURRENT_PROJECT"
    if [ -n "$CURRENT_ACTIVITY" ]; then
        set_config 'current_activity' "$CURRENT_ACTIVITY"
    else
        echo "No activities found for project $CURRENT_PROJECT"
    fi
}