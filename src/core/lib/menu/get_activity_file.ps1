function get_activity_file($ActivityID) {
    if (-not $ActivityID) {
        Write-Error "Activity ID is required"
        return
    }

    $ActivityRegistry = "$WORKING_DIR/activity_registry.csv"
    if (!(Test-Path -Path $ActivityRegistry)) {
        WriteError "Activity registry not found at $ActivityRegistry"
        return
    }

    # $RegistryContent = Get-Content -Path $RegistryFile -ErrorAction SilentlyContinue
    $RegistryContent = Import-CSV $ActivityRegistry
    if (!$RegistryContent) {
        WriteError "get_activity_file: Activity registry is empty or could not be read: $ActivityRegistry"
        return
    }

    $ActivityFile = $RegistryContent | Where-Object { $_.activity_id -eq $ActivityID } | Select-Object -ExpandProperty path
    if ($ActivityFile) {
        return $ActivityFile
    } else {
        WriteWarning "Activity file not found for ID: $ActivityID"
        return
    }
    # foreach ($Line in $RegistryContent) {
    #     $ID = $Line.activity_id
    #     $Path = $Line.path
    #     if (!$ID -or !$Path) {
    #         WriteWarning "Invalid registry line: $Line"
    #         continue
    #     }
    #     if ($ID -eq $ActivityID) {
    #         return $Path
    #     }
    # }
}