#!/usr/bin/env bash
# shellcheck disable=SC2034

get_menu_file() {
    local activity_id
    local menu_files
    
    activity_id=$1

    get_package_dir "$CURRENT_PACKAGE"
    menu_files=$(find "$PACKAGE_DIR" -name "*activity*.json" -type f)
    for file in $menu_files; do
        id=$(jq -r '.id' "$file")
        if [[ $id == "$activity_id" ]]; then
            MENU_FILE="$file"
            return
        fi
    done
}