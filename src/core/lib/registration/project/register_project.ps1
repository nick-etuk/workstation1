function register_project { 
    $CurrentPath = Get-Location
    $ConfigFile = Get-ChildItem -Path $CurrentPath -Filter "ws1_project.json" -Recurse -File -ErrorAction SilentlyContinue
    if ($ConfigFile) {
        writeinfo "Project config file found at $($ConfigFile.FullName)"
        WriteInfo "Registering existing project $CurrentPath"
        $Content = Get-Content $FilePath -ErrorAction SilentlyContinue | Out-String
        $ProjectConfig = ConvertFrom-Json -InputObject $Content -ErrorAction SilentlyContinue
        if ($ProjectConfig | Get-Member -Name 'id') {
            $ProjectID = $ProjectConfig.id
        } else {
            WriteWarning "Project config $($ConfigFile.FullName) does not contain 'id' field"
            WriteWarning "Generating new project ID"
            $ProjectID = "project_" + (Get-Random -Minimum 1000 -Maximum 9999)
        }
        add_project_to_registry -ProjectID $ProjectID -Path $CurrentPath
        return
    }

    $ProjectDescr = Read-Host "Project description:"
    $ProjectID = Read-Host "Project ID (e.g., webapp):"

    # copy template files
    $TemplateDir = "$WS_ROOT_WIN\core\lib\conf\project_template"
    Copy-Item -Path $TemplateDir -Destination $CurrentPath -Recurse -Force
    Rename-Item -Path "$CurrentPath\project_template" -NewName "workstation1"
    
    # update project files
    $ProjectConfigFile = "$CurrentPath\workstation1\ws1_project.json.txt"
    $Content = Get-Content -Path $ProjectConfigFile
    $Content = $Content -replace '{{id}}' , $ProjectID
    $Content = $Content -replace '{{description}}' , $ProjectDescr
    $Content | Set-Content -Path $ProjectConfigFile
    Rename-Item -Path $ProjectConfigFile -NewName "ws1_project.json"

    add_project_to_registry -ProjectID $ProjectID -Path $CurrentPath

}