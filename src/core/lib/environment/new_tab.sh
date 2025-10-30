#!/usr/bin/env bash

new_tab() {
    local args
    local cli_command
    local startup_script
    # local full_command

    touch "$NEW_TAB_FLAG"
    args=("$@")

    debug "=>new tab"
    cli_command="${args[*]}"
    cli_command=$(replace "$cli_command" ' ' '~')
    debug "new tab args: >$cli_command<"
    echo "$cli_command" > "$NEW_TAB_COMMANDS"

    # full_command="export NEW_TAB='true'; $command"
    # full_command="export NEW_TAB='true'; ls -l"
    startup_script=$(find "$WS_ROOT_UNIX/core" -name "ws.sh" -type f)

    if [ "$VM" = 'wsl' ]; then
        # wt.exe -w 0 nt --colorScheme "Campbell Powershell" --title "Workstation1 Parallel step" -p "Ubuntu" bash -c "$full_command\; exec zsh 2>&1"
        wt.exe -w 0 nt --colorScheme "Campbell Powershell" --title "Workstation1 Parallel step" -p "Ubuntu" bash -c "$startup_script"
        # wt.exe -w 0 nt --colorScheme "Campbell Powershell" --title "Workstation1 Parallel step" -p "Ubuntu" /usr/bin/zsh -c "$startup_script"
        return
    fi

    case "$MY_OS" in
    macos|ubuntu)
        # ttab "$full_command"
        ttab "$startup_script"
        ;;
    *)
        warn "new_tab: unsupported OS $MY_OS"
        ;;
    esac
}
