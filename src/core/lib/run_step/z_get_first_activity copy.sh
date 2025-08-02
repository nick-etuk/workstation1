# shellcheck shell=sh
# shellcheck disable=SC2034,SC3054

zget_first_activity() {
    project_id=$1
    if [ -z "$project_id" ]; then
        echo "get_first_activity: project id not specified"
        return
    fi
    # get_project_paths "$project_id"
    # activity_files=$(find "$project_DIR" -name "**activity*.json" -type f | sort)
    # if [ -z "$activity_files" ]; then
    #     echo "No activities items found for $project_id"
    #     return
    # fi

    # first_activity_file=$(echo "$activity_files" | head -n 1)
    # CURRENT_ACTIVITY=$(jq -r '.id' "$first_activity_file")

    activity_files=$(find "$WORKING_DIR/activity_sort" -name "*-activity.json" -type f | sort)
    if [ -z "$activity_files" ]; then
        error "No activities found in $WORKING_DIR/activity_sort"
        return
    fi
    for activity_file in $activity_files; do
        # filename format: $project_sort_order-$project_id-$activity_sort_order-$activity_id-activity.json
        split_string "$(basename "$activity_file")" "-"
        echo "get_first_activity: split_string: ${SPLIT_STRING[*]}"
        activity_project_id="${SPLIT_STRING[1]}"
        [ "$SHELL_NAME" = 'zsh' ] && activity_project_id="${SPLIT_STRING[2]}"
        echo "get_first_activity: activity_project_id: $activity_project_id"
        if [ "$activity_project_id" = "$project_id" ]; then
            CURRENT_ACTIVITY="${SPLIT_STRING[3]}"
            [ "$SHELL_NAME" = 'zsh' ] && CURRENT_ACTIVITY="${SPLIT_STRING[4]}"
            echo "get_first_activity: current activity: $CURRENT_ACTIVITY"
            return
        fi
    done
}