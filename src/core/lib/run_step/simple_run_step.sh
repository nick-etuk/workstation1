#!/usr/bin/env bash

simple_run_step() {
    step_script=$1
    shift
    step_args=("$@")
    debug "=>simple_run_step $step_script >${step_args[*]+"${step_args[*]}"}<"
    source "$step_script" "${step_args[@]}"
}
