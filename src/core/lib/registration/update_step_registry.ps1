function find_steps ($ProjectID, $ProjectPath) {
    $StepDirectories = Get-ChildItem -Path $ProjectPath -Filter 'steps' -Directory -Recurse -ErrorAction SilentlyContinue  

    if (!$StepDirectories) {
        WriteWarning "No step directories found in $ProjectPath"
        return
    }

    foreach ($StepDir in $StepDirectories) {
        if ($StepDir -match 'conf/project_template') {
            WriteDebug "Skipping project template steps in $StepDir"
            continue
        }
        $StepFiles = Get-ChildItem -Path $StepDir -Recurse -Filter "*.json" -ErrorAction SilentlyContinue
        foreach ($StepFile in $StepFiles) {
            $StepID = (get-item $StepFile).BaseName
            $StepID = $StepID.ToLower() -replace '-', '_'
            $Content = Get-Content $StepFile -ErrorAction SilentlyContinue | Out-String
            $StepConfig = ConvertFrom-Json -InputObject $Content -ErrorAction SilentlyContinue
            if ($StepConfig | Get-Member -Name 'description') {
                $StepDescription = $StepConfig.description
            } else {
                $StepDescription = get_step_description $StepID
            }

            add_step_to_registry -StepID $StepID  -ProjectID $ProjectID -StepPath $StepFile -Description $StepDescription
        }
    }
}

function update_step_registry {
    $StepRegistry = "$WORKING_DIR/step_registry.csv"
    if (Test-Path -PathType Leaf $StepRegistry) { Remove-Item $StepRegistry -Force}
    New-Item -Path $StepRegistry -ItemType File -Force | Out-Null
    Add-Content -Path $StepRegistry -Value 'step_id,project_id,sort_order,path,description'

    $ProjectRegistry = "$WORKING_DIR/project_registry.csv"
    $RegistryContent = Import-CSV $ProjectRegistry
    # $RegistryContent = Get-Content -Path $ProjectRegistry -ErrorAction SilentlyContinue
    if (!$RegistryContent) {
        WriteError "Project registry is empty or could not be read: $ProjectRegistry"
        return
    }
    foreach ($Line in $RegistryContent) {
        $ProjectID = $Line.project_id
        $ProjectDirectory = $Line.path
        $ProjectDirectory = $ProjectDirectory.Trim()
        if (!(Test-Path -Path $ProjectDirectory)) {
            WriteWarning "Project directory not found: $ProjectDirectory"
            continue
        }
        find_steps -ProjectID $ProjectID -ProjectPath $ProjectDirectory
    }
    find_steps -ProjectID 'core' -ProjectPath "$WS_ROOT_WIN\core"

    # $StepRegistryContent = Import-CSV $StepRegistry
    # if (!$StepRegistryContent) {
    #     WriteError "Step registry is empty or could not be read: $StepRegistry"
    #     return 
    # }
    # $SortedStepRegistry = $StepRegistryContent | Sort-Object -Property sort_order, step_id
    # # # $SortedStepRegistry | Export-CSV -Path $StepRegistry -NoTypeInformation -Force
    # $SortedStepRegistry | Export-CSV -Path $StepRegistry -QuoteFields 'description'
}
