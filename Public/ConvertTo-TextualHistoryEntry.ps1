function ConvertTo-TextualHistoryEntry($rank, $directory, $lastAccessedTicks) {
    if ($lastAccessedTicks -eq $null) {
        $lastAccessedTicks = (Get-Date).Ticks
    }

    (Format-Rank $rank) + $lastAccessedTicks + $directory
}

