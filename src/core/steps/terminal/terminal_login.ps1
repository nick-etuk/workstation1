Set-StrictMode -Version 3.0

if ($env:TERM_PROGRAM -and $env:TERM_PROGRAM -ne 'Windows Terminal') {
    exit 0
}

$StartupScript = Get-Childitem -Path "$WS_ROOT_WIN" -Include 'ws1.ps1' -File -Recurse -ErrorAction SilentlyContinue
# . $($StartupScript.FullName)
# $($StartupScript.Fullname)
# if (!$($StartupScript.FullName)) {
#     WriteWarn "Workstation startup script 'ws1.ps1' not found in $WS_ROOT_WIN"
#     exit 0
# }
& $StartupScript
# & $($StartupScript.FullName)
