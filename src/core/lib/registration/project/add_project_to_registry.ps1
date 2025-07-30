Function add_project_to_registry($ProjectID, $Path) {
    if (!(Test-Path -PathType Container $Path)) {
        writeError "Project path '$Path' does not exist"
        return
    }
    $RegistryFile = "$WORKING_DIR/project_registry.csv"
    if (!(Test-Path -Path $RegistryFile)) {
        WriteWarning "Creating project registry"
        New-Item -Path $RegistryFile -ItemType File -Force | Out-Null
        Add-Content -Path $RegistryFile -Value 'sort_order,project_id,path'
    }
    $Path = $Path.TrimEnd('\')
    if (!(Get-Content -Path $RegistryFile | Select-String -Pattern "^$Path$")) {
        Add-Content -Path $RegistryFile -Value "`n20,$ProjectID,$Path"
        WriteInfo "$ProjectID added to registry"
    } else {
        WriteInfo "$ProjectID already registered"
    }
}
