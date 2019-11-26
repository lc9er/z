<#

.SYNOPSIS

   Tracks your most used directories, based on 'frecency'. This is done by storing your CD command history and ranking it over time.

.DESCRIPTION

    After  a  short  learning  phase, z will take you to the most 'frecent'
    directory that matches the regex given on the command line.

.PARAMETER JumpPath

A un-escaped regular expression of the directory name to jump to. Character escaping will be done internally.

.PARAMETER Option

Frecency - Match by frecency (default)
Rank - Match by rank only
Time - Match by recent access only

.PARAMETER OnlyCurrentDirectory

Restrict matches to subdirectories of the current directory

.PARAMETER Listfiles

List only, don't navigate to the directory

.PARAMETER $Remove

Remove the current directory from the datafile

.PARAMETER $Clean

Clean up all history entries that cannot be resolved

.NOTES

Current PowerShell implementation is very crude and does not yet support all of the options of the original z bash script.
Although tracking of frequently used directories is obtained through the continued use of the "cd" command, the Windows registry is also scanned for frequently accessed paths.

.LINK

   https://github.com/vincpa/z

.EXAMPLE

CD to the most frecent directory matching 'foo'

z foo

.EXAMPLE

CD to the most recently accessed directory matching 'foo'

z foo -o Time

#>
function z {
    param(
    [Parameter(Position=0)]
    [string]
    ${JumpPath},

    [ValidateSet("Time", "T", "Frecency", "F", "Rank", "R")]
    [Alias('o')]
    [string]
    $Option = 'Frecency',

    [Alias('c')]
    [switch]
    $OnlyCurrentDirectory = $null,

    [Alias('l')]
    [switch]
    $ListFiles = $null,

    [Alias('x')]
    [switch]
  $Remove = $null,

  [Alias('d')]
  [switch]
  $Clean = $null
)

    if (((-not $Clean) -and (-not $Remove) -and (-not $ListFiles)) -and [string]::IsNullOrWhiteSpace($JumpPath)) { Get-Help z; return; }

    # If a valid path is passed in to z, treat it like the normal cd command
    if (-not [string]::IsNullOrWhiteSpace($JumpPath) -and (Test-Path $JumpPath)) {
        cdX $JumpPath
        return;
    }

    if ((Test-Path $cdHistory)) {
        if ($Remove) {
        Save-CdCommandHistory $Remove
        } elseif ($Clean) {
            Cleanup-CdCommandHistory
        } else {

            # This causes conflicts with the -Remove parameter. Not sure whether to remove registry entry.
            #$mruList = Get-MostRecentDirectoryEntries

            $providerRegex = $null

            If ($OnlyCurrentDirectory) {
                $providerRegex = (Get-FormattedLocation).replace('\','\\') + '\\.*?'
            } else {
                $providerRegex = Get-CurrentSessionProviderDrives ((Get-PSProvider).Drives | select -ExpandProperty Name)
            }

            $list = @()

            $global:history |
                ? { Get-DirectoryEntryMatchPredicate -path $_.Path -jumpPath $JumpPath -ProviderRegex $providerRegex } | Get-ArgsFilter -Option $Option |
                % { if ($ListFiles -or (Test-Path $_.Path.FullName)) {$list += $_} }

            if ($ListFiles) {

                $newList = $list | % { New-Object PSObject -Property  @{Rank = $_.Rank; Path = $_.Path.FullName; LastAccessed = [DateTime]$_.Time } }
                Format-Table -InputObject $newList -AutoSize

            } else {

                if ($list.Length -eq 0) {
                    # It's not found in the history file, perhaps it's still a valid directory. Let's check.
                    if ((Test-Path $JumpPath)) {
                        cdX $JumpPath
                    } else {
					    Write-Host "$JumpPath Not found"
                    }

                } else {
                    if ($list.Length -gt 1) {
                        $entry = $list | Sort-Object -Descending { $_.Score } | select -First 1

                    } else {
                        $entry = $list[0]
                    }

                    Set-Location $entry.Path.FullName
                    Save-CdCommandHistory $Remove
                }
            }
        }
    } else {
        Save-CdCommandHistory $Remove
    }
}


