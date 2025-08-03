function update_activity_registry {
    # Remove-Item "$WORKING_DIR/activity_sort/*" -Force
    $ActivityRegistry = "$WORKING_DIR/activity_registry.csv"
    if (!(Test-Path -Path $ActivityRegistry)) {
        New-Item -Path $ActivityRegistry -ItemType File -Force | Out-Null
        Add-Content -Path $ActivityRegistry -Value 'activity_id,project_id,display_order,option_num,path,title'
    }

    $ProjectRegistry = "$WORKING_DIR/project_registry.csv"
    if (!(Test-Path -Path $ProjectRegistry)) {
        WriteError "Project registry not found at $ProjectRegistry"
        return
    }

    $RegistryContent = Import-CSV $ProjectRegistry
    if (!$RegistryContent) {
        WriteError "Project registry is empty or could not be read: $RegistryFile"
        return
    }
    $OptionNum = 0
    foreach ($Line in $RegistryContent) {
        $ProjectID = $Line.project_id
        $SortOrder = $Line.sort_order
        $DisplayOrder = $Line.display_order
        $ProjectPath = $Line.path
        if (!$ProjectID -or !$ProjectPath) {
            WriteWarning "Invalid registry line: $Line"
            continue
        }
        if (!(Test-Path -Path $ProjectPath)) {
            WriteWarning "Project directory not found: $ProjectPath"
            continue
        }

        # Copy-Item "$ProjectConfigFile" "$WORKING_DIR/activity_sort/$ProjectSortOrder-$ProjectID-ws1_project.json"

        $ActivityFiles = Get-Childitem -Path $ProjectPath -Include '*activity*.json' -File -Recurse -ErrorAction SilentlyContinue

        foreach ($ActivityFile in $ActivityFiles) {
            $OptionNum++
            $Content = Get-Content $ActivityFile -ErrorAction SilentlyContinue | Out-String
            $ActivityConfig = ConvertFrom-Json -InputObject $Content -ErrorAction SilentlyContinue
            $ActivityID = $ActivityConfig.id
            $ActivityTitle = $ActivityConfig.title
            if ($ActivityConfig | Get-Member -Name 'sortOrder') {
                $ActivityDisplayOrder = $ActivityConfig.sortOrder
            } else { 
                $ActivityDisplayOrder = 999
            }

            Add-Content -Path $ActivityRegistry -Value "`n$ActivityID,$ProjectID,$ActivityDisplayOrder,$OptionNum,$Path,`"$ActivityTitle`""
            # Copy-Item "$ActivityFile" "$WORKING_DIR/activity_sort/$ProjectSortOrder-$ProjectID-$ActivitySortOrder-$ActivityID-activity.json"
        }

    }
}