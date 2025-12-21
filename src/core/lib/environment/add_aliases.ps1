function add_aliases {
    write-output "=>add_aliases"
    if (get-alias | findstr 'grep') { return }
    write-output "bp1 add_aliases running"

    New-Alias grep findstr
    New-Alias gch 'git checkout'
    New-Alias gs 'git status'
    New-Alias gls 'git log --show-signature'
    
    New-Alias wspf 'ws1 pf'
    New-Alias cdpf 'cd F:\repos\portfolio'

    New-Alias cdws 'cd F:\repos\workstation1'
}
