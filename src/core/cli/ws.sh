#!/usr/bin/env bash
# shellcheck disable=SC2034,SC1091

empty_string=''

if [ -z "${INIT_UNIX+empty_string}" ]; then
    script_dir=$(dirname "$(realpath "$0")")
    cd "$script_dir/.." || exit
    . ./init.sh || exit 1
fi

if [ "$MY_OS" = "macos" ] && ! command -v brew >/dev/null; then install_homebrew; fi
if ! command -v jq >/dev/null ; then install_jq; fi

run_step setup_terminal

if [ $# -eq 0 ]; then
    show_menu_main
    # do_quit
    exit 0
fi

cli_command "$@"
