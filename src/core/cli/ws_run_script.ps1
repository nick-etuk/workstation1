param (
    [Parameter(Position=0)]
    [string]$script_file,
    [Parameter(Position=1, ValueFromRemainingArguments=$true)]
    [string[]]$step_args
)

$ErrorActionPreference = "Stop"

. $PSScriptRoot\..\init.ps1

write-output "ws_run_step_script.ps1 running $script_file with args: $step_args"
. $script_file -Arguments $step_args

