Function create_registries {
    $RegistryFile = "$WORKING_DIR/project_registry.csv"

    if (!(Test-Path -Path $RegistryFile)) {
        WriteWarning "Creating project registry"
        New-Item -Path $RegistryFile -ItemType File -Force | Out-Null
        Add-Content -Path $RegistryFile -Value 'project_id,sort_order,path'
        Add-Content -Path $RegistryFile -Value "20,template-web',$REPO_DIR/workstation1-template-web"
    }
    
    $RegistryFile = "$WORKING_DIR/activity_registry.csv"
    if (!(Test-Path -Path $RegistryFile)) {
        WriteWarning "Creating activity registry"
        update_activity_registry
    }
    
    $RegistryFile = "$WORKING_DIR/step_registry.csv"
    if (!(Test-Path -Path $RegistryFile)) {
        WriteWarning "Creating step registry"
        update_step_registry
    }
}
