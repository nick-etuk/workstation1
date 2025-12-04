#!/usr/bin/env bash

get_context() {
    CURRENT_PROJECT_ID=$(get_config 'current_project_id')
    CURRENT_PROJECT_ROOT=$(get_config 'current_project_root')
    debug "Current project: $CURRENT_PROJECT_ID at $CURRENT_PROJECT_ROOT"
}