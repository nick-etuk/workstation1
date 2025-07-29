function SortActivities {
    Remove-Item "$WORKING_DIR/activity_sort/*" -Force
    $ProjectPaths = get_project_paths
    foreach ($ProjectPath in $ProjectPaths) {
        $ProjectConfigFile = Get-Childitem -Path "$ProjectPath" -Include 'ws1_project.json' -File -Recurse -ErrorAction SilentlyContinue
        $content = Get-Content $ProjectConfigFile -ErrorAction SilentlyContinue | Out-String
        $ProjectConfig = ConvertFrom-Json -InputObject $content -ErrorAction SilentlyContinue
        $ProjectID = $ProjectConfig.id
        if ($ProjectConfig | Get-Member -Name 'sortOrder') {
            $ProjectSortOrder = $ProjectConfig.sortOrder
        } else { 
            $ProjectSortOrder = 999
        }
        Copy-Item "$ProjectConfigFile" "$WORKING_DIR/activity_sort/$ProjectSortOrder-$ProjectID-ws1.config.json"

        $ActivityFiles = Get-Childitem -Path $ProjectPath -Include '*activity*.json' -File -Recurse -ErrorAction SilentlyContinue

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