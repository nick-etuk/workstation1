function get_activity_file($ActivityID) {
    $ProjectPaths = get_project_paths
    foreach ($ProjectPath in $ProjectPaths) {
        $ActivityFiles = Get-Childitem -Path $ProjectPath -Include '*activity*.json' -File -Recurse -ErrorAction SilentlyContinue

        foreach ($ActivityFile in $ActivityFiles) {
            $content = Get-Content $ActivityFile -ErrorAction SilentlyContinue | Out-String
            $ActivityConfig = ConvertFrom-Json -InputObject $content -ErrorAction SilentlyContinue
            $Id = $ActivityConfig.id
            if ($Id -eq $ActivityID) { return $ActivityFile.FullName }
        }
    }
}