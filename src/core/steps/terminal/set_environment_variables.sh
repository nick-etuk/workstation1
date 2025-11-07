# shellcheck shell=sh
echo '=> set_environment_variables'
export EDITOR=/usr/bin/nano

. "$(find "$WS_ROOT_UNIX" -name 'add_to_path.sh' -not -path '.venv/*')"
. "$(find "$WS_ROOT_UNIX" -name 'add_aliases.sh' -not -path '.venv/*')"
