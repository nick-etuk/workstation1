function run_wsl_step ($StepID) {
    writewarn "Running WSL step $StepID"
    if (!(IsDistroInstalled "ubuntu")) {
        WriteWarn "Installing WSL for the first time, this may take a while..."
        RunStep 'setup_wsl'
    }

    if (!(IsDistroInstalled "ubuntu")) {
        WriteWarn "Skipping WSL step $StepID as WSL has not yet been setup"
        return
    }
    
    Get-ScriptRootUnix
    if (!$WS_ROOT_UNIX) {
        WriteError "Cannot find workstation1 directory in WSL to run WSL step $StepID"
        return
    }
    $FullCommand = "export NEW_TAB='true'; $WS_ROOT_UNIX/core/cli/ws1.sh $StepID"
    writedebug "Running ws command in WSL: $FullCommand"
    wt.exe -w 0 nt --colorScheme "Campbell Powershell" --title "workstation1 WSL" -p "Ubuntu" bash -c "$FullCommand\; exec zsh 2>&1"
}
