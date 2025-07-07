param (
    [Parameter(Position=0)]
    $Command,
    [switch]$NoInit = $false
)

$ErrorActionPreference = "Stop"

. $PSScriptRoot\..\vm\dev_box\unschedule_first_login.ps1
. $PSScriptRoot\..\init.ps1

RunStep setup_terminal

if ($Command) { 
    ProcessCLIcommand $Command
    exit 0
}

Show-Main-Menu
