# shellcheck shell=sh
# shellcheck disable=SC3054,SC1090,SC3030,SC1091

# Initially, we will use the user's default shell, zsh.
# After setting the environment variables
# we will switch to bash for greater POSIX compatibility.

echo "=>terminal_login"

set -u
empty_string=''
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

for lib in "${libraries[@]}"; do
    script=$(find "$WS_ROOT_UNIX/core/lib" -name "$lib.sh" -type f)
    . "$script"
done

get_shell_version
detect_os
echo "Terminal Shell is $SHELL_NAME version $SHELL_VERSION on $MY_OS"

script=$(find "$WS_ROOT_UNIX/core" -name 'set_environment_variables.sh')
[ -f "$script" ] && . "$script"

# Exit if running in an IDE terminal
[ -n "${INTELLIJ_ENVIRONMENT_READER+empty_string}" ] && return
[ "${TERM_PROGRAM+empty_string}" = 'vscode' ] && return

# [ -n "${INIT_UNIX+empty_string}" ] && return

if [ -z "${NEW_TAB+empty_string}" ] || [ "$NEW_TAB" = 'false' ]; then
    echo "NEW_TAB is not set. Checking for new_tab_flag.txt"
    if [ -f "$NEW_TAB_FLAG" ]; then
        echo "Found new_tab_flag.txt, setting NEW_TAB to true"
        NEW_TAB='true'
        rm -rf "$NEW_TAB_FLAG"
    else
        echo "new_tab_flag.txt not found, NEW_TAB remains false"
        NEW_TAB='false'
    fi
fi
echo "New tab: $NEW_TAB"

if [ "$NEW_TAB" = 'true' ]; then
    set +u
    return
fi

# script=$(find "$WS_ROOT_UNIX/core" -name 'check_for_os_updates.sh')
# [ -f "$script" ] && . "$script"

startup_script=$(find "$WS_ROOT_UNIX/core" -name 'ws.sh')
[ -f "$startup_script" ]  || return
"$startup_script"

exit_script=$(find "$WS_ROOT_UNIX/core" -name 'set_exit_directory.sh')
. "$exit_script"
set_exit_directory
set +u
if [ ! -d "$EXIT_DIR" ]; then
    echo "Exit directory $EXIT_DIR does not exist"
    EXIT_DIR=''
    return
fi
cd "$EXIT_DIR" || exit 1
