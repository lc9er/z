function Get-ArgsFilter {
    Param(
        [Parameter(ValueFromPipeline=$true)]
        [Hashtable]$historyEntry,

        [string]
        $Option = 'Frecency'
    )

    Process {

        if ($Option -in ('Frecency', 'F')) {
            $_['Score'] = (Get-Frecency $_.Rank $_.Time);
        } elseif ($Option -in ('Time', 'T')) {
            $_['Score'] = $_.Time;
        } elseif ($Option -in ('Rank', 'R')) {
            $_['Score'] = $_.Rank;
        }

        return $_;
    }
}

