function Invoke-Step-Entry {
    Param (
        [Parameter(Position=0)]
        $Step,
        [Parameter(Position=1)]
        $Arguments
    )

    if (!$Step) {
        $CallingFunction = [string]$(Get-PSCallStack)[1].FunctionName
        if ($Callingfunction -eq "<ScriptBlock>") {
            $CallingFunction = $CallingScript
        }
        $Step = $CallingFunction
    }
    
    if (!(CheckDependencies -Step $Step -Arguments $Arguments)) { return $false }

    $TestResults = Assert-Step-Done -Step $Step -Arguments $Arguments

    if ($TestResults.allPassed) {
        WriteInfo "$Step $Arguments step already done"
        return $false
    }

    # $StepConfig = Get-Step-Config -Step $Step
    # $IsElevated = $StepConfig.isElevated
    # if($IsElevated -eq $true -and !$(IamElevated)) {
    #     WriteInfo "Please run step $Step as an Administrator"
    #     return $false
    # }
    
    return $true
}
