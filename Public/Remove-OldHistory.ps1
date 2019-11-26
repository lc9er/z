function Remove-Old-History() {
    if ($global:history.Length -gt 1000) {
        $global:history | ? { $_ -ne $null } | % {$i = 0} {

            $lineObj = $_
            $lineObj.Rank = $lineObj.Rank * 0.99

            # If it's been accessed in the last 14 days it can stay
            # or
            # If it's rank is greater than 20 and been accessed in the last 30 days it can stay
            if ($lineObj.Age -lt 1209600 -or ($lineObj.Rank -ge 5 -and $lineObj.Age -lt 2592000)) {
              #$global:history[$i] = ConvertTo-DirectoryEntry (ConvertTo-TextualHistoryEntry $lineObj.Rank $lineObj.Path.FullName $lineObj.Time)
            } else {
              Write-Host "Removing old item: Rank:" $lineObj.Rank "Age:" ($lineObj.Age/60/60) "Path:" $lineObj.Path.FullName -ForegroundColor Yellow
              $global:history[$i] = $null
            }
            $i++;
        }
    }
}


