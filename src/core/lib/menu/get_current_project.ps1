function get_current_project {
    writedebug "=>get_current_project"
    $Script:CURRENT_PROJECT_ID = Get-Config 'current_project_id'
    $Script:CURRENT_PROJECT_ROOT = Get-Config 'current_project_root'
    if ($Script:CURRENT_PROJECT_ID) { writedebug "bp1: $Script:CURRENT_PROJECT_ID, $Script:CURRENT_PROJECT_ROOT"; return }
    return
}