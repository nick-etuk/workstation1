function add_aliases {
    if (get-alias | findstr 'grep') { return }

    New-Alias grep findstr
    New-Alias gch git checkout
    New-Alias gs git status
    New-Alias gls 'git log --show-signature'
}
