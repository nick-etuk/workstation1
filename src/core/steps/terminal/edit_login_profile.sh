#!/usr/bin/env bash
# shellcheck disable=SC2016,SC2129

function add_to_profile {
    local target
    local lines=()
    lines=(
        "# workstation1_v$WS_VERSION start"
        "export WS_ROOT_UNIX=\"$WS_ROOT_UNIX\""
        'export GPG_TTY=$(tty)'
        'export NVM_DIR="$HOME/.nvm"'
        '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"'
        '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"'
        'startup_script=$(find "$WS_ROOT_UNIX/core" -name "ws.sh" -type f)'
        'if [ -f "$startup_script" ] ; then'
        '  ws() { "$startup_script" "$@"; }'
        '  menu() { "$startup_script" "$@"; }'
        'fi'
        'login_script=$(find "$WS_ROOT_UNIX/core/steps" -name "terminal_login.sh" -type f)'
        '[ -f "$login_script" ] && . "$login_script"'
        'set +u'
        "# workstation1_v$WS_VERSION end"
    )

    target=$1

    [ -f "$target" ] || return 0

    grep -q "workstation1_v$WS_VERSION" "$target" && return 0


    if [ "$target" = ~/.zshrc ]; then
        # Add commands to top of file to avoid problems with p10k-instant-prompt
        echo "${lines[0]}" > "/tmp/zshrc.tmp"
        for line in "${lines[@]:1}"; do
            echo "$line" >> "/tmp/zshrc.tmp"
        done
        printf "\n" | cat - "$target" >> "/tmp/zshrc.tmp"
        mv /tmp/zshrc.tmp "$target"
        info "Added login script to top of $target"
    else
        printf "\n" >> "$target"
        for line in "${lines[@]}"; do
            echo "$line" >> "$target"
        done
        info "Added login script to bottom of $target"
    fi
}
echo "=> edit_login_profile"
# return
[ -f ~/.hushlogin ] || touch ~/.hushlogin

login_script=$(find "$WS_ROOT_UNIX/core/steps" -name "terminal_login.sh" -type f)
[ -f "$login_script" ] || return

# If there are multiple login profiles, add to all of them
add_to_profile ~/.zshrc
add_to_profile ~/.config/fish/config.fish
add_to_profile ~/.bashrc

