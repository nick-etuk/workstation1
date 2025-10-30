#!/usr/bin/env bash
# shellcheck disable=SC2034,SC1091

empty_string=''

if [ -z "${INIT_UNIX+empty_string}" ]; then
    script_dir=$(dirname "$(realpath "$0")")
    cd "$script_dir/.." || exit
    . ./init.sh || exit 1
fi

if ! command -v jq >/dev/null ; then install_jq; fi

run_step core_steps
echo "Node version: $(node -v)"

if [ -f "$NEW_TAB_COMMANDS" ]; then
    debug "=>ws.sh is parallel"

    mapfile -t commands < "$NEW_TAB_COMMANDS"
    debug "New tab commands:>${commands[*]}<"
    NEW_TAB='true'
    rm -f "$NEW_TAB_COMMANDS"
    [ -f "$NEW_TAB_FLAG" ] && rm -f "$NEW_TAB_FLAG"

    for cmd in "${commands[@]}"; do
        debug "raw command:>${cmd}<"
        IFS='~' read -ra split_string <<< "$cmd"
        debug "formatted command:>${split_string[*]}<"
        cli_command "${split_string[@]}"
        # echo "Running command from new tab commands: $cmd"
        # cli_command "$cmd"
    done
    exit 0
fi

if [ $# -eq 0 ]; then
    show_menu_main
    # do_quit
    exit 0
fi

cli_command "$@"
