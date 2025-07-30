#!/usr/bin/env bash
# shellcheck disable=SC2034,SC2153

show_menu_extras() {
    printf "\tA Advanced \n"
    printf "\tH Help \n"
    printf "\tU Uninstall \n"
    printf "\tQ Quit \n"
}

show_menu_main() {
    local package_sort_order
    local activity_sort_order
    local activity_title
    local activity_package_id
    local activity_files
    local package_title
    local package_id
    local package_dir
    local option_num
    local option
    local empty_option
    local activity_id
    local activity_id_list
    local package_config_files
    local repo_path
    local package_activity_id
    local split_string
    local selected_activity_id

    empty_option=false
    option=''

    sort_activities
    package_config_files=$(find "$WORKING_DIR/activity_sort" -name "*-ws1_project.json" -type f | sort)
    if [ -z "$package_config_files" ]; then
        error "No packages found in $WORKING_DIR/activity_sort"
        return
    fi

    option_num=0
    activity_id_list=()
    printf "\nWelcome to workstation1\n"
    printf "To start an activity, enter the command 'ws' followed by an activity name, \n"
    printf "or just 'ws' to show this menu again.\n"

    for package_config_file in $package_config_files; do
        # file name format: $package_sort_order-$package_id-ws1_project.json
        package_filename=$(basename "$package_config_file")
        split_string "$package_filename" "-"
        package_id="${SPLIT_STRING[1]}"
        [ "$SHELL_NAME" = zsh ] && package_id="${SPLIT_STRING[2]}"

        package_title=$(jq -r '.title' "$package_config_file")
        if [ "$package_title" = 'null' ] ; then
            warn "No title found in $package_config_file"
            continue
        fi
        
        if [ -n "$package_title" ]; then
            title_length=${#package_title}
            printf "\n\n\t"
            printf "%0.s-" $(seq 1 "$title_length")
            printf "\n\t%s\n" "$package_title"
            printf "\t"
            printf "%0.s-" $(seq 1 "$title_length")
            printf "\n"
        fi

        activity_files=$(find "$WORKING_DIR/activity_sort" -name "*-activity.json" -type f | sort)
        if [ -z "$activity_files" ]; then
            error "No activities found in $WORKING_DIR/activity_sort"
            continue
        fi
        for activity_file in $activity_files; do
            # filename format: $package_sort_order-$package_id-$activity_sort_order-$activity_id-activity.json
            activity_filename=$(basename "$activity_file")
            split_string "$activity_filename" "-"
            activity_package_id="${SPLIT_STRING[1]}"
            [ "$SHELL_NAME" = zsh ] && activity_package_id="${SPLIT_STRING[2]}"

            if [ "$activity_package_id" != "$package_id" ]; then
                continue
            fi
            activity_id="${SPLIT_STRING[3]}"
            [ "$SHELL_NAME" = zsh ] && activity_id="${SPLIT_STRING[4]}"
            activity_id_list+=("$activity_id")

            activity_title=$(jq -r '.title' "$activity_file")
            repo_path=$(jq -r '.repoPath' "$activity_file")
            if [ "$activity_title" = 'null' ] ; then
                warn "No title found in $activity_file"
                continue
            fi

            option_num=$((option_num+1))
            # printf "\t%s %s\n" "$option_num" "$activity_title"
            printf "\t%s \t %s \n" "$activity_id" "$activity_title"
            set_config 'activity_repo_path' "$package_id.$activity_id" "$repo_path"
            set_config 'activity_id' "$option_num" "$package_id.$activity_id"
            set_config 'activity_id_package' "$activity_id" "$package_id"
        done
    done
    set_config 'activity_id_list' "${activity_id_list[*]+"${activity_id_list[*]}"}"

    printf "\n"
    show_menu_extras
    printf "\n"
    # do_quit

    # read -rp "[Q]: " option
    case $option in
        A|a) show_menu_advanced ;;
        H|h) do_help ;;
        U|u) uninstall ;;
        Q|q) do_quit ;;
        "")
            empty_option=true
            # info "Empty menu option selected"
            do_quit
            ;;
        *)
            package_activity_id=$(get_config activity_id "$option")
			[ -z "$package_activity_id" ] && error "Unknown menu option $option"

            debug "package_activity_id: $package_activity_id"
            split_string "$package_activity_id" "."
            debug "split_string: >${SPLIT_STRING[*]}<"
            CURRENT_PROJECT="${SPLIT_STRING[0]}"
            [ "$SHELL_NAME" = zsh ] && CURRENT_PROJECT="${SPLIT_STRING[1]}"
            set_config 'current_project' "$CURRENT_PROJECT"
            debug "Current package: $CURRENT_PROJECT"
            selected_activity_id="${SPLIT_STRING[1]}"
            [ "$SHELL_NAME" = zsh ] && selected_activity_id="${SPLIT_STRING[2]}"
            set_config 'current_activity' "$selected_activity_id"
            debug "selected_activity_id: $selected_activity_id"
            run_activity "$selected_activity_id"
			;;
    esac
    # show_menu_main
}
