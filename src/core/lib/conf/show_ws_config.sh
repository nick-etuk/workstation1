#!/usr/bin/env bash

show_ws_config() {
    echo "SHELL: $SHELL_NAME version: $SHELL_VERSION"
    echo "CURRENT_USER: $WSL_USER"
    echo "WINDOWS_USER: $WINDOWS_USER"
    echo "WORKING_DIR_WIN: $WORKING_DIR_WIN"
    echo "MY_OS: $MY_OS"
    echo "WS_ROOT_UNIX: $WS_ROOT_UNIX"
    echo "BASE_DIR: $BASE_DIR"
    echo "WORKING_DIR: $WORKING_DIR"
    echo "WORKING_DIR_WIN: $WORKING_DIR_WIN"
    echo "LOG_DIR: $LOG_DIR"
    echo "REPO_DIR: $REPO_DIR"
    echo "DEBUG: $DEBUG"
    echo "FORCE: $FORCE"
}
