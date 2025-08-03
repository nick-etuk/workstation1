#!/usr/bin/env bash

wait_for_parallel_step() {
    local step
    local args
    local config_file
    local is_parallel
    local timeout_param

    args=( "$@" )

    TIMEOUT=600
    TIMEOUT_MINUTES=$((TIMEOUT / 60))
    WAIT_FOR_STEP_STATUS=0

    step=$1
    config_file=$(get_step_path "$step")
    [ -f "$config_file" ] || return

    is_parallel=$(jq -r '.parallel' "$config_file")
    [ "$is_parallel" = 'true' ] || return


    timeout_param=$(jq -r '.timeout' "$config_file")
    if [ "$timeout_param" != 'null' ]; then
        TIMEOUT=$timeout_param
        TIMEOUT_MINUTES=$((TIMEOUT / 60))
    fi


    info "Waiting $TIMEOUT_MINUTES minutes for parallel step $step ${args[*]+"${args[*]}"}"
    debug "args:"
    for arg in ${args[@]+"${args[@]}"}; do debug "arg: $arg"; done

    # case $step in
    #     build_backend)
    #         WAITED=0 wait_for_service images "$2" 1200
    #         ;;
    #     start_http_server)
    #         WAITED=0 wait_for_service http_server web "$TIMEOUT"
    #         ;;
    #     *)
    #         warn "Unknown parallel step $step"
    #         return 1
    #         ;;
    # esac
    WAITED=0 wait_for_step ${args[@]+"${args[@]}"}
    debug "WAIT_FOR_STEP_STATUS: $WAIT_FOR_STEP_STATUS"

    if [ "$WAIT_FOR_STEP_STATUS" -ne 0 ]; then
        warn "${args[*]} not completed after $TIMEOUT_MINUTES minutes. Please do it manually."
        case "$step" in
            start_service)
                info "Missing docker containers:"
                for item in ${MISSING_CONTAINERS[@]+"${MISSING_CONTAINERS[@]}"}; do info "  $item"; done
                ;;
            build_backend)
                info "Missing docker images:"
                for item in ${MISSING_IMAGES[@]+"${MISSING_IMAGES[@]}"}; do info "  $item"; done
                ;;
            *)
                ;;
        esac
    fi
}
