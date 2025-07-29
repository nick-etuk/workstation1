function get_project_paths {
    Param (
        [Parameter(Mandatory=$false)]
        [string]
        $Filter
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
    $ProjectPaths = @()
    foreach ($Line in $RegistryContent) {
        $ProjectID = $Line.ProjectID
        $ProjectDirectory = $Line.Path
        if (!$ProjectID -or !$ProjectDirectory) {
            WriteWarning "Invalid registry line: $Line"
            continue
        }
        # $ProjectDirectory = $ProjectDirectory.Trim()
        if (!(Test-Path -Path $ProjectDirectory)) {
            WriteWarning "Project directory not found: $ProjectDirectory"
            continue
        }
        if ($Filter -and $ProjectID -eq $Filter) {
            return $ProjectDirectory
        }
        $ProjectPaths += $ProjectDirectory
    }

    return $ProjectPaths
}