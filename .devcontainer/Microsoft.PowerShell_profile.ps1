Import-Module posh-git
Import-Module PSFzf -ArgumentList 'Ctrl+t', 'Ctrl+r'
Import-Module z
Import-Module Terminal-Icons

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

$env:POSH_GIT_ENABLED=$true
oh-my-posh init pwsh --config $env:POSH_THEME | Invoke-Expression

# NOTE: You can override the above env var from the devcontainer.json "args" under the "build" key.

# Aliases
Set-Alias -Name ac -Value Add-Content