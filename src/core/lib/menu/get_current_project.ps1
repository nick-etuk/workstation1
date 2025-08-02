function get_current_project {

    CURRENT_PROJECT = Get-Config current_project
    if ($CURRENT_PROJECT) return

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
    $CURRENT_PROJECT = $FirstProject.project_id
    return
}