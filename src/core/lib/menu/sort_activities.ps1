function SortActivities {
    Remove-Item "$WORKING_DIR/activity_sort/*" -Force
    $ProjectRegistry = "$WORKING_DIR/project_registry.csv"
    if (!(Test-Path -Path $ProjectRegistry)) {
        WriteError "Project registry not found at $ProjectRegistry"
        return
    }

    # $RegistryContent = Get-Content -Path $RegistryFile -ErrorAction SilentlyContinue
    $RegistryContent = Import-CSV $ProjectRegistry
    if (!$RegistryContent) {
        WriteError "Project registry is empty or could not be read: $RegistryFile"
        return
    }
    $ProjectConfigFiles = @()
    foreach ($Line in $RegistryContent) {
        writedebug "Registry line: $Line"
        $ProjectID = $Line.ProjectID
        $ProjectDirectory = $Line.Path
        writedebug "ID: <$ProjectID> path: <$ProjectDirectory>"
        if (!$ProjectID -or !$ProjectDirectory) {
            WriteWarning "Invalid registry line: $Line"
            continue
        }
        # $ProjectDirectory = $ProjectDirectory.Trim()
        if (!(Test-Path -Path $ProjectDirectory)) {
            WriteWarning "Project directory not found: $ProjectDirectory"
            continue
        }
        $ConfigFiles = Get-Childitem -Path "$ProjectDirectory" -Include 'ws1_project.json' -File -Recurse -ErrorAction SilentlyContinue
        $ProjectConfigFiles += $ConfigFiles
    }

    # $PackageConfigFiles = Get-Childitem -Path "$WS_ROOT_WIN" -Include 'ws1.config.json' -File -Recurse -ErrorAction SilentlyContinue
    writedebug "ProjectConfigFiles: $($ProjectConfigFiles.Count) files found"
    foreach ($ProjectConfigFile in $ProjectConfigFiles) {
        writedebug "package config file: $ProjectConfigFile"
        $content = Get-Content $ProjectConfigFile -ErrorAction SilentlyContinue | Out-String
        $ProjectConfig = ConvertFrom-Json -InputObject $content -ErrorAction SilentlyContinue
        $ProjectID = $ProjectConfig.id
        if ($ProjectConfig | Get-Member -Name 'sortOrder') {
            $ProjectSortOrder = $ProjectConfig.sortOrder
        } else { 
            $ProjectSortOrder = 999
        }
        Copy-Item "$ProjectConfigFile" "$WORKING_DIR/activity_sort/$ProjectSortOrder-$ProjectID-ws1.config.json"

        $ProjectDir = Split-Path -Path $ProjectConfigFile -Parent
        $ActivityFiles = Get-Childitem -Path $ProjectDir -Include '*activity*.json' -File -Recurse -ErrorAction SilentlyContinue

        foreach ($ActivityFile in $ActivityFiles) {
            $content = Get-Content $ActivityFile -ErrorAction SilentlyContinue | Out-String
            $ActivityConfig = ConvertFrom-Json -InputObject $content -ErrorAction SilentlyContinue
            $ActivityID = $ActivityConfig.id
            if ($ActivityConfig | Get-Member -Name 'sortOrder') {
                $ActivitySortOrder = $ActivityConfig.sortOrder
            } else { 
                $ActivitySortOrder = 999
            }
            Copy-Item "$ActivityFile" "$WORKING_DIR/activity_sort/$ProjectSortOrder-$ProjectID-$ActivitySortOrder-$ActivityID-activity.json"
        }

    }
}