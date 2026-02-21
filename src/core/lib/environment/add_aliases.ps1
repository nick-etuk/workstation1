function add_aliases {
    if (get-alias | findstr 'grep') { return }
    New-Alias -Scope Global grep findstr
}

function gch { git checkout $args }
function gs { git status }
function gls { git log --show-signature }

function wspf { ws1 pf }
function cdpf { cd F:\repos\portfolio }

function cdws { cd F:\repos\workstation1 }
