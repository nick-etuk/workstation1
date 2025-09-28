function Show-Config {
    WriteInfo "REPO_DIR: $REPO_DIR"
    WriteInfo "WORKING_DIR: $WORKING_DIR"
    WriteInfo "LOG_DIR: $LOG_DIR"
    WriteInfo "WS_USER_UNIX: $WS_USER_UNIX"
    WriteInfo "GCM_PATH_WIN: $GCM_PATH_WIN"
    WriteInfo "GCM_PATH_WSL: $GCM_PATH_WSL"
    WriteInfo "WS_ROOT_WIN: $WS_ROOT_WIN"
}

$FORCE = $false
$DEBUG = $true
if ($DebugPreference -eq 'Continue') { $DEBUG = $true }

$WS_USER_WIN = $env:USERNAME
$WS_USER_UNIX = $WS_USER_WIN.ToLower()
if ($DEBUG) { $WS_USER_UNIX = "account1" }

$WS_VERSION = '1.2'  # Update this when making changes that require users to update their profiles
$BASE_DIR = "$HOME\.workstation1"
$WORKING_DIR = "$BASE_DIR\working"
$LOG_BASE="$BASE_DIR\log" #todo: use windows event log, C:\WINDOWS\system32\config
if (!(Test-Path -PathType Container $WORKING_DIR)) {
    New-Item -Path $WORKING_DIR -ItemType Directory | Out-Null
    New-Item -Path $WORKING_DIR\keybase -ItemType Directory | Out-Null
    New-Item -Path $WORKING_DIR\activity_sort -ItemType Directory | Out-Null
    New-Item -Path $WORKING_DIR\test_results -ItemType Directory | Out-Null
}

$TICK_MARK = "$([char]0x1b)[92m$([char]8730)"
$CROSS_MARK = "$([char]0x1b)[91m$([char]10006)"

Get-Next-Run-ID
if (!(Test-Path variable:RUN_ID)) {
    WriteInfo "RUN_ID not set, using default value: 001"
    $RUN_ID = "001"
}

$LOG_DIR = "$LOG_BASE\$RUN_ID"
if (!(Test-Path -PathType Container $LOG_DIR)) {
    New-Item -Path $LOG_DIR -ItemType Directory -Force | Out-Null
}
$LOG_FILE = Join-Path $LOG_DIR -ChildPath "init.log"
if (!(Test-Path -PathType Leaf $LOG_FILE)) {
    New-Item -Path $LOG_FILE -ItemType File -Force | Out-Null
}

# $CONFIG_FILE = "$WORKING_DIR\config.ini"

# $REPO_DIR = "$HOME\repos"
# if ("DESKTOP-2022".Contains($env:ComputerName)) {    
#     $REPO_DIR = "F:\repos"
# }

$GCM_PATH_WIN = Find-GCM-Executable
$GCM_PATH_WSL = Get-Unix-Path $GCM_PATH_WIN

$WS_ROOT_UNIX = ''  # This will be set later if needed

$MY_DOWNLOAD_DIR = "$BASE_DIR\downloads"

$ANDROID_EMULATOR_PORT = 5554

$GreenCheck = @{
    Object = [Char]8730
    ForegroundColor = 'Green'
    NoNewLine = $true
}

$RedCross = @{
    Object = [Char]10006
    ForegroundColor = 'Red'
    NoNewLine = $true
}

$NoColor = @{
    Object = 'a'
    ForegroundColor = 'White'
    NoNewLine = $true
}

# Write-Host "Status check... " -NoNewline
# Write-Host @GreenCheck
# # Write-Host @NoColor
# Write-Host " white text"
# Write-Host @$RedCross
# # Write-Host @NoColor
# Write-Host " white text"
