function Get-Dependencies {
    Param (
        [Parameter(Mandatory=$true)]
        [string]
        $Step
    )

    # Check dependecies based on statuses of steps.
    # The statuses are held in memory.

    $Result = [System.Collections.ArrayList]@()
    $Result = @()
    $Result.Clear()

    $global:Dependencies.ForEach({
        if ($_.step -eq $Step ) { 
            $DependsOn = $_.dependsOn
            if ($DependsOn) { $Result += $DependsOn }
        }
    })
    return $Result
}
