function RunForeignStep ($StepID) {
    writewarn "Running foreign step $StepID"
    if (!(IsDistroInstalled "ubuntu")) {
        WriteWarn "Installing WSL for foreign step $StepID"
        RunStep 'setup_wsl'
    }

    if (!(IsDistroInstalled "ubuntu")) {
        WriteWarn "Skipping foreign step $StepID as WSL has not yet been setup"
        return
    }
    
    Get-ScriptRootUnix
    if (!$WS_ROOT_UNIX) {
        WriteError "Cannot find workstation1 in WSL to run foreign step $StepID"
        return
    }
    $FullCommand = "export NEW_TAB='true'; $WS_ROOT_UNIX/core/cli/ws.sh $StepID"
    writedebug "Running P1 command in WSL: $FullCommand"
    wt.exe -w 0 nt --colorScheme "Campbell Powershell" --title "workstation1 WSL" -p "Ubuntu" bash -c "$FullCommand\; exec zsh 2>&1"
}
