Function add_project_to_registry($ID, $Path) {
    if (!(Test-Path -PathType Container $Path)) {
        writeError "Project path '$Path' does not exist"
        return
    }
    $RegistryFile = "$WORKING_DIR/project_registry.csv"
    if (!(Test-Path -Path $RegistryFile)) {
        WriteWarning "Creating project registry"
        New-Item -Path $RegistryFile -ItemType File -Force | Out-Null
        Add-Content -Path $RegistryFile -Value 'ProjectID,Path'
    }
    $Path = $Path.TrimEnd('\')
    if (!(Get-Content -Path $RegistryFile | Select-String -Pattern "^$Path$")) {
        Add-Content -Path $RegistryFile -Value "`n$ID,$Path"
        WriteInfo "$ID added to registry"
    } else {
        WriteInfo "$ID already registered"
    }
}
