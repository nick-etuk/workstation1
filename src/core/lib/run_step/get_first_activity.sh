# shellcheck shell=sh
# shellcheck disable=SC2034,SC3054

get_first_activity() {
    project_id=$1
    if [ -z "$project_id" ]; then
        echo "get_first_activity: project id not specified"
        return
    fi
    
    activity_registry="$WORKING_DIR/activity_registry.csv"
    matching_line=$(awk -F, -v project_id="$project_id" '$2 == project_id { print $1 }' "$activity_registry" | head -n 1)
    echo "=>get_first_activity: project ID: $project_id"
    echo "Matching line: $matching_line"
    if [ -z "$matching_line" ]; then
        echo "No activities found for project $project_id"
        return
    fi
    CURRENT_ACTIVITY="$matching_line"
    set_config 'current_activity' "$CURRENT_ACTIVITY"
    echo "First activity for project $project_id is $CURRENT_ACTIVITY"
}