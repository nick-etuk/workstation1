#!/usr/bin/env bash

get_activity_file() {
    [ -z "${1+empty_string}" ] && error "Activity ID is required"

    ACTIVITY_FILE=''
    ACTIVITY_FILE=$(awk -F , -v id="$1" '$1 == id { print $2 }' "$WORKING_DIR/activity_registry.csv")
    [ -z "$ACTIVITY_FILE" ] && warn "Activity file not found for ID: $1"
}
