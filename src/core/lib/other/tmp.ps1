function z2ShowMainMenu {
    $ToolsetFiles = Get-Childitem -Path "$WS_ROOT_WIN\toolsets" -Include "*.json" -File -Recurse -ErrorAction SilentlyContinue
    if (!$ToolsetFiles) { 
        WriteWarning "No toolset definition files found in $WS_ROOT_WIN"
        return
    }

    $toolsets = @()
    $toolsets.Clear()

    foreach ($ToolsetFile in $ToolsetFiles) {
        $Toolset = Get-Content $ToolsetFile | ConvertFrom-Json
        $toolsets += $Toolset
    }

    if (!$toolsets) {
        WriteError "No toolsets defined"
    }
    #todo: sort toolsets by seq
    $OptionNum = 0
    
    foreach ($Toolset in $toolsets) {
        $OptionNum += 1
        # $Toolset.optionNum = $OptionNum
        Add-Member -InputObject $Toolset -MemberType NoteProperty -Name "OptionNum" -Value $OptionNum
        Write-Host "`t$OptionNum $($Toolset.title)"
    }

    Write-Host "`tA Advanced"
    Write-Host "`tU Uninstall"
    Write-Host "`tH Help"
    Write-Host "`tQ Quit"

    $Choice = Read-Host "[Q]"

    switch ($Choice)
    {
        q {
            QuitMenu
        }
        { "123456789" -match $_ } {
            if ($_) { 
                foreach($Toolset in $toolsets) {
                    if($($Toolset.optionNum) -eq $Choice) {
                        StartToolset $Toolset
                        break
                    }
                }
            }
        }
        h {
            Start-Process $WS_ROOT_WIN\doc\troubleshooting.rtf
        }
        default {
            QuitMenu
        }
    }

    ContinueOrQuit
    
    # Clear-Host
    Show-Main-Menu
}
