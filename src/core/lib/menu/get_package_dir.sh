#!/usr/bin/env bash
# shellcheck disable=SC2034

get_package_dir() {
    local package_id
    local package_files
    
    package_id=$1

    package_files=$(find "$WS_ROOT_UNIX" -name "ws1.config.json" -type f)
    for file in $package_files; do
        id=$(jq -r '.id' "$file")
        if [[ $id == "$package_id" ]]; then
            dirname=$(dirname "$file")
            PACKAGE_DIR="$dirname"
            return
        fi
    done
}