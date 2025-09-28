#!/usr/bin/env bash
# shellcheck disable=SC1091

get_wsl_win_info() {
    if [ -s "$WORKING_DIR/WS_USER_UNIXnames.sh" ]; then
        source "$WORKING_DIR/WS_USER_UNIXnames.sh"
        return
    fi

    WS_USER_WIN=$(get_config 'WS_USER_WIN')
    if [ -n "$WS_USER_WIN" ]; then
        WORKING_DIR_WIN=$(get_config 'working_dir_win')
        WINDOWS_HOME=$(get_config 'windows_home')
        return
    fi

    echo "No config entries found, using CMD.exe to capture WS_USER_WIN"
    WS_USER_WIN=$(cmd.exe /c "echo %USERNAME%" | tr -d '\r')
    WINDOWS_HOME=$(cmd.exe /c "echo %USERPROFILE%" | tr -d '\r')
    WORKING_DIR_WIN=$(wslpath "$WINDOWS_HOME\\.workstation1\\working")
    [ -n "$WS_USER_WIN" ] && set_config 'WS_USER_WIN' "$WS_USER_WIN"
    [ -n "$WORKING_DIR_WIN" ] && set_config 'working_dir_win' "$WORKING_DIR_WIN"
    [ -n "$WINDOWS_HOME" ] && set_config 'windows_home' "$WINDOWS_HOME"
}
