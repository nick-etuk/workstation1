#!/usr/bin/env bash

get_default_package() {
    local package_config_files
    
    echo 'Current package not set. Getting default package...'
    
    # If there are no packages, exit
    # If there is one package, return that
    # If there is more than one...
    # Look in config.json for defaultPackage.
    # If set, return that
    # Otherwise, return the first package

    package_config_files=$(find "$WS_ROOT_UNIX" -name "ws1.config.json" -type f)
    if [ -z "$package_config_files" ]; then
        echo "No packages found in $WS_ROOT_UNIX"
        return
    fi

    length=$(echo "$package_config_files" | wc -l)
    echo "package_config_files.len=$length"
    if [ "$length" -eq 1 ]; then
        CURRENT_PACKAGE=$(jq -r '.id' "${package_config_files[0]}")
        echo "One package. Current package set to $CURRENT_PACKAGE"
        return
    fi 

    echo 'Multiple packages'
    CURRENT_PACKAGE=$(jq -r '.defaultApp' "$WS_ROOT_UNIX/config.json")
    if [ -n "$CURRENT_PACKAGE" ] && [ "$CURRENT_PACKAGE" != 'null' ]; then
        echo "Current package set to $CURRENT_PACKAGE, the default package in config.json"
        return
    fi

    first_package=$(echo "$package_config_files" | head -n 1)
    CURRENT_PACKAGE=$(jq -r '.id' "$first_package")
    echo "Current package set to first package - $CURRENT_PACKAGE"
}