#!/usr/bin/env bash

check_for_os_updates() {
    local last_update
    local flag
    
    [ -z "${MY_OS+empty_string}" ] && return

    [ "$MY_OS" != "ubuntu" ] && return

    echo '=> check_for_os_updates'

    # Only update once per day
    flag="$WORKING_DIR/os_last_update.txt"
    if [ -f "$flag" ]; then
        last_update=$(cat "$flag")
        if [ "$(date -d "$last_update" +%s)" -ge "$(date +%s --date '1 day ago')" ]; then
            echo "OS already updated today at $(date -d "$last_update" +'%H:%M')"
            return
        fi
    fi
    echo 'Updating package lists and upgrading packages...'
    sudo apt-get update
    sudo apt-get -y upgrade
    echo "$(date +%Y-%m-%dT%H:%M:%S)" > "$flag"
}

check_for_os_updates