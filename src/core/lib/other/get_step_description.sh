#!/usr/bin/env bash

get_step_description() {
    local step=$1
    local descr
    local space=' '

    # descr="${step//"install_"}"
    # descr="${descr//"setup_"}"
    # descr="${descr//"start_"}"
    descr="${step//"_"/$space}"

    descr="$(tr '[:lower:]' '[:upper:]' <<< "${descr:0:1}")${descr:1}" # capitalize first letter
    echo "$descr"
}
