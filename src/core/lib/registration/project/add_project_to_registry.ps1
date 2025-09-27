Function get_project_sort_order($ProjectID) {
    switch ($ProjectID) {
        $Script:CURRENT_PROJECT {
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

Function add_project_to_registry($ProjectID, $Path, $Title) {
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

    WriteInfo "Registering Project $ProjectID at $Path"
    $Script:CURRENT_PROJECT="$ProjectID"

    if ([string]::IsNullOrWhiteSpace($Title)) {
        $Title = $ProjectID
    }

    $SortOrder = get_project_sort_order -ProjectID $ProjectID

    $DisplayOrder = (Get-Content -Path $RegistryFile | Measure-Object).Count - 1
    if ($DisplayOrder -lt 0) { $DisplayOrder = 0 }
    Add-Content -Path $RegistryFile -Value "`n$ProjectID,$SortOrder,$DisplayOrder,$Path,`"$Title`""
    WriteInfo "$ProjectID added to registry"
}
