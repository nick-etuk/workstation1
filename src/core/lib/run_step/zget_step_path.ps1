function zGet-Step-File ([parameter(Mandatory=$true)]$Step, [parameter(Mandatory=$true)]$Extension) {
    $Step = $Step.ToLower() -replace '-', '_'
    # todo: search for steps in this order:
    # current project, core, other projects
    $ProjectPaths = get_project_paths
    foreach ($ProjectPath in $ProjectPaths) {
        $FilePath = Get-Childitem -Path "$ProjectPath" -Include "$Step.$Extension" -File -Recurse -ErrorAction SilentlyContinue
        if ($FilePath) { return $FilePath }
    }
    $FilePath = Get-Childitem -Path "$WS_ROOT_WIN/core/steps" -Include "$Step.$Extension" -File -Recurse -ErrorAction SilentlyContinue
    if (!$FilePath) { writewarn "Step file $Step.$Extension not found" }
    return $FilePath
}

function zGet-Step-Directory ([parameter(Mandatory=$true)]$Step) {
    $FilePath = Get-Step-File -Step $Step -Extension ps1
    if ($FilePath) { return Split-Path -Path $FilePath -Parent }
    
    $FilePath = Get-Step-File -Step $Step -Extension sh
    if ($FilePath) { return Split-Path -Path $FilePath -Parent }
}

function zzget_step_config ([parameter(Mandatory=$true)]$Step) {
    $FilePath = Get-Step-File -Step $Step -Extension json
    if (!$FilePath) { return }
    $content = Get-Content $FilePath -ErrorAction SilentlyContinue | Out-String
    $Json = ConvertFrom-Json -InputObject $content -ErrorAction SilentlyContinue
    return $Json
}
