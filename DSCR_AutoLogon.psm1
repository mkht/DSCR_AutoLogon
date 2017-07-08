$modulePath = $PSScriptRoot
$functionsPath = '\functions'

Get-ChildItem (Join-Path $modulePath $functionsPath) -Include "*.ps1" -Recurse | 
    % { . $_.PsPath }
