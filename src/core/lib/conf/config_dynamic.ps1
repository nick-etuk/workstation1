function Get-Config {
    switch($args.Length) {
        1 {
            $Group = 'general'
            $Key = $args[0]
        }
        2 {
            $Group = $args[0]
            $Key = $args[1]
        }
        default {
            WriteError "Invalid number of arguments for Get-Config: $($args.Length) arguments - $($args -join ', ')"
            # writeError "$($args.Length) arguments - $($args -join ', ')"
        }
    }

    $StatusFile = "$WORKING_DIR\$Group\$Key.txt"

    if (!(Test-Path "$WORKING_DIR\$Group" -PathType Container)) {
        return
    }

    if (!(Test-Path $StatusFile)) {
        return
    }

    $Value = Get-Content $StatusFile
    return $Value
}

function Set-Config {
    switch($args.Length) {
        2 {
            $Group = 'general'
            $Key = $args[0]
            $Value = $args[1]
        }
        3 {
            $Group = $args[0]
            $Key = $args[1]
            $Value = $args[2]
        }
        default {
            Write-Error "Invalid number of arguments for Set-Config: $($args.Length) arguments - $($args -join ', ')"
            # writeError "$($args.Length) arguments - $($args -join ', ')"
        }
    }

    if ($(Get-Config $args) -eq $Value) {
        # WriteDebug "$($args -join ' ') unchanged from '$Value'"
        return
    }
    
    if (!(Test-Path -PathType Container "$WORKING_DIR\$Group")) {
        New-Item -ItemType Directory -Path "$WORKING_DIR\$Group" | Out-Null
    }

    $StatusFile = "$WORKING_DIR\$Group\$Key.txt"

    if (!(Test-Path $StatusFile)) {
        New-Item -ItemType File -Path $StatusFile | Out-Null
    }

    Set-Content -Path $StatusFile -Value $Value
}
