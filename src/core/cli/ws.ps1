param (
    [Parameter(Position=0)]
    [string]$Command,
    [Parameter(Position=1, ValueFromRemainingArguments=$true)]
    [string[]]$Arguments
)

$ErrorActionPreference = "Stop"

. $PSScriptRoot\..\vm\dev_box\unschedule_first_login.ps1
. $PSScriptRoot\..\init.ps1

RunStep core_steps

writedebug "command: $Command"
foreach ($arg in $Arguments) {
    writedebug "arg: $arg"
}

if ($Command) { 
    ProcessCLIcommand -Command $Command -Arguments $Arguments
    exit 0
}

Show-Main-Menu
