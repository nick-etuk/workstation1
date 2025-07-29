function RunStep {
    param (
        $StepID,
        [string[]]$Arguments=@()
    )
    $ArgCount = $Arguments.Count
    $AllPassed = 0

    $StepConfig = Get-Step-Config $StepID

    if (!$StepConfig) {
        WriteInfo "Config not found for step $StepID in $WS_ROOT_WIN"
        return 1
    }

    if ($StepConfig | Get-Member -Name 'os') {
        $StepOS = $StepConfig.os
        if ("unix ubuntu macos".Contains($StepOS)) {
            WriteInfo "$StepID not for Windows"
            return 0
        }
    }

    if ($StepConfig | Get-Member -Name 'runOnce') {
        $RunOnce = $StepConfig.runOnce
        if ($RunOnce -eq 'true' ) {
            $Key="step_$StepID"

            if ($ArgCount -gt 0) {
                $FormattedArgs = $($Arguments -join "_")
                $Key="step_$StepID_$FormattedArgs"
            }

            $Status = Get-config status $Key

            if ($Status -eq 'done' ) {
                WriteInfo "$StepID step already done"
                return 0
            }
        }
    }

    $OkToProceed = Invoke-Step-Entry -Step $StepID -Arguments $Arguments
    if (!$OkToProceed) { return }
    
    WriteInfo "$StepID step started"

    if ($StepConfig | Get-Member -Name 'commands') {
        $StepCommands = $StepConfig.commands
        foreach($Command in $StepCommands) {
            Invoke-Expression $Command
        }
    }

    if ($StepConfig | Get-Member -Name 'steps') {
        $ChildSteps = $StepConfig.steps
        RunChildSteps -ChildSteps $ChildSteps -ParentArgs $Arguments
        if ($? -ne 0 ) { $AllPassed = 1 }
    }

    $StepDir = $(Get-Step-Directory -Step $StepID)
    if (!$StepDir) { return $AllPassed }

    $StepFileName = $StepID.ToLower() -replace '-', '_'
    if (Test-Path -PathType Leaf "$StepDir\$StepFileName.ps1") {
        . "$StepDir\$StepFileName.ps1" -Arguments $Arguments
    }

    # if (Test-Path -PathType Leaf "$StepDir\$StepFileName.sh") {
    #     get-ScriptRootUnix
    #     WriteWarn "Running foreign step $StepID $Arguments in WSL"
    #     wsl -u $WSL_USER -- "$WS_ROOT_UNIX/core/lib/run_step/run_step.sh" "$StepFileName" "$Arguments"
    #     $AllPassed = Invoke-Step-Exit -Step $StepID -Arguments $Arguments
    #     return
    # }

    Invoke-Step-Exit -Step $StepID -Arguments $Arguments
    if ($? -ne 0 ) { $AllPassed = 1 }

    if ($AllPassed -eq 0 ) {
        WriteInfo "$StepID step completed"
        if ($RunOnce -eq 'true' ) { Set-Config status $Key 'done' }
    }
    return $AllPassed
}
