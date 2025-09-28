function Add-WSL-Users {

    Write-Output "[boot]`nsystemd=true`n[user]`ndefault=$WS_USER_UNIX`n" > $WORKING_DIR\wsl.conf
    $UnixPath = Get-Unix-Path "$WORKING_DIR\wsl.conf"
    writedebug "Config file from Unix: $UnixPath"
    wsl -u root cp $UnixPath /etc

    wsl -u root groupadd $WS_USER_UNIX
    wsl -u root groupadd docker
    wsl -u root useradd -m -g $WS_USER_UNIX -s /bin/bash -G docker,sudo $WS_USER_UNIX

    $Cmd = "`$(echo $WS_USER_UNIX | openssl passwd -6 -stdin)"
    wsl -u root usermod --password $Cmd $WS_USER_UNIX

    wsl -u $WS_USER_UNIX touch ~/.hushlogin

    # Save user names to a file. Read by config_base.sh.
    Write-Output "WS_USER_UNIX='$WS_USER_UNIX'" > $WORKING_DIR\WS_USER_UNIXnames.sh
    Write-Output "WS_USER_WIN='$WS_USER_WIN'" >> $WORKING_DIR\WS_USER_UNIXnames.sh
    Write-Output "WORKING_DIR_WIN='$(Get-Unix-Path $WORKING_DIR)'" >> $WORKING_DIR\WS_USER_UNIXnames.sh

    $UnixPath = Get-Unix-Path "$WORKING_DIR\WS_USER_UNIXnames.sh"
    wsl -u $WS_USER_UNIX cp $UnixPath ~/.workstation1/working

}
Add-WSL-Users