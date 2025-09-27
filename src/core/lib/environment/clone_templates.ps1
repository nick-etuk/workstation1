function clone_templates {
    # if ($(Get-Config status templates_cloned) -eq 'done') { return }
    Set-Location $REPO_DIR
    git clone https://github.com/nick-etuk/workstation1-template-web.git
    # Set-Config status templates_cloned 'done'
    Set-Location $WS_ROOT_WIN
}
