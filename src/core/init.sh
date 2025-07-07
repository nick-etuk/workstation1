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
    SCRIPT_PATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    WS_ROOT_UNIX=$( cd -- "$( dirname -- "${SCRIPT_PATH}/../.." )" &> /dev/null && pwd )
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

repo_dir=$(get_config repo_dir)
[ -n "$repo_dir" ] && REPO_DIR_UNIX="$repo_dir"

STAGE_STEPS=()
DONE_DEPENDENCIES=()
show_config
