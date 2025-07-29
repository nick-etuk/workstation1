#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091,SC2034

libraries=$(find "$WS_ROOT_UNIX/core/lib" -name 'detect_os.sh' -o -name 'get_shell_version.sh')
for lib in $libraries; do
    source "$lib"
done

show_config() {
    echo "SHELL: $SHELL_NAME version: $SHELL_VERSION"
    echo "CURRENT_USER: $WSL_USER"
    echo "WINDOWS_USER: $WINDOWS_USER"
    echo "WORKING_DIR_WIN: $WORKING_DIR_WIN"
    echo "MY_OS: $MY_OS"
    echo "WS_ROOT_UNIX: $WS_ROOT_UNIX"
    echo "BASE_DIR: $BASE_DIR"
    echo "WORKING_DIR: $WORKING_DIR"
    echo "WORKING_DIR_WIN: $WORKING_DIR_WIN"
    echo "LOG_DIR: $LOG_DIR"
    echo "REPO_DIR: $REPO_DIR"
    echo "DEBUG: $DEBUG"
    echo "FORCE: $FORCE"
}

get_shell_version

WSL_USER=''
WINDOWS_USER=''
WINDOWS_HOME=''
WORKING_DIR_WIN=''
VM=''

if [ -f /var/tmp/wsl-users.txt ]; then
    WSL_USER=$(cat /var/tmp/wsl-users.txt)
else
    WSL_USER=$(whoami)
    echo "$WSL_USER" > /var/tmp/wsl-users.txt
fi

BASE_DIR="$HOME/.workstation1"
WORKING_DIR="$BASE_DIR/working"
LOG_BASE="$BASE_DIR/log"
MY_DOWNLOAD_DIR="$BASE_DIR/downloads"

ANDROID_EMULATOR_PORT=5554

LOGINENV=sandpit
NODE_MAJOR_VERSION=22
DOTNET_MAJOR_VERSION=8

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BOLD='\033[1m'
NC='\033[0m' # No Color
if [ "$(locale charmap)" = 'UTF-8' ]; then
#   TICK_MARK='\0342\0234\0224'
    TICK_MARK='\U2714'
    CROSS_MARK='\U274C'
else
  TICK_MARK='[X]'
  CROSS_MARK='[-]'
fi

NEW_TAB_FLAG="$WORKING_DIR"/new_tab_flag.txt

detect_os

if [ "$VM" = 'wsl' ]; then
    if [ -s "$WORKING_DIR/wsl_usernames.sh" ]; then
        source "$WORKING_DIR/wsl_usernames.sh"
    else
        echo "No wsl_usernames.sh found, using CMD.exe to capture WINDOWS_USER"
        WINDOWS_USER=$(cmd.exe /c "echo %USERNAME%" | tr -d '\r')
        WINDOWS_HOME=$(cmd.exe /c "echo %USERPROFILE%" | tr -d '\r')
        WORKING_DIR_WIN=$(wslpath "$WINDOWS_HOME\\.workstation1\\working")
    fi
fi

case $MY_OS in
ubuntu)
    source "$WS_ROOT_UNIX"/core/lib/conf/config_ubuntu.sh
    ;;
macos)
    source "$WS_ROOT_UNIX"/core/lib/conf/config_macos.sh
    ;;
*)
    echo "config_base: unsupported OS $MY_OS"
esac
