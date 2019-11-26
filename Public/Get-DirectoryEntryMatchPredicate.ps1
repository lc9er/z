function Get-DirectoryEntryMatchPredicate {
    Param(
        [Parameter(
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true)]
        $Path,

        [Parameter(
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true)]
        [string] $JumpPath,

        $ProviderRegex
    )

    if ($Path -ne $null) {

        $null = .{
            $providerMatches = [System.Text.RegularExpressions.Regex]::Match($Path.FullName, $ProviderRegex).Success
        }

        if ($providerMatches) {

            # Allows matching of entire names. Remove the first two characters, added by PowerShell when the user presses the TAB key.
            if ($JumpPath.StartsWith('.\')) {
                $JumpPath = $JumpPath.Substring(2).TrimEnd('\')
            }

            [System.Text.RegularExpressions.Regex]::Match($Path.Name, [System.Text.RegularExpressions.Regex]::Escape($JumpPath), [System.Text.RegularExpressions.RegexOptions]::IgnoreCase).Success
        }
    }
}

