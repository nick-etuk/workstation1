function RunForeignActivity ($ActivityID) {
    writewarn "Running foreign activity $ActivityID"
    if (!(IsDistroInstalled "ubuntu")) {
        WriteWarn "Installing WSL for foreign activity $ActivityID"
        RunStep 'setup_wsl'
    }

    if (!(IsDistroInstalled "ubuntu")) {
        WriteWarn "Skipping foreign activity $ActivityID as WSL has not yet been setup"
        return
    }
    
    Get-ScriptRootUnix
    if (!$WS_ROOT_UNIX) {
        WriteError "Cannot find workstation1 in WSL to run foreign activity $ActivityID"
        return
    }
    $FullCommand = "export NEW_TAB='true'; $WS_ROOT_UNIX/core/cli/ws.sh $Command"
    writedebug "Running P1 command in WSL: $FullCommand"
    wt.exe -w 0 nt --colorScheme "Campbell Powershell" --title "workstation1 WSL" -p "Ubuntu" bash -c "$FullCommand\; exec zsh 2>&1"
}

function RunActivity ($ActivityID) {
    RunForeignActivity -ActivityID $ActivityID
}
