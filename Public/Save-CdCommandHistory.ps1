function Save-CdCommandHistory($removeCurrentDirectory = $false) {

    $currentDirectory = Get-FormattedLocation

    try {

        $foundDirectory = $false
        $runningTotal = 0

        for($i = 0; $i -lt $global:history.Length; $i++) {

            $line = $global:history[$i]

            $canIncreaseRank = $true;

            $rank = $line.Rank;

            if (-not $foundDirectory) {

                $rank = $line.Rank

                if ($line.Path.FullName -eq $currentDirectory) {

                    $foundDirectory = $true

                    if ($removeCurrentDirectory) {
                        $canIncreaseRank = $false
                        $global:history[$i] = $null
                        Write-Host "Removed entry $currentDirectory" -ForegroundColor Green

                    } else {
                        $rank++
                        Update-HistoryEntryUsageTime $global:history[$i]
                    }
                }
            }

            if ($canIncreaseRank) {
                $runningTotal += $rank
            }
        }

        if (-not $foundDirectory -and $removeCurrentDirectory) {
            Write-Host "Current directory not found in CD history data file" -ForegroundColor Red
        } else {

            if (-not $foundDirectory) {
                Save-HistoryEntry 1 $currentDirectory
                $runningTotal += 1
            }
            Remove-Old-History
        }

        WriteHistoryToDisk

    } catch {
        Write-Host $_.Exception.ToString() -ForegroundColor Red
    }
}

