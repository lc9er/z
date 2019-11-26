function Format-Rank($rank) {
    return $rank.ToString("000#.00", [System.Globalization.CultureInfo]::InvariantCulture);
}

