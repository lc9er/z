function ConvertTo-DirectoryEntry {
    Param(
        [Parameter(
        Position=0,
        Mandatory=$true,
        ValueFromPipeline=$true,
        ValueFromPipelineByPropertyName=$true)]
        [String]$line
    )

    Process {

        $null = .{

            $pathValue = $line.Substring(25)

            try {
                $fileName = [System.IO.Path]::GetFileName($pathValue);

                # GetFileName() does not work with registry paths
                if ($fileName -eq '') {
                    $lastPathSeparator = $pathValue.LastIndexOf('\');
                    if ($lastPathSeparator -ge 0) {
                        $pathValue = $pathValue.TrimEnd('\');
                        $fileName = $pathValue.Substring( + 1);
                    }
                }
            } catch [System.ArgumentException] { }

            $time = [long]::Parse($line.Substring(7, 18), [Globalization.CultureInfo]::InvariantCulture)
        }

        @{
          Rank=GetRankFromLine $line;
          Time=$time;
          Path=@{ Name = $fileName; FullName = $pathValue };
          Age=(Get-Date).Subtract((New-Object System.DateTime -ArgumentList $time)).TotalSeconds;
        }
    }
}

