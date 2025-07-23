#!/usr/bin/env bash

set_repo_dir() {
    # Checks if WS_ROOT_WIN has changed. Update REPO_DIR and the profile if it has.
    
    local old_root_path
    local ws1_dir
    
    old_root_path=$(get_config ws_root_unix)
    if [ "$old_root_path" != "$WS_ROOT_UNIX" ]; then
        warn "Workstation1 root path has changed from $old_root_path to $WS_ROOT_UNIX"
        warn 'Please update WS_ROOT_UNIX in your login profile.'
        warn 'If the REPO_DIR has also changed, you will need to update that as well in your login profile.'
        set_config ws_root_unix "$WS_ROOT_UNIX"
        # REPO_DIR=$(cd "$WS_ROOT_UNIX"/../../; pwd)
        ws1_dir="$(dirname "$WS_ROOT_UNIX")"
        REPO_DIR="$(dirname "$ws1_dir")"
        set_config repo_dir "$REPO_DIR"
    fi
}
