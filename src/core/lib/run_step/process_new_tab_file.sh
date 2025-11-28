#!/usr/bin/env bash

process_new_tab_file() {
    local task_file="$1"
    local file_content
    local line

    debug "Processing new tab file: $task_file"
    # Read file into a variable, delete the file, then process the contents.
    # This saves having to wait for the process to finish before deleting the file.

    file_content=$(cat "$task_file")
    rm -f "$task_file"
    while IFS= read -r line; do
        split_string "$line" "~"
        # run_step_simple "${SPLIT_STRING[@]}"
        run_step "${SPLIT_STRING[@]}"

    done <  <(echo "$file_content")
}
