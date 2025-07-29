#Requires -Version 7
Set-StrictMode -Version 3.0

if (Test-Path variable:INIT_WIN) { return }

$INIT_WIN = 1
$CURRENT_STEP = 'general'

if (!(Test-Path variable:WS_ROOT_WIN)) { 
    $WS_ROOT_WIN = (get-item $PSScriptRoot).parent
 }

$Libraries = Get-Childitem -Path "$WS_ROOT_WIN\core\lib" -Include '*.ps1' -Exclude config_base.ps1, z*.ps1 -File -Recurse -ErrorAction SilentlyContinue
$index=0
foreach ($Library in $Libraries) {
    Write-Progress -Activity "Loading library" -Status "$index of $($Libraries.Count)" -CurrentOperation "$($Library.Name)" -PercentComplete (($index / $Libraries.Count) * 100)
    # Write-output "Loading library $index of $($Libraries.Count) - $($Library.Name)"
    . "$($Library.FullName)"
    $index+=1
}
. $PSScriptRoot\lib\conf\config_base.ps1 # Load config last since it is not just a function definiton.

set_repo_dir
$REPO_DIR = Get-Config repo_dir

if ("CPC-NIET2-AY8UE DESKTOP-2022".Contains($env:ComputerName)) { $DEBUG = $true}

if (Test-Path variable:DEBUG) {
    WriteInfo "Debug mode" 
    $DebugPreference = 'Continue'
    $VerbosePreference = 'Continue'
    try {
        Get-ChildItem $LOG_DIR | Remove-Item -Recurse -ErrorAction SilentlyContinue
    } catch {
        Write-Output "Error deleting $_"
    }
}

# $MAX_RETRIES = 3
# if($global:Debug) { $MAX_RETRIES = 1 }
# $RetryAttempt = Get-Retry-Attempts retry-attempts.txt

# WriteInfo -Level "Verbose" "Clean mode: $Clean"
# WriteInfo "RUN_ID: $RUN_ID"

# if ($RetryAttempt.gettype().Name -ne "Int32") { 
#     WriteInfo -Level "Verbose" "Corrupt RetryAttempt: $RetryAttempt"
#     WriteInfo -Level "Verbose" "Data type: $($RetryAttempt.gettype().Name)"
#     WriteInfo -Level "Verbose" "Value: $RetryAttempt"
#     WriteInfo -Level "Verbose" "Resetting to zero"
#     $RetryAttempt = 0
# } else {
#     WriteInfo -Level "Verbose" "Retry Attempt: $RetryAttempt"
# }

# Set-ExecutionPolicy Bypass -Scope Process -Force
# Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

Show-Config
