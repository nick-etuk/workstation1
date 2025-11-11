# shellcheck shell=sh
echo '=> set_environment_variables'
export EDITOR=/usr/bin/nano

. "$WS_ROOT_UNIX/src/core/steps/environment/unix/add_to_path.sh"
. "$WS_ROOT_UNIX/src/core/steps/environment/unix/add_aliases.sh"