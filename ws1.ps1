param (
    [Parameter(Position=0)]
    [string]$Command,
    [Parameter(Position=1, ValueFromRemainingArguments=$true)]
    [string[]]$Arguments
)

$ErrorActionPreference = "Stop"

if (!(Test-Path variable:WS_ROOT_WIN)) { 
    $Script:WS_ROOT_WIN = (get-item $PSScriptRoot)
    Write-output "Manually set WS_ROOT_WIN to $WS_ROOT_WIN"
}

# todo: run check_for_os_updates.sh, install_pyenv, setup_terminal.sh here

# $init_script = Get-Childitem -Path "$WS_ROOT_WIN" -Include 'init.ps1' -exclude $VENV_DIR -File -Recurse -ErrorAction SilentlyContinue
$VENV_DIR = Get-Childitem -Path "$WS_ROOT_WIN" -Include '.venv_ws1' -Directory -Recurse
$init_script = Get-Childitem -Path "$WS_ROOT_WIN" -Include 'init.ps1' -Recurse | Where-Object { $_.FullName -notlike "*$($VENV_DIR.Name)*" }
if (-not $init_script) {
    WriteError "init.ps1 not found. Aborting."
}

# $Script:WS_ROOT_SCRIPT = $init_script.Directory.Parent.FullName
$Script:WS_ROOT_SCRIPT = $init_script.Directory

.  $WS_ROOT_SCRIPT\lib\other\logging.ps1
.  $WS_ROOT_SCRIPT\lib\registration\project\get_project_root.ps1
.  $WS_ROOT_SCRIPT\lib\python\create_venv.ps1
.  $WS_ROOT_SCRIPT\lib\python\activate_venv.ps1
.  $WS_ROOT_SCRIPT\lib\python\install_py_packages.ps1

& $WS_ROOT_SCRIPT\vm\dev_box\unschedule_first_login.ps1

# todo: decide how to manage venvs
create_venv 'ws1'
# activate_venv 'ws1'
# install_py_packages 'ws1'

$startup_script = Get-Childitem -Path "$WS_ROOT_WIN" -Include 'ws.py' -exclude '.venv_ws1' -Recurse -File -ErrorAction SilentlyContinue
# WriteDebug "startup_script: $startup_script"
python $startup_script.FullName $Command $Arguments
