function Get-ProviderDrivesRegex([System.Collections.ArrayList] $ProviderDrives) {

    # UNC paths get special treatment. Allows one to 'z foo -ProviderDrives \\' and specify '\\' as the drive.
    if ($ProviderDrives -contains '\\') {
        $ProviderDrives.('\\')
    }

    if ($ProviderDrives.Count -eq 0) {
        '(?i)^(\\{1,2}).*?'
    } else {
        $uncRootPathRegex = '|(\\{1,2})'
        '(?i)^((' + [String]::Concat( ($ProviderDrives | % { $_ + '|' }) ).TrimEnd('|') + '):\\)' + $uncRootPathRegex + '.*?'
    }
}

