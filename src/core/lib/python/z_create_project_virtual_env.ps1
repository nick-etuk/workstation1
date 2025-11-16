function create_project_virtual_env($project_id) {
    $project_root = get_project_root $project_id
    create_virtual_env $project_root $project_id
}
