function SortActivities {
    Remove-Item "$WORKING_DIR/activity_sort/*" -Force
    $RegistryFile = "$WORKING_DIR/app_directories.txt"
    if (!(Test-Path -Path $RegistryFile)) {
        WriteError "Registry file not found: $RegistryFile"
        return
    }

    $RegistryContent = Get-Content -Path $RegistryFile -ErrorAction SilentlyContinue
    if (!$RegistryContent) {
        WriteError "Registry file is empty or could not be read: $RegistryFile"
        return
    }
    $AppConfigFiles = @()
    foreach ($AppDirectory in $RegistryContent) {
        $AppDirectory = $AppDirectory.Trim()
        if (!(Test-Path -Path $AppDirectory)) {
            WriteError "App directory not found: $AppDirectory"
            continue
        }
        $ConfigFiles = Get-Childitem -Path "$AppDirectory" -Include 'ws1.config.json' -File -Recurse -ErrorAction SilentlyContinue
        $AppConfigFiles += $ConfigFiles
    }

    # $PackageConfigFiles = Get-Childitem -Path "$WS_ROOT_WIN" -Include 'ws1.config.json' -File -Recurse -ErrorAction SilentlyContinue
    writedebug "AppConfigFiles: $($AppConfigFiles.Count) files found"
    foreach ($PackageConfigFile in $AppConfigFiles) {
        writedebug "package config file: $PackageConfigFile"
        $content = Get-Content $PackageConfigFile -ErrorAction SilentlyContinue | Out-String
        $PackageConfig = ConvertFrom-Json -InputObject $content -ErrorAction SilentlyContinue
        $PackageID = $PackageConfig.id
        if ($PackageConfig | Get-Member -Name 'sortOrder') {
            $PackageSortOrder = $PackageConfig.sortOrder
        } else { 
            $PackageSortOrder = 999
        }
        Copy-Item "$PackageConfigFile" "$WORKING_DIR/activity_sort/$PackageSortOrder-$PackageID-ws1.config.json"

        $PackageDir = Split-Path -Path $PackageConfigFile -Parent
        $ActivityFiles = Get-Childitem -Path $PackageDir -Include '*activity*.json' -File -Recurse -ErrorAction SilentlyContinue

        foreach ($ActivityFile in $ActivityFiles) {
            $content = Get-Content $ActivityFile -ErrorAction SilentlyContinue | Out-String
            $ActivityConfig = ConvertFrom-Json -InputObject $content -ErrorAction SilentlyContinue
            $ActivityID = $ActivityConfig.id
            if ($ActivityConfig | Get-Member -Name 'sortOrder') {
                $ActivitySortOrder = $ActivityConfig.sortOrder
            } else { 
                $ActivitySortOrder = 999
            }
            Copy-Item "$ActivityFile" "$WORKING_DIR/activity_sort/$PackageSortOrder-$PackageID-$ActivitySortOrder-$ActivityID-activity.json"
        }

    }
}