#!/usr/bin/env bash

function info {
    # todo: get stage (filename of calling script) automatically
    # PARENT_COMMAND=$(ps -o args= $PPID)
    # PARENT_COMMAND=$(ps $PPID | tail -n 1 | awk "{print \$5}")
    # echo "PPID, PARENT_COMMAND:$PPID, $PARENT_COMMAND"
    # STAGE=$PARENT_COMMAND

    # LOG_FILE="/mnt/c/provisioning/log/$STAGE-$(date +%Y-%m-%d).log"
    # echo "[$(date +'%Y-%m-%d %H:%M:%S')]:[$STAGE] $*" | tee -a $LOG_FILE
    local message
    local modified_message

    message="$*"
    modified_message=$(echo -e "${message/step completed/$TICK_MARK}")
    modified_message=$(echo -e "${modified_message/stage completed/$TICK_MARK}")
    modified_message=$(echo -e "${modified_message/step already done/$TICK_MARK}")
    modified_message=$(echo -e "${modified_message/step failed/$CROSS_MARK}")

    # echo "[$(date +'%Y-%m-%d %H:%M:%S')] $modified_message"
    echo "$modified_message"
}

function error {
    echo -e "${RED}Error in ${FUNCNAME[1]}:$*${NC}"
    echo "$*" >> "$LOG_DIR/$CURRENT_STEP.log"
    exit 1
}

function warn {
    echo -e "${YELLOW}$*${NC}"
    echo "$*" >> "$LOG_DIR/$CURRENT_STEP.log"

}

function debug {
    if [ "$DEBUG" -eq 1 ]; then
        echo -e "${YELLOW}$*${NC}"
        echo "$*" >> "$LOG_DIR/debug_$CURRENT_STEP.log"
        echo "$*" >> "$LOG_DIR/debug_all_steps.log"
    fi
}
