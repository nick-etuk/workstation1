#!/usr/bin/env bash

do_quit() {
    printf "To show this menu, enter the command \'ws\'\n"
    echo 'The script ws.sh is located at:'
    startup_script=$(find "$WS_ROOT_UNIX/core" -name "ws.sh" -type f)
    dirname "$startup_script"
}
