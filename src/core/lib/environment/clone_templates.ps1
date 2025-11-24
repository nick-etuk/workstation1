function clone_templates {
    # if ($(Get-Config templates_cloned  status) -eq 'done') { return }
    Set-Location $REPO_DIR
    git clone https://github.com/nick-etuk/workstation1-template-web.git
    # Set-Config templates_cloned 'done'  status
    Set-Location $WS_ROOT_WIN
}
