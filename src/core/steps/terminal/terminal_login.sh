# shellcheck shell=sh
# shellcheck disable=SC3054,SC1090,SC3030,SC1091

# Initially, we will use the user's default shell, zsh.
# After setting the environment variables
# we will switch to bash for greater POSIX compatibility.

# Exit if running in an IDE terminal
empty_string=''
[ -n "${INTELLIJ_ENVIRONMENT_READER+empty_string}" ] && return
[ "$TERM_PROGRAM" = 'vscode' ] && return

set -u
setopt shwordsplit

libraries=(
    get_shell_version 
    detect_os
    logging
    config_dynamic 
    split_string 
    get_first_activity 
    # get_project_paths
    config_base
)
script=$(find "$WS_ROOT_UNIX" -name "init.sh" -type f -not -path '.venv/*')
WS_ROOT_SCRIPT=$(dirname "$script")
for lib in "${libraries[@]}"; do
    script=$(find "$WS_ROOT_SCRIPT" -name "$lib.sh" -type f)
    . "$script"
done

get_shell_version
detect_os
echo "Terminal Shell is $SHELL_NAME version $SHELL_VERSION on $MY_OS"

script=$(find "$WS_ROOT_SCRIPT" -name 'set_environment_variables.sh')
[ -f "$script" ] && . "$script"

# if [ -z "${NEW_TAB+empty_string}" ] || [ "$NEW_TAB" = 'false' ]; then
#     if [ -f "$NEW_TAB_FLAG" ]; then
#         echo "new_tab_flag.txt found"
#         NEW_TAB='true'
#         rm -rf "$NEW_TAB_FLAG"
#     else
#         NEW_TAB='false'
#     fi
# fi

startup_script=$(find "$WS_ROOT_UNIX" -name 'ws.sh' -not -path '.venv/*')
[ -f "$startup_script" ]  || return

# the code below seems to make no difference, so comment it out for now
# if [ -z "${VIRTUAL_ENV+set}" ]; then
#     venv_activate=$(find "$WS_ROOT_UNIX" -name 'activate')
#     [ -f "$venv_activate" ] && . "$venv_activate"
# fi

NEW_TAB='false'
new_tab_queue="$HOME/.workstation/working/new_tab_queue"
if [ -d "$new_tab_queue" ] && [ "$(ls -A "$new_tab_queue")" ]; then
    NEW_TAB='true'
    echo "Items found in New tab queue. Exiting terminal login.sh"
    ls -1 "$new_tab_queue"
fi

# echo "New tab: $NEW_TAB"

if [ "$NEW_TAB" = 'true' ]; then
    set +u
    return
fi

# python3 "$startup_script"
"$startup_script"

exit_script=$(find "$WS_ROOT_SCRIPT" -name 'set_exit_directory.sh')
. "$exit_script"
set_exit_directory
set +u
if [ ! -d "$EXIT_DIR" ]; then
    echo "Exit directory $EXIT_DIR does not exist"
    EXIT_DIR=''
    return
fi
cd "$EXIT_DIR" || exit 1
