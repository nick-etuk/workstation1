#!/usr/bin/env bash

get_activity_file() {
    local activity_id
    [ -z "${1+empty_string}" ] && error "Activity ID is required"
    activity_id="\"$1\""

    ACTIVITY_FILE=''
    ACTIVITY_FILE=$(awk -F , -v id="$activity_id" '$1 == id { print $5 }' "$WORKING_DIR/activity_registry.csv")
    [ -z "$ACTIVITY_FILE" ] && warn "Activity file not found for ID: $1"
    ACTIVITY_FILE=${ACTIVITY_FILE//\"/}
}
