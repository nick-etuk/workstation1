function Get-Step-File ([parameter(Mandatory=$true)]$Step, [parameter(Mandatory=$true)]$Extension) {
    $FilePath = Get-Childitem -Path "$WS_ROOT_WIN" -Include "$Step.$Extension" -File -Recurse -ErrorAction SilentlyContinue
    if ($FilePath) { return $FilePath }

    $Step = $Step.ToLower() -replace '-', '_'
    $FilePath = Get-Childitem -Path "$WS_ROOT_WIN" -Include "$Step.$Extension" -File -Recurse -ErrorAction SilentlyContinue
    if ($FilePath) { return $FilePath }
}

function Get-Step-Directory ([parameter(Mandatory=$true)]$Step) {
    $FilePath = Get-Step-File -Step $Step -Extension ps1
    if ($FilePath) { return Split-Path -Path $FilePath -Parent }
    
    $FilePath = Get-Step-File -Step $Step -Extension sh
    if ($FilePath) { return Split-Path -Path $FilePath -Parent }
}

function Get-Step-Config ([parameter(Mandatory=$true)]$Step) {
    $FilePath = Get-Step-File -Step $Step -Extension json
    if (!$FilePath) { return }
    $content = Get-Content $FilePath -ErrorAction SilentlyContinue | Out-String
    $Json = ConvertFrom-Json -InputObject $content -ErrorAction SilentlyContinue
    return $Json
}
