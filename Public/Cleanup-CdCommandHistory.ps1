function Cleanup-CdCommandHistory() {

    try {

        for($i = 0; $i -lt $global:history.Length; $i++) {

            $line = $global:history[$i]

            if ($line -ne $null) {
                $testDir = $line.Path.FullName
                if (-not [string]::IsNullOrWhiteSpace($testDir) -and !(Test-Path $testDir)) {
                    $global:history[$i] = $null
                    Write-Host "Removed inaccessible path $testDir" -ForegroundColor Yellow
                }
            }
        }
        Remove-Old-History
        WriteHistoryToDisk
    } catch {
        Write-Host $_.Exception.ToString() -ForegroundColor Red
    }
}


