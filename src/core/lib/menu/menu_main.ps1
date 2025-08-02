function Show-Main-Menu {
    $ProjectConfigFiles = Get-Childitem -Path "$WORKING_DIR\activity_sort" -Include '*ws1_project.json' -File -Recurse -ErrorAction SilentlyContinue
    if (-not $ProjectConfigFiles) {
        Write-Error "No ws1_project.json files found in $WORKING_DIR\activity_sort."
        return
    }

    $OptionNum = 0
    $ActivityIdList = [System.Collections.ArrayList]@()
    $ActivityIdList.Clear()
    WriteInfo "`nWelcome to workstation1`n`n"
    WriteInfo "To start an activity, enter the command 'ws' followed by an activity name,`n"
    WriteInfo "or just 'ws' to show this menu again.`n"


    foreach ($ProjectConfigFile in $ProjectConfigFiles) {
        $ProjectFilename = $ProjectConfigFile.BaseName
        $SplitString = $ProjectFilename.Split('-')
        $ProjectID = $SplitString[1]

        $Content = Get-Content $ProjectConfigFile -ErrorAction SilentlyContinue | Out-String
        $ProjectConfig = ConvertFrom-Json -InputObject $Content -ErrorAction SilentlyContinue
        if ($ProjectConfig | Get-Member -Name 'title') { 
            $ProjectTitle = $ProjectConfig.title
        } else {
            WriteWarning "No title found in $ProjectConfigFile"
            continue
        }
        $BorderLine = '-' * $ProjectTitle.Length

        WriteInfo "`n$BorderLine"
        WriteInfo $ProjectTitle
        WriteInfo $BorderLine

        $ActivityConfigFiles = Get-Childitem -Path "$WORKING_DIR\activity_sort" -Include '*-activity.json' -File -Recurse -ErrorAction SilentlyContinue
        if (-not $ActivityConfigFiles) {
            Write-Error "No activities found in $WORKING_DIR\activity_sort."
            return
        }

        foreach ($ActivityConfigFile in $ActivityConfigFiles) {
            $ActivityFilename = $ActivityConfigFile.BaseName
            $SplitString = $ActivityFilename.Split('-')
            $ActivityProject = $SplitString[1]
            if ($ActivityProject -ne $ProjectID) { continue }
            $ActivityID = $SplitString[3]
            $ActivityIdList.Add($ActivityID) | Out-Null

            $Content = Get-Content $ActivityConfigFile -ErrorAction SilentlyContinue | Out-String
            $ActivityConfig = ConvertFrom-Json -InputObject $Content -ErrorAction SilentlyContinue
            if ($ActivityConfig | Get-Member -Name 'title') { 
                $ActivityTitle = $ActivityConfig.title
            } else {
                WriteWarning "No title found in $ActivityConfigFile"
                continue
            }
            $OptionNum++
            WriteInfo "$ActivityID`t $ActivityTitle"

            Set-Config 'activity_id' $OptionNum "$ActivityProject.$ActivityID"
            Set-Config 'activity_id_list' "$($ActivityIdList -join ' ')"
            Set-Config 'activity_id_project' $ActivityID $ActivityProject
        }
    }
    # WriteInfo "`nTo show this menu again, enter the command 'ws'."
    $StartupScript = Get-Childitem -Path "$WS_ROOT_WIN\core" -Include 'ws.ps1' -File -Recurse -ErrorAction SilentlyContinue
    if (-not $StartupScript) {
        WriteError "Startup script ws.ps1 not found in $WS_ROOT_WIN\core."
        return
    }
    WriteInfo "The script ws.ps1 is located at $(Split-Path -Path $StartupScript.FullName -Parent)"
}