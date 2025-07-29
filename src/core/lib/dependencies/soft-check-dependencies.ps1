function SoftCheckDependencies {
    Param (
        [Parameter(Mandatory=$true)]
        [string]
        $Step
    )

    # Check dependecies based on statuses of steps.
    # The statuses are held in memory.

    $FinalResult = $true

    $global:Dependencies.ForEach({
        if ($_.step -eq $Step ) { 
            $DependsOn = $_.dependsOn
            # WriteDebug "$Step depends on $DependsOn"
            $PartialResult = $false
            foreach($item in $Steps) {
                if ($item.name -eq $DependsOn -and $item.status -eq "done" ) {
                    # WriteDebug "Status:done"
                    $PartialResult = $true
                    break
                }
            }
            if (!$PartialResult) {
                WriteInfo "Soft check: $Step not attempted because $DependsOn is not done"
                $FinalResult = $false
            }
        }
    })
    # WriteDebug "Ok to proceed: $FinalResult"
    return $FinalResult
}
