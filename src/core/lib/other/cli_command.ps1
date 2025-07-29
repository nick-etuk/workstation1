function ProcessCLIcommand([string]$Command, [string[]]$Arguments) {
    $Command = $Command.ToLower()
    # if (Test-Path variable:Arguments) { 
    # if ($Arguments | Get-Member -Name 'Count') {
    # $PSBoundParameters.ContainsKey('applicationToBuild')
    if ($Arguments -and $Arguments.Count -gt 0) {
        $ArgCount = $Arguments.Count
    } else {
        $ArgCount = 0
    }

    switch ($Command) {
        get {
            if ($ArgCount -lt 1) {
                WriteError "Usage: get <key>"
            }
            WriteInfo "$($Arguments -join ' ') is set to $(get-config $Arguments)"
            exit 0
        }
        set {
            if ($ArgCount -lt 2) {
                WriteError "Usage: set <key> <value>"
            }
            set-config $Arguments
            $ArgStr = $Arguments[0..$ArgCount] -join ' '
            WriteInfo "Set $ArgStr"
            exit 0
        }
        list {
            list_steps
            exit 0
        }
    }

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