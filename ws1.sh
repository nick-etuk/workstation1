#!/usr/bin/env bash
# shellcheck disable=SC1091

script_dir=$(dirname "$(realpath "$0")")
cd "$script_dir" || exit


if [ -z "${WS_ROOT_UNIX+set}" ]; then
    echo 'Setting WS_ROOT_UNIX manually.'
    echo 'printenv | grep WS_ROOT_UNIX:'
    printenv | grep WS_ROOT_UNIX
    WS_ROOT_UNIX="$script_dir"
fi

# todo: run check_for_os_updates.sh, install_pyenv, install_venv, setup_terminal.sh here

# venv_dir=$(find "$WS_ROOT_UNIX" -name '.venv_ws1' -type d)
venv_dir="$WS_ROOT_UNIX/.venv_ws1"
if [ ! -d "$venv_dir" ]; then
    # prompt before creating venv
    read -rp "Virtual environment not found. Create venv? (y/n) " create_venv
    if [ "$create_venv" = "y" ]; then
        echo 'Creating Python virtual environment...'
        venv_dir="$WS_ROOT_UNIX/.venv_ws1"
        python3 -m venv "$venv_dir"
    else
        echo 'Aborting.'
        exit 1
    fi
fi
# echo "VIRTUAL_ENV:"
# echo "${VIRTUAL_ENV+set}"
if [ -z "${VIRTUAL_ENV+set}" ]; then
    echo 'Activating virtual environment...'
    # venv_activate=$(find "$WS_ROOT_UNIX" -name 'activate')
    venv_activate="$WS_ROOT_UNIX/.venv_ws1/bin/activate"
    [ -f "$venv_activate" ] && source "$venv_activate"
fi

if ! pip list | grep -q 'workstation1'; then
    echo 'Installing workstation1 package...'
    # pip install -r "$WS_ROOT_UNIX/requirements.txt"
    pip install -e "$WS_ROOT_UNIX"
fi

startup_script="$WS_ROOT_UNIX/workstation1/ws.py"
python3 "$startup_script" "$@"
