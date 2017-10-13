# Read in all ps1 files expect those in the Lib folder
Get-ChildItem $PSScriptRoot |
    ? {$_.PSIsContainer -and ($_.Name -ne 'Lib') -and ($_.Name -ne 'Tests') -and ($_.Name -ne '.git')} |
    % {Get-ChildItem "$($_.FullName)\*.ps1" -Exclude '*.Tests.ps1'} |
    % {. $_.FullName}
