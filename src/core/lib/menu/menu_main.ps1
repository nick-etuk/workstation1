function Show-Main-Menu {
    SortActivities
    $PackageConfigFiles = Get-Childitem -Path "$WORKING_DIR\activity_sort" -Include '*ws1.config.json' -File -Recurse -ErrorAction SilentlyContinue
    if (-not $PackageConfigFiles) {
        Write-Error "No ws1.config.json files found in $WORKING_DIR\activity_sort."
        return
    }

    $OptionNum = 0
    $ActivityIdList = [System.Collections.ArrayList]@()
    $ActivityIdList.Clear()
    WriteInfo "`nworkstation1`n"

    foreach ($PackageConfigFile in $PackageConfigFiles) {
        $PackageFilename = $PackageConfigFile.BaseName
        $SplitString = $PackageFilename.Split('-')
        $PackageID = $SplitString[1]

        $Content = Get-Content $PackageConfigFile -ErrorAction SilentlyContinue | Out-String
        $PackageConfig = ConvertFrom-Json -InputObject $Content -ErrorAction SilentlyContinue
        if ($PackageConfig | Get-Member -Name 'title') { 
            $PackageTitle = $PackageConfig.title
        } else {
            WriteWarning "No title found in $PackageConfigFile"
            continue
        }
        $BorderLine = '-' * $PackageTitle.Length

        WriteInfo "`n$BorderLine"
        WriteInfo $PackageTitle
        WriteInfo $BorderLine

        $ActivityConfigFiles = Get-Childitem -Path "$WORKING_DIR\activity_sort" -Include '*-activity.json' -File -Recurse -ErrorAction SilentlyContinue
        if (-not $ActivityConfigFiles) {
            Write-Error "No activities found in $WORKING_DIR\activity_sort."
            return
        }

        foreach ($ActivityConfigFile in $ActivityConfigFiles) {
            $ActivityFilename = $ActivityConfigFile.BaseName
            $SplitString = $ActivityFilename.Split('-')
            $ActivityPackage = $SplitString[1]
            if ($ActivityPackage -ne $PackageID) { continue }
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
            WriteInfo "$OptionNum`t $ActivityTitle"

            # Set-Config 'activity_repo_path' "$ActivityPackage.$ActivityID" "$repo_path"
            Set-Config 'activity_id' $OptionNum "$ActivityPackage.$ActivityID"
            Set-Config 'activity_id_list' "$($ActivityIdList -join ' ')"
            Set-Config 'activity_id_package' $ActivityID $ActivityPackage
        }
    }
    WriteInfo "To show this menu again, enter the command 'p1'."
}