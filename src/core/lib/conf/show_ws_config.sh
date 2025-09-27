#!/usr/bin/env bash

show_config_base() {
    echo "MY_OS: $MY_OS"
    echo "BASE_DIR: $BASE_DIR"
    echo "WORKING_DIR: $WORKING_DIR"
    echo "LOG_DIR: $LOG_DIR"
    echo "REPO_DIR: $REPO_DIR"
    echo "DEBUG: $DEBUG"
    echo "FORCE: $FORCE"
}

show_config_unix() {
    echo "SHELL: $SHELL_NAME version: $SHELL_VERSION"
    echo "WS_ROOT_UNIX: $WS_ROOT_UNIX"
    echo "CURRENT_USER: $WS_USER_UNIX"
}

show_config_wsl() {
    echo "WS_USER_WIN: $WS_USER_WIN"
    echo "WORKING_DIR_WIN: $WORKING_DIR_WIN"
}

show_ws_config() {
    show_config_base
    show_config_unix
    [ "$VM" = 'wsl' ] && show_config_wsl
}
