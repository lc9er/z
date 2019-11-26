function GetAllHistoryAsText($history) {
    return $history | ? { $_ -ne $null } | % { ConvertTo-TextualHistoryEntry $_.Rank $_.Path.FullName $_.Time }
}

