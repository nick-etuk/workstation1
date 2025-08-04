function get_current_project {
writedebug "=>get_current_project"
    $CURRENT_PROJECT = Get-Config 'current_project'
    if ($CURRENT_PROJECT) { writedebug "bp1: $CURRENT_PROJECT"; return }

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
    # get the first project from the registry
    $FirstProject = $RegistryContent | Select-Object -First 1
    if (!$FirstProject) {
        WriteError "No projects found in registry: $ProjectRegistry"
        return
    }

    if ($FirstProject | Get-Member -Name 'project_id') {
        # writedebug "bp3: $FirstProject"
        writedebug "bp4: $($FirstProject).project_id"
        $Script:CURRENT_PROJECT = $FirstProject.project_id
        writedebug "bp5: $CURRENT_PROJECT"
        Set-Config 'current_project' $CURRENT_PROJECT
    }
    return
}