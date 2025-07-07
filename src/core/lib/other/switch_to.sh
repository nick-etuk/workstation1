#!/usr/bin/env bash

function check_repo_dir {
    error "Directory $1 does not exist"
    # info ""

    # read -rp "Repo path currently set to $REPO_DIR_UNIX. Is this correct?" option
    # if [ ! "$option" = 'n' ]; then
    #     error "Could not switch to directory $1"
    #     exit 1
    # fi

    # read -rp 'Please enter the correct repo path: ' REPO_DIR_UNIX
    # set_config repo_dir "$REPO_DIR_UNIX"
    # info 'Please re-run nshapp.sh to try again'
    # exit 1
}

function switch_to {
    [ "$1" = "$(pwd)" ] && return

    [ -d "$1" ] || check_repo_dir "$1"

    cd "$1" || error "Could not switch to $1"
}

function switch_back {
    switch_to "$WS_ROOT_UNIX"
}
