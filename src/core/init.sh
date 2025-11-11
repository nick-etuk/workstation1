#!/usr/bin/env bash
# shellcheck disable=SC2034,SC1090

set -u

[ -n "${INIT_UNIX+set}" ] && return

echo 'Initialising'
INIT_UNIX=1
CURRENT_STEP='general'

[ -z "${FORCE+set}" ] && FORCE=0
[ -z "${DEBUG+set}" ] && DEBUG=1

# [ -z "${SERIAL_ONLY+set}" ] && SERIAL_ONLY='false'
[ -z "${NEW_TAB+set}" ] && NEW_TAB='false'

if [ -z "${WS_ROOT_SCRIPT+set}" ];then
    WS_ROOT_SCRIPT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    # WS_ROOT_UNIX=$( cd -- "$( dirname -- "${WS_ROOT_SCRIPT}/../.." )" &> /dev/null && pwd )
    echo "Init.sh set WS_ROOT_SCRIPT to $WS_ROOT_SCRIPT"
    cd "$WS_ROOT_SCRIPT" || exit 1
fi

echo -n 'Loading libraries'
libraries=$(find "$WS_ROOT_SCRIPT/lib" -name '*.sh' -type f ! -name 'config_ubuntu.sh' ! -name 'config_macos.sh' ! -name 'z*.sh')
for library in $libraries; do
    source "$library"
    echo -n "."
done
echo ''

get_next_run_id
LOG_DIR="$LOG_BASE/$RUN_ID"
mkdir -p "$LOG_DIR"
# mkdir -p "$WORKING_DIR/test_results"

set_repo_dir

DONE_DEPENDENCIES=()
# show_ws_config
# create_registries # now done in Python
get_current_project
# get_project_paths
