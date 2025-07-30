function save_directories {
    # $profileContent = Get-Content -Path $profile.CurrentUserCurrentHost -ErrorAction SilentlyContinue
    # $profileContent = $profileContent -replace "`$global:WS_ROOT_WIN = '$OldRootPath'", "`$global:WS_ROOT_WIN = '$WS_ROOT_WIN'"
    # Set-Content -Path $profile.CurrentUserCurrentHost -Value $profileContent -ErrorAction SilentlyContinue
    Set-Config ws_root_win $WS_ROOT_WIN
    $Script:REPO_DIR = (get-item $WS_ROOT_WIN).parent.parent
    Set-Config repo_dir $REPO_DIR
}

function set_repo_dir {
    # Checks if WS_ROOT_WIN has changed. Update REPO_DIR and the profile if it has.

    $OldRootPath = Get-Config ws_root_win
    if (-not $OldRootPath) {
        save_directories
        return
    }
    
    if ($OldRootPath -ne $WS_ROOT_WIN) {
        WriteWarning "Workstation1 root path has changed from $OldRootPath to $WS_ROOT_WIN"
        WriteWarning "Updating $profile.CurrentUserCurrentHost"
        save_directories
    }
}