#!/usr/bin/env bash

WSL_USER=$(cat /var/tmp/wsl-users.txt)
if [ -z "$WSL_USER" ]; then
    echo "No WSL user file. Using WSL default user."
    WSL_USER=$(getent passwd 1000 | cut -d: -f1)
fi
info "Adding user $WSL_USER to sudoers"

echo "$WSL_USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/90-sudo-nopasswd
