function Add-WSL-Users {

    Write-Output "[boot]`nsystemd=true`n[user]`ndefault=$WSL_USER`n" > $WORKING_DIR\wsl.conf
    $UnixPath = Get-Unix-Path "$WORKING_DIR\wsl.conf"
    writedebug "Config file from Unix: $UnixPath"
    wsl -u root cp $UnixPath /etc

    wsl -u root groupadd $WSL_USER
    wsl -u root groupadd docker
    wsl -u root useradd -m -g $WSL_USER -s /bin/bash -G docker,sudo $WSL_USER

    $Cmd = "`$(echo $WSL_USER | openssl passwd -6 -stdin)"
    wsl -u root usermod --password $Cmd $WSL_USER

    wsl -u $WSL_USER touch ~/.hushlogin

    # Save user names to a file. Read by config_base.sh.
    Write-Output "WSL_USER='$WSL_USER'" > $WORKING_DIR\wsl_usernames.sh
    Write-Output "WINDOWS_USER='$WINDOWS_USER'" >> $WORKING_DIR\wsl_usernames.sh
    Write-Output "WORKING_DIR_WIN='$(Get-Unix-Path $WORKING_DIR)'" >> $WORKING_DIR\wsl_usernames.sh

    $UnixPath = Get-Unix-Path "$WORKING_DIR\wsl_usernames.sh"
    wsl -u $WSL_USER cp $UnixPath ~/.workstation1/working

}
Add-WSL-Users