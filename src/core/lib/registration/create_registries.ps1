Function create_registries {
    $RegistryFile = "$WORKING_DIR/project_registry.csv"

    if (!(Test-Path -Path $RegistryFile)) {
        WriteWarning "Creating project registry"
        New-Item -Path $RegistryFile -ItemType File -Force | Out-Null
        Add-Content -Path $RegistryFile -Value '"project_id","sort_order","display_order","path","title"'
    }

    if (!(Test-Path -Path "$REPO_DIR/workstation1-template-web" -PathType Container)) {
        info "Cloning template projects"
        clone_templates
    }

    if (!(Get-Content -Path $RegistryFile | Select-String -Pattern "^workstation1-template-web$")) {
        add_project_to_registry -ProjectID 'template-web' -Path "$REPO_DIR\workstation1-template-web" -Title 'Web App'
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
