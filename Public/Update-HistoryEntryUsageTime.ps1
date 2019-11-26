function Update-HistoryEntryUsageTime($historyEntry) {
    $historyEntry.Rank++
    $historyEntry.Time = (Get-Date).Ticks
}

