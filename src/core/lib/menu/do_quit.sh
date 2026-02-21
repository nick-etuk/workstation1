#!/usr/bin/env bash

do_quit() {
    printf "To show this menu again, enter the command \'ws\'\n"
    echo 'The script ws.py is located at:'
    startup_script=$(find "$WS_ROOT_UNIX" -name "ws.py" -type f -not -path ".venv_ws1/*")
    dirname "$startup_script"
}
