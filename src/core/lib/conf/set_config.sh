#!/usr/bin/env bash

set_config() {
    local current_value
    local args
    local status_file
    local group
    local key
    local value

    args=("$@")

    case $# in
    2)
        group='general'
        key=$1
        value=$2
        ;;
    3)
        group=$1
        key=$2
        value=$3
        ;;
    *)
        echo "Invalid number of arguments ($#) for set_config: ${args[*]}"
        return 1
        ;;
    esac

    current_value=$(get_config "$group" "$key")
    if [ "$current_value" = "$value" ]; then
        # debug "set_config: ${args[*]} unchanged from '$value'"
        return
    fi

    mkdir -p "$WORKING_DIR/$group"
    
    status_file="$WORKING_DIR/$group/$key.txt"
    # debug "=>set config"
    # debug "WORKING_DIR: $WORKING_DIR group: $group, key: $key, value: $value"
    # debug "status_file: $status_file"
    [ ! -f "$status_file" ] && touch "$status_file"
    echo "$value" > "$status_file"
}
