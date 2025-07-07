function Show-Help {
    Param (
        [string]$Step
    )

    $HelpFile = "$WS_ROOT_WIN\doc\troubleshooting\$Step.txt"
    if (Test-Path -PathType Leaf $HelpFile) {
        $HelpText = Get-Content -Path $HelpFile -Raw
        WriteInfo $HelpText
    }
}