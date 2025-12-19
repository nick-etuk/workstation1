function get_context {
    writedebug "=>get_context"
    $Script:CURRENT_PROJECT_ID = Get-Config 'current_project_id'
    $Script:DEFAULT_STEP_PATH = Get-Config 'default_step_path'
    if ($Script:CURRENT_PROJECT_ID) { writedebug "bp1: $Script:CURRENT_PROJECT_ID, $Script:DEFAULT_STEP_PATH"; return }
    return
}