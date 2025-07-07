function Get-Git-Repos-WSL {
    
    # Use $WINDOWS_USER instead of $WSL_USER as it might be account1
    wsl -u $WSL_USER git config --global user.name "$WINDOWS_USER"
    wsl -u $WSL_USER git config --global user.email "$WINDOWS_USER@hscic.gov.uk"
    wsl -u $WSL_USER git config --global credential.helper "$GCM_PATH_WSL"
    wsl -u $WSL_USER mkdir ~/repos
    
    wsl -u $WSL_USER --cd ~/repos git clone https://github.com/NHSDigital/nhsapp-dev-workstation.git
    wsl -u $WSL_USER --cd ~/repos git checkout feature/nhso-42212-catalog-task-defintions
    wsl -u $WSL_USER --cd ~/repos git clone https://github.com/NHSDigital/nhsapp.git

    wsl -u $WSL_USER git config --global pull.rebase true
    wsl -u $WSL_USER git config --global push.default current
    wsl -u $WSL_USER git config --global core.autocrlf false
    wsl -u $WSL_USER git config --global fetch.prune true
    wsl -u $WSL_USER git config --global fetch.pruneTags true

    wsl -u $WSL_USER git config --global core.pager 'less -FRX'
    wsl -u $WSL_USER git config --global core.editor "code --wait"
    wsl -u $WSL_USER git config --global rerere.enabled false
    wsl -u $WSL_USER git config --global color.ui true
    wsl -u $WSL_USER git config --global alias.ch checkout
    wsl -u $WSL_USER git config --global branch.sort -committerdate
    wsl -u $WSL_USER git config --global column.ui auto
}
Get-Git-Repos-WSL