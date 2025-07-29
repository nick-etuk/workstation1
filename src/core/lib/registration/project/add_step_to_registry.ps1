Function add_step_to_registry($StepID, $Description, $StepPath, $ProjectID) {
    writedebug "=>add_step_to_registry: $StepID, $Description, $StepPath, $ProjectID"
    $RegistryFile = "$WORKING_DIR/step_registry.csv"
    if (!(Test-Path -Path $RegistryFile)) {
        WriteWarning "Creating step registry"
        New-Item -Path $RegistryFile -ItemType File -Force | Out-Null
        Add-Content -Path $RegistryFile -Value "StepID,Description,Path,ProjectID"
    }
    if (!(Get-Content -Path $RegistryFile | Select-String -Pattern "^$StepID$")) {
        Add-Content -Path $RegistryFile -Value "`n$StepID,`"$Description`",$StepPath,$ProjectID"
        WriteInfo "$StepID added to registry"
    } else {
        WriteWarning "$StepID already registered"
    }
}
