function Get-MostRecentDirectoryEntries {

    $mruEntries = (Get-Item -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths | % { $item = $_; $_.GetValueNames() | % { $item.GetValue($_) } })

    $mruEntries | % { ConvertTo-TextualHistoryEntry 1 $_ }
}

