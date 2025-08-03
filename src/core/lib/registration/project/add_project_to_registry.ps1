Function get_project_sort_order($ProjectID) {
    switch ($ProjectID) {
        $CURRENT_PROJECT {
            return 10
        }
        'core' {
            return 30
        }
        default {
            return 20
        }
    }
}

Function add_project_to_registry($ProjectID, $DisplayOrder, $Path, $Title) {
    if (!(Test-Path -PathType Container $Path)) {
        writeError "Project path '$Path' does not exist"
        return
    }

    $RegistryFile = "$WORKING_DIR/project_registry.csv"
    if (!(Test-Path -Path $RegistryFile)) {
        WriteWarning "Creating project registry"
        New-Item -Path $RegistryFile -ItemType File -Force | Out-Null
        Add-Content -Path $RegistryFile -Value 'project_id,sort_order,display_order,path,title'
    }

    $Path = $Path.TrimEnd('\')
    if ((Get-Content -Path $RegistryFile | Select-String -Pattern "^$Path$")) {
        WriteInfo "$ProjectID already registered"
        return
    }

    $SortOrder = get_project_sort_order -ProjectID $ProjectID

    Add-Content -Path $RegistryFile -Value "`n$ProjectID,$SortOrder,$DisplayOrder,$Path,`"$Title`""
    WriteInfo "$ProjectID added to registry"
}
