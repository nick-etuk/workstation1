# shellcheck shell=sh
# shellcheck disable=SC3054,SC1090,SC3030,SC1091,SC2012

# Initially, we will use the user's default shell, zsh.
# After setting the environment variables
# we will switch to bash for greater POSIX compatibility.

# Exit if running in an IDE terminal
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
    simple_run_step
    process_new_tab_file
)
script=$(find "$WS_ROOT_UNIX" -name "init.sh" -type f -not -path '.venv_ws1/*')
WS_ROOT_SCRIPT=$(dirname "$script")
for lib in "${libraries[@]}"; do
    script=$(find "$WS_ROOT_SCRIPT" -name "$lib.sh" -type f)
    . "$script"
done

get_shell_version
detect_os
echo "Terminal Shell is $SHELL_NAME version $SHELL_VERSION on $MY_OS"

EDITOR="$(command -v nano || command -v vi || command -v vim || echo "/usr/bin/nano")"
export EDITOR
# . "$WS_ROOT_UNIX/src/core/steps/environment/unix/add_to_path.sh"
# . "$WS_ROOT_UNIX/src/core/steps/environment/unix/add_aliases.sh"

# new_tab_queue="$HOME/.workstation1/working/new_tab_queue"
# if [ -d "$new_tab_queue" ] && [ -n "$(ls "$new_tab_queue")" ]; then
#     echo "Tasks found in New Tab queue..."

#     cd "$WS_ROOT_SCRIPT" || return
#     . ./init.sh

#     oldest_file=$(ls -tr "$new_tab_queue" | head -n 1)
#     if [ -f "$new_tab_queue/$oldest_file" ]; then
#         process_new_tab_file "$new_tab_queue/$oldest_file"
#     fi
#     return
# fi

# startup_script=$(find "$WS_ROOT_UNIX" -name 'ws1.sh' -not -path '.venv_ws1/*')
startup_script="$WS_ROOT_UNIX/ws1.sh"
[ -f "$startup_script" ]  || return

"$startup_script"

set +u

