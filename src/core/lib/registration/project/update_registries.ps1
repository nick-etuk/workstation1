Function update_registries {
    $RegistryFile = "$WORKING_DIR/project_registry.csv"

    if (!(Test-Path -Path $RegistryFile)) {
        WriteWarning "Creating project registry"
        New-Item -Path $RegistryFile -ItemType File -Force | Out-Null
        Add-Content -Path $RegistryFile -Value 'sort_order,project_id,path'
        Add-Content -Path $RegistryFile -Value "20,template-web',$REPO_DIR/workstation1-template-web"
    }
}
