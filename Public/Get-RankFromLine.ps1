function GetRankFromLine([String]$line) {
    $null = .{ $rankStr = $line.Substring(0, 7) }
    [double]::Parse($rankStr, [Globalization.CultureInfo]::InvariantCulture)
}

