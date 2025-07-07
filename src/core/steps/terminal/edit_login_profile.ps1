function edit_login_profile {
    writedebug "=> edit_login_profile"
    if (!(Test-Path -PathType Leaf $profile.CurrentUserCurrentHost)) {
        Write-Output "Creating `$profile.CurrentUserCurrentHost at $($profile.CurrentUserCurrentHost)"
        New-Item -Path $profile.CurrentUserCurrentHost -ItemType File | Out-Null
    }

    $StartBanner = '# workstation1_v1 start'
    $Line1 = "`$global:WS_ROOT_WIN = '$WS_ROOT_WIN'"
    $Line2 = "`$env:PATH += ;`$WS_ROOT_WIN\core\cli"
    $Line3 = "`$WorkstationStartup = Get-Childitem -Path `$WS_ROOT_WIN\core -Include 'p1.ps1' -File -Recurse -ErrorAction SilentlyContinue"
    $Line4 = "& `$(`$WorkstationStartup.FullName)"
    $EndBanner = '# workstation1_v1 end'
    $AdditionalContent = "$StartBanner`n$Line1`n$Line2`n$Line3`n$Line4`n$EndBanner`n"
    WriteDebug "Modifying profile $($profile.CurrentUserCurrentHost)"
    # WriteDebug $AdditionalContent
    Add-Content -Path $profile.CurrentUserCurrentHost -Value $AdditionalContent
    Get-Content -Path $profile.CurrentUserCurrentHost
    $env:PATH += ";$WS_ROOT_WIN\core\cli"
}
# Set-PSDebug -Trace 1
edit_login_profile
# Set-PSDebug -Trace 0
