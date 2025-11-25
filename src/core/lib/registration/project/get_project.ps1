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
        if ($Line.project_id -eq $ProjectID) {
            $ProjectWS1Root = $Line.path
            
            if (!(Test-Path -PathType Container $ProjectWS1Root)) {
                WriteError "Project ws1 root directory $ProjectWS1Root does not exist."
                return
            }

            $ConfigFile = Get-ChildItem -Path $ProjectWS1Root -Filter "ws1_project.json" -Recurse -File -ErrorAction SilentlyContinue
            if (!(Test-Path -PathType Leaf $ConfigFile.FullName)) {
                WriteError "Project config file not found in ws1 root directory $ProjectWS1Root."
                return
            }
            WriteDebug "Project config file found at $($ConfigFile.FullName)"
            $Content = Get-Content $FilePath -ErrorAction SilentlyContinue | Out-String
            $ProjectConfig = ConvertFrom-Json -InputObject $Content -ErrorAction SilentlyContinue

            if (!($ProjectConfig | Get-Member -Name 'projectRoot')) { 
                $ProjectConfig.projectRoot = $ProjectWS1Root
             }
             
            return $ProjectConfig
        }
    }

    return $null
}