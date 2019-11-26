function Save-HistoryEntry($rank, $directory) {
    $entry = ConvertTo-TextualHistoryEntry $rank $directory
    $global:history += ConvertTo-DirectoryEntry $entry
}

