function Get-CurrentSessionProviderDrives([System.Collections.ArrayList] $ProviderDrives) {

    if ($ProviderDrives -ne $null -and $ProviderDrives.Length -gt 0) {
        Get-ProviderDrivesRegex $ProviderDrives
    } else {

        # The FileSystemProvider supports \\ and X:\ paths.
        # An ideal solution would be to ask the provider if a path is supported.
        # Supports drives such as C:\ and also UNC \\
        if ((Get-Location).Provider.ImplementingType.Name -eq 'FileSystemProvider') {
            '(?i)^(((' + [String]::Concat( ((Get-Location).Provider.Drives.Name | % { $_ + '|' }) ).TrimEnd('|') + '):\\)|(\\{1,2})).*?'
        } else {
            Get-ProviderDrivesRegex (Get-Location).Provider.Drives
        }
    }
}

