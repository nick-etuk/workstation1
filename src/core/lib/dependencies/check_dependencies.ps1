function CheckDependencies {
    Param (
        [Parameter(Mandatory=$true)]
        $Step,
        $Arguments
    )

    $StepConfig = Get-Step-Config -Step $Step
    if (!($StepConfig | Get-Member -Name 'dependencies')) { return $true }

    $StepDependencies = $StepConfig.dependencies
    
    foreach($Dep in $StepDependencies) {
        # if ($global:DoneDepenencies -contains $Dep) {
        #     continue
        # }
        WriteInfo "Checking $Step dependency $Dep"
        $AssertionResult = Assert-Step-Done -Step $Dep -Arguments $Arguments
        if (!($AssertionResult.allPassed)) { 
            WriteInfo "$Step not attempted because $Dep is not done"
            WriteInfo "Check result: $AssertionResult"
            return $false
        }
        # $global:DoneDepenencies += $Dep
        CheckDependencies -Step $Dep -Arguments $Arguments
    }
    return $true
}
