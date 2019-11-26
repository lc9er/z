$cdHistory = Join-Path -Path $Env:USERPROFILE -ChildPath '\.cdHistory'

$functionFolders = @('Public', 'Private')
ForEach ($folder in $functionFolders)
{
    $folderPath = Join-Path -Path $PSScriptRoot -ChildPath $folder

    If (Test-Path -Path $folderPath)
    {
        Write-Verbose -Message "Importing from $folder"
        $functions = Get-ChildItem -Path $folderPath -Filter '*.ps1'
        ForEach ($function in $functions)
        {
            Write-Verbose -Message "  Importing $($function.BaseName)"
            . $($function.FullName)
        }
    }
}
$publicFunctions = (Get-ChildItem -Path "$PSScriptRoot\Public" -Filter '*.ps1').BaseName
Export-ModuleMember -Function $publicFunctions
<#

.ForwardHelpTargetName Set-Location
.ForwardHelpCategory Cmdlet

#>

# Get cdHistory and hydrate a in-memory collection
$global:history = @()
if ((Test-Path -Path $cdHistory)) {
  $global:history += Get-Content -Path $cdHistory -Encoding UTF8 | ? { (-not [String]::IsNullOrWhiteSpace($_)) } | ConvertTo-DirectoryEntry
}

$orig_cd = (Get-Alias -Name 'cd').Definition
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    set-item alias:cd -value $orig_cd
}

#Override the existing CD command with the wrapper in order to log 'cd' commands.
Set-item alias:cd -Value 'cdX'

Set-Alias -Name pushd -Value pushdX -Force -Option AllScope -Scope Global
Set-Alias -Name popd -Value popdX -Force -Option AllScope -Scope Global

Export-ModuleMember -Function z, cdX, pushdX, popdX -Alias cd, pushd

# Tab Completion
$completion_RunningService = {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    $global:history | Sort-Object { $_.Rank } -Descending | Where-Object { $_.Path.Name -like "*$wordToComplete*" } |
        ForEach-Object { New-Object System.Management.Automation.CompletionResult ("'{0}'" -f $_.Path.FullName), $_.Path.FullName, 'ParameterName', ('{0} ({1})' -f $_.Path.Name, $_.Path.FullName) }
}

if (-not $global:options) { $global:options = @{CustomArgumentCompleters = @{};NativeArgumentCompleters = @{}}}

$global:options['CustomArgumentCompleters']['z:JumpPath'] = $Completion_RunningService

$function:tabexpansion2 = $function:tabexpansion2 -replace 'End\r\n{','End { if ($null -ne $options) { $options += $global:options} else {$options = $global:options}'
