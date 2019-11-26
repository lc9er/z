function Get-Frecency($rank, $time) {

    # Last access date/time
    $dx = (Get-Date).Subtract((New-Object System.DateTime -ArgumentList $time)).TotalSeconds

    if( $dx -lt 3600 ) { return $rank*4 }

    if( $dx -lt 86400 ) { return $rank*2 }

    if( $dx -lt 604800 ) { return $rank/2 }

    return $rank/4
}

