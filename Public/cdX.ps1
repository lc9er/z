# A wrapper function around the existing Set-Location Cmdlet.
function cdX
{
    [CmdletBinding(DefaultParameterSetName='Path', SupportsTransactions=$true, HelpUri='http://go.microsoft.com/fwlink/?LinkID=113397')]
    param(
        [Parameter(ParameterSetName='Path', Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        ${Path},

        [Parameter(ParameterSetName='LiteralPath', Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias('PSPath')]
        [string]
        ${LiteralPath},

        [switch]
        ${PassThru},

        [Parameter(ParameterSetName='Stack', ValueFromPipelineByPropertyName=$true)]
        [string]
        ${StackName})

    begin
    {
        $outBuffer = $null
        if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
        {
            $PSBoundParameters['OutBuffer'] = 1
        }

        $PSBoundParameters['ErrorAction'] = 'Stop'

        $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Set-Location', [System.Management.Automation.CommandTypes]::Cmdlet)
        $scriptCmd = {& $wrappedCmd @PSBoundParameters }

        $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
        $steppablePipeline.Begin($PSCmdlet)
    }

    process
    {
        $steppablePipeline.Process($_)

        Save-CdCommandHistory # Build up the DB.
    }

    end
    {
        $steppablePipeline.End()
    }
}

