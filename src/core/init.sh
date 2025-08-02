#!/usr/bin/env bash
# shellcheck disable=SC2034,SC1090

set -u

empty_string=''
[ -n "${INIT_UNIX+empty_string}" ] && return

echo 'Initialising'
INIT_UNIX=1
CURRENT_STEP='general'

[ -z "${FORCE+empty_string}" ] && FORCE=0
[ -z "${DEBUG+empty_string}" ] && DEBUG=1

# [ -z "${SERIAL_ONLY+empty_string}" ] && SERIAL_ONLY='false'
[ -z "${NEW_TAB+empty_string}" ] && NEW_TAB='false'

if [ -z "${WS_ROOT_UNIX+empty_string}" ];then
    script_path=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    WS_ROOT_UNIX=$( cd -- "$( dirname -- "${script_path}/../.." )" &> /dev/null && pwd )
    echo "WS_ROOT_UNIX set to $WS_ROOT_UNIX"
    cd "$WS_ROOT_UNIX" || exit 1
fi

echo -n 'Loading libraries'
libraries=$(find "$WS_ROOT_UNIX/core/lib" -name '*.sh' -type f ! -name 'config_ubuntu.sh' ! -name 'config_macos.sh' ! -name 'z*.sh')
for library in $libraries; do
    source "$library"
    echo -n "."
done
echo ''

get_next_run_id
LOG_DIR="$LOG_BASE/$RUN_ID"
mkdir -p "$LOG_DIR"
mkdir -p "$WORKING_DIR/activity_sort"
mkdir -p "$WORKING_DIR/test_results"

set_repo_dir

DONE_DEPENDENCIES=()
show_ws_config
create_registries
get_current_project
get_project_paths
update_step_registry
