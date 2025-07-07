function HardCheckDependencies {
    Param (
        [Parameter(Mandatory=$true)]
        [string]
        $Step
    )
    # Check dependecies by checking the status of each step
    # that we depend on.

    $Dependencies = Get-Dependencies -Step $Step
    $Dependencies.foreach({
        $Dep = $_
        WriteDebug "Checking dependency $Dep"
        $AssertionResult = Assert-Step-Done -Step $Dep
        if (!$AssertionResult) { 
            WriteInfo "Hard check - $Step not attempted because $Dep is not done"
            WriteInfo "AssertionResult:[$AssertionResult]"
            exit 1
        }
        HardCheckDependencies -Step $Dep
    })
    return $true
}
