function pushdX
{
    [CmdletBinding(DefaultParameterSetName='Path', SupportsTransactions=$true, HelpUri='http://go.microsoft.com/fwlink/?LinkID=113370')]
    param(
        [Parameter(ParameterSetName='Path', Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [string]
        ${Path},

        [Parameter(ParameterSetName='LiteralPath', ValueFromPipelineByPropertyName=$true)]
        [Alias('PSPath')]
        [string]
        ${LiteralPath},

        [switch]
        ${PassThru},

        [Parameter(ValueFromPipelineByPropertyName=$true)]
        [string]
        ${StackName})

    begin
    {
        try {
            $outBuffer = $null
            if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer))
            {
                $PSBoundParameters['OutBuffer'] = 1
            }
            $wrappedCmd = $ExecutionContext.InvokeCommand.GetCommand('Push-Location', [System.Management.Automation.CommandTypes]::Cmdlet)
            $scriptCmd = {& $wrappedCmd @PSBoundParameters }
            $steppablePipeline = $scriptCmd.GetSteppablePipeline($myInvocation.CommandOrigin)
            $steppablePipeline.Begin($PSCmdlet)
        } catch {
            throw
        }
    }

    process
    {
        try {
            $steppablePipeline.Process($_)
            Save-CdCommandHistory # Build up the DB.
        } catch {
            throw
        }
    }

    end
    {
        try {
            $steppablePipeline.End()
        } catch {
            throw
        }
    }
}

