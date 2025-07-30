function find_steps ($ProjectID, $ProjectPath) {
    writedebug "=>find_steps: $ProjectID, $ProjectPath"
    $StepDirectories = Get-ChildItem -Path $ProjectPath -Filter 'steps' -Directory -Recurse -ErrorAction SilentlyContinue  

    if (!$StepDirectories) {
        WriteWarning "No step directories found in $ProjectPath"
        return
    }

    foreach ($StepDir in $StepDirectories) {
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

            add_step_to_registry -StepID $StepID -Description $StepDescription -StepPath $StepFile -ProjectID $ProjectID
        }
    }
}

function update_step_registry {
    $StepRegistry = "$WORKING_DIR/step_registry.csv"
    Remove-Item $StepRegistry -Force

    if (!(Test-Path -Path $StepRegistry)) {
        WriteInfo "Creating step registry $StepRegistry"
        New-Item -Path $StepRegistry -ItemType File -Force | Out-Null
        Add-Content -Path $StepRegistry -Value "project_id,step_id,path,description"
    }

    $ProjectRegistry = "$WORKING_DIR/project_registry.csv"
    $RegistryContent = Import-CSV $ProjectRegistry
    # $RegistryContent = Get-Content -Path $ProjectRegistry -ErrorAction SilentlyContinue
    if (!$RegistryContent) {
        WriteError "Project registry is empty or could not be read: $ProjectRegistry"
        return
    }
    foreach ($Line in $RegistryContent) {
        $SortOrder = $Line.sort_rder
        $ProjectID = $Line.project_id
        $ProjectDirectory = $Line.path
        writedebug "bp1 project directory: $ProjectDirectory"
        $ProjectDirectory = $ProjectDirectory.Trim()
        if (!(Test-Path -Path $ProjectDirectory)) {
            WriteWarning "Project directory not found: $ProjectDirectory"
            continue
        }
        find_steps -ProjectID $ProjectID -ProjectPath $ProjectDirectory
    }
    find_steps -ProjectID 'core' -ProjectPath "$WS_ROOT_WIN\core"

    # todo: list steps in this order: current project, other projects by their sortOrder then core

}

function list_steps {
    update_step_registry
    $StepRegistry = "$WORKING_DIR/step_registry.csv"
    if (!(Test-Path -Path $StepRegistry)) {
        WriteError "Step registry not found at $StepRegistry"
        return
    }

    $StepRegistryContent = Import-CSV $StepRegistry
    if (!$StepRegistryContent) {
        WriteError "Step registry is empty or could not be read: $StepRegistry"
        return
    }

    # foreach ($Step in $StepRegistryContent) {
    #     Write-Host "Step ID: $($Step.StepID)"
    #     Write-Host "Description: $($Step.Description)"
    #     Write-Host "Path: $($Step.Path)"
    #     Write-Host "Project ID: $($Step.ProjectID)"
    #     Write-Host ""
    # }
    $StepRegistryContent | Format-Table
}