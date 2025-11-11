function get_project {
    Param (
        [Parameter(Mandatory=$false)]
        [string]
        $ProjectID
    )
    $ProjectRegistry = "$WORKING_DIR/project_registry.csv"
    if (!(Test-Path -Path $ProjectRegistry)) {
        WriteError "Project registry not found at $ProjectRegistry"
        return
    }

    # $RegistryContent = Get-Content -Path $RegistryFile -ErrorAction SilentlyContinue
    $RegistryContent = Import-CSV $ProjectRegistry
    if (!$RegistryContent) {
        WriteError "Project registry is empty or could not be read: $RegistryFile"
        return
    }

    foreach ($Line in $RegistryContent) {
        $ProjectID = $Line.project_id
        if ($Line.project_id -eq $ProjectID) {
            return $Line
        }
    }

    return $null
}