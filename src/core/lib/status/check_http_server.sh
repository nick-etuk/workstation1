#!/usr/bin/env bash

function check_http_server {

    local service
    local conditions
    local passed
    local calling_function
    local arg_count

    arg_count=$#
    if [ "$arg_count" -eq 0 ]; then
        service='backendworker'
    else
        service=$1
    fi

    calling_function=${FUNCNAME[1]}

    passed=1

    case "$service" in
        backendworker|backend_and_http|web)
            conditions=(
                'lsof -i -P -n | grep LISTEN | grep -q 3000'
                "curl -s http://web.local.bitraft.io:3000 | grep -iq 'class=\"nhsuk-logo\"'"
            )
            ;;
        mongodb)
            conditions=(
                "curl -s http://mongodb.bitraft.io:27017 | grep -iq 'MongoDB over HTTP'"
            )
            ;;
        wiremock)
            conditions=(
                "curl -s http://stubs.local.bitraft.io:8080/__admin/mappings | grep -iq '\"mappings\" : [ ]'"
            )
            ;;
        * )
            error "Unknown service $service"
            ;;
    esac

    for condition in "${conditions[@]}"; do
        debug "=>check_http_server condition: $condition"
        eval "$condition" >/dev/null
        passed=$?

        if [ $passed -ne 0 ]; then
            if [ "$calling_function" != "wait_for_service" ]; then
                debug "calling_function: $calling_function"
                warn "$service is down"
            fi
            return 1
        fi
    done

    debug "=>check_http_server $service passed: $passed"
    return $passed
}
