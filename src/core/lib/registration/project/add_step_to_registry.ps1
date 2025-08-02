Function add_step_to_registry($StepID, $ProjectID, $StepPath, $Description) {
    writedebug "=>add_step_to_registry: $StepID, $ProjectID, $StepPath, $Description"
    $RegistryFile = "$WORKING_DIR/step_registry.csv"

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

    if ((Get-Content -Path $RegistryFile | Select-String -Pattern "^$StepID$")) {
        WriteWarning "$StepID already registered"
        return
    }

    Add-Content -Path $RegistryFile -Value "`n$StepID,$ProjectID,$SortOrder,$StepPath,`"$Description`""
    WriteInfo "$StepID added to registry"
}
