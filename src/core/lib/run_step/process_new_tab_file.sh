#!/usr/bin/env bash

process_new_tab_file() {
    local task_file="$1"
    local file_content
    local line

    echo "Processing new tab file: $task_file"
    # read while file into a variable, delete the file, then process the contents
    # This saves having to wait for the process to finish before deleting the file

    file_content=$(cat "$task_file")
    debug "New tab file content:>$file_content<"
    rm -f "$task_file"
    while IFS= read -r line; do
        debug "New tab line:>$line<"
        split_string "$line" "~"
        debug "split line:>${SPLIT_STRING[*]}<"
        simple_run_step "${SPLIT_STRING[@]}"
    done <  <(echo "$file_content")
}
