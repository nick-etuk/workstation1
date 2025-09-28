function Get-ScriptRootUnix {
    if (Test-Path variable:Script:WS_ROOT_UNIX) { 
        if (!([string]::IsNullOrEmpty($Script:WS_ROOT_UNIX))) {
            return 
        }
    }
    
    $Script:WS_ROOT_UNIX = Get-Config 'WS_ROOT_UNIX'
    if ($Script:WS_ROOT_UNIX) { 
        return 
    }
    
    WriteInfo "Searching for workstation1 in WSL"
    $Script:WS_ROOT_UNIX = $(wsl -u $WS_USER_UNIX find ~ -type d -name 'workstation1')

    if ($Script:WS_ROOT_UNIX) {
        Set-Config 'WS_ROOT_UNIX' $Script:WS_ROOT_UNIX
        return
    }
    WriteInfo "Cannot find workstation1 directory in WSL"
}
