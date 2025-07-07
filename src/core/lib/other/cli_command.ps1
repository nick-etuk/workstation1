function ProcessCLIcommand {
    param (
        [parameter(Mandatory=$true)]$Command
    )

    if ("web bdd dotnet android ios".Contains($Command)) {
        RunActivity $Command
        return
    }

    $StepConfig = Get-Step-Config $Command
    if ($StepConfig) { 
        RunStep -Step $Command -Arguments @() 
        return
    }
}