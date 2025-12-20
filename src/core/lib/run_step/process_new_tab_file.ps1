function process_new_tab_file($task_file) {

    writedebug "Processing new tab file: $task_file"
    # Read file into a variable, delete the file, then process the contents.
    $file_content = Get-Content -Path $task_file -ErrorAction SilentlyContinue
    if (!$file_content) {
        WriteWarn "New tab file $task_file is empty or could not be read."
        return
    }
    Remove-Item -Path $task_file -ErrorAction SilentlyContinue
    
    foreach ($line in $file_content) {
        # $parts = $line -split '~'
        $parts = $line -split ' '
        $step_id = $parts[0]
        $arguments = $parts[1..($parts.Length - 1)]
        # RunStep -StepID $step_id -Arguments $arguments
        # Assume that init.ps1 has been sourced in terminal_login.ps1
        . "$ScriptFile" -Arguments $Arguments
    }
}
