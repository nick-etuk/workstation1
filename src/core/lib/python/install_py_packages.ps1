function install_py_packages($project_id) {
    $project_root = get_project_root $project_id
    if ($project_id -eq "ws1") {
        $package_name = "workstation1"
    } else {
        $package_name = $project_id
    }
    Write-Error "install_python_packages should not be called for $package_name"
    if (-not (pip list | Select-String -Pattern $package_name)) {
        Write-Host "Installing $package_name packages..."
        # pip install -r "$project_root/requirements.txt" # todo: fix this
        pip install -e $project_root
    }
}
