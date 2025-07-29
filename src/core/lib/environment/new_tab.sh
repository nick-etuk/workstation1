#!/usr/bin/env bash

new_tab() {
    local args
    local command
    local full_command

    touch "$NEW_TAB_FLAG"
    args=( "$@" )

    command=${args[*]}
    full_command="export NEW_TAB='true'; $command"

    debug "=>new tab user: >$WSL_USER<"
    debug "new_tab command: >$full_command<"

    if [ "$VM" = 'wsl' ]; then
        wt.exe -w 0 nt --colorScheme "Campbell Powershell" --title "Workstation1 Parallel step" -p "Ubuntu" bash -c "$full_command\; exec zsh 2>&1"
        return
    fi

    case "$MY_OS" in
    macos|ubuntu)
        ttab "$full_command"
        ;;
    *)
        warn "new_tab: unsupported OS $MY_OS"
        ;;
    esac
}
