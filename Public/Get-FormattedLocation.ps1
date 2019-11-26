function Get-FormattedLocation() {
    if ((Get-Location).Provider.ImplementingType.Name -eq 'FileSystemProvider' -and (Get-Location).Path.Contains('FileSystem::\\')) {
        Get-Location | select -ExpandProperty ProviderPath # The registry provider does return a path which z understands. In other words, I'm too lazy.
    } else {
        Get-Location | select -ExpandProperty Path
    }
}

