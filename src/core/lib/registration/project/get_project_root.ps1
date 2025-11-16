function get_project_root($project_id) {
    if ($project_id -eq "ws1") {
       return $WS_ROOT_WIN
    }

    $registry_entry = get_project $project_id
    if (-not $registry_entry) {
        Write-Host "Project ID $project_id not found in registry. Aborting."
        return
    }
    $project_path = $registry_entry.project_path
    if (-not (Test-Path -Path $project_path)) {
        Write-Host "Project path $project_path does not exist. Aborting."
        return
    }
    $project_root = Get-Item $project_path.Parent.FullName
    return $project_root
}
