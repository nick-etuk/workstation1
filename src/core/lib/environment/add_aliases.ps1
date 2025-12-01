function add_aliases {
    if (get-alias | findstr 'grep') { return }

    New-Alias grep findstr
}
