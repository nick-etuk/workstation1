Function add_project_to_registry($ProjectID, $Path) {
    if (!(Test-Path -PathType Container $Path)) {
        writeError "Project path '$Path' does not exist"
        return
    }

    $RegistryFile = "$WORKING_DIR/project_registry.csv"
    if (!(Test-Path -Path $RegistryFile)) {
        WriteWarning "Creating project registry"
        New-Item -Path $RegistryFile -ItemType File -Force | Out-Null
        Add-Content -Path $RegistryFile -Value 'project_id,sort_order,path'
    }

    $Path = $Path.TrimEnd('\')
    if ((Get-Content -Path $RegistryFile | Select-String -Pattern "^$Path$")) {
        WriteInfo "$ProjectID already registered"
        return
    }

    switch ($ProjectID) {
        $CURRENT_PROJECT {
            $SortOrder = 10
        }
        'core' {
            $SortOrder = 30
        }
        default {
            $SortOrder = 20
        }
    }

    Add-Content -Path $RegistryFile -Value "`n$ProjectID,$SortOrder,$Path"
    WriteInfo "$ProjectID added to registry"
}
