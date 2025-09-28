#!/usr/bin/env bash

WS_USER_UNIX=$(cat /var/tmp/wsl-users.txt)
if [ -z "$WS_USER_UNIX" ]; then
    echo "No WSL user file. Using WSL default user."
    WS_USER_UNIX=$(getent passwd 1000 | cut -d: -f1)
fi
info "Adding user $WS_USER_UNIX to sudoers"

echo "$WS_USER_UNIX ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/90-sudo-nopasswd
