function edit_login_profile {
    writedebug "=> edit_login_profile"
    if (!(Test-Path -PathType Leaf $profile.CurrentUserCurrentHost)) {
        Write-Output "Creating `$profile.CurrentUserCurrentHost at $($profile.CurrentUserCurrentHost)"
        New-Item -Path $profile.CurrentUserCurrentHost -ItemType File | Out-Null
    }

    $StartBanner = "# workstation1_v$WS_VERSION start"
    $Line1 = "`$global:WS_ROOT_WIN = '$WS_ROOT_WIN'"
    $Line2 = "`$env:PATH += ';$WS_ROOT_WIN\core\cli'"
    $Line3 = "if (`$env:TERM_PROGRAM -and `$env:TERM_PROGRAM -ne 'Windows Terminal') { exit 0 }"
    $Line4 = "`$WorkstationStartup = Get-Childitem -Path `$WS_ROOT_WIN\core -Include 'ws.ps1' -File -Recurse -ErrorAction SilentlyContinue"
    $Line5 = "& `$(`$WorkstationStartup.FullName)"
    $EndBanner = "# workstation1_v$WS_VERSION end"
    $AdditionalContent = "$StartBanner`n$Line1`n$Line2`n$Line3`n$Line4`n$Line5`n$EndBanner`n"
    WriteDebug "Modifying profile $($profile.CurrentUserCurrentHost)"
    # WriteDebug $AdditionalContent
    Add-Content -Path $profile.CurrentUserCurrentHost -Value $AdditionalContent
    Get-Content -Path $profile.CurrentUserCurrentHost
    $env:PATH += ";$WS_ROOT_WIN\core\cli"
}
# Set-PSDebug -Trace 1
edit_login_profile
# Set-PSDebug -Trace 0
