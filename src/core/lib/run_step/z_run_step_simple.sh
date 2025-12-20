#!/usr/bin/env bash

z_run_step_simple() {
    step_script=$1
    shift
    step_args=("$@")
    debug "=>run_step_simple $step_script >${step_args[*]+"${step_args[*]}"}<"
    source "$step_script" "${step_args[@]}"
}
