function install_py_packages($project_id) {
    $project_root = (get_project $project_id).projectRoot
    if ($project_id -eq "ws1") {
        $package_name = "workstation1"
    } else {
        $package_name = $project_id
    }
    if (-not (pip list | Select-String -Pattern $package_name)) {
        python -m pip install --upgrade pip
        Write-Host "Installing $package_name packages..."
        # pip install -r "$project_root/requirements.txt" # todo: fix this
        Write-Host "Installing $package_name as an editable package at $project_root..."
        pip install -e $project_root
    }
}
