function run_wsl_activity ($ActivityID) {
    writewarn "Running WSL activity $ActivityID"
    if (!(IsDistroInstalled "ubuntu")) {
        WriteWarn "Installing WSL for the first time, this may take a while..."
        RunStep 'setup_wsl'
    }

    if (!(IsDistroInstalled "ubuntu")) {
        WriteWarn "Skipping activity $ActivityID as WSL has not yet been setup"
        return
    }
    
    Get-ScriptRootUnix
    if (!$WS_ROOT_UNIX) {
        WriteError "Cannot find workstation1 directory in WSL to run activity $ActivityID"
        return
    }
    $FullCommand = "export NEW_TAB='true'; $WS_ROOT_UNIX/core/cli/ws.sh $Command"
    writedebug "Running ws command in WSL: $FullCommand"
    wt.exe -w 0 nt --colorScheme "Campbell Powershell" --title "workstation1 WSL" -p "Ubuntu" bash -c "$FullCommand"
}
