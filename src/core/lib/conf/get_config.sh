#!/usr/bin/env bash

get_config() {
    local status_file
    local key
    local value

    case $# in
    1)
        group='general'
        key=$1
        ;;
    2)
        group=$1
        key=$2
        ;;
    *)
        # args=( "$@" )
        # error "Invalid number of arguments for get_config: ${args[*]}"
        echo "Invalid number of arguments for get_config"
        return 1
        ;;
    esac

    [ ! -d "$WORKING_DIR/$group" ] && return

    status_file="$WORKING_DIR/$group/$key.txt"
    [ ! -f "$status_file" ] && return

    value=$(cat "$status_file")
    echo "$value"
}
