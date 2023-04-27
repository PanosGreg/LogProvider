using namespace System.Collections.Generic

# these global variables will be our storage that will hold all of the logs and subscribers
[Hashtable]$Global:_DriveLogs = [ordered]@{}
$SubList = [List[System.Management.Automation.PSEventSubscriber]]::new()
[List[System.Management.Automation.PSEventSubscriber]]$Global:_DriveSubs = $SubList

# add a Key in the hashtable for each Log type
$Types = [System.Enum]::GetNames([MyLogger.LogType])
foreach ($TypeName in $Types) {
    $List = [List[MyLogger.Payload]]::new()
    $List.Add([MyLogger.Payload]::new($TypeName,'Initialize PS Drive'))
    $Global:_DriveLogs.Add($TypeName,$List)
}


class LogStream : Microsoft.PowerShell.SHiPS.SHiPSDirectory {

    [int]$Count
    [datetime]$LastMessage

    # constructors
    LogStream ([string]$name) : base ($name) {
        if ($this.name -eq 'ALL') {
            $All = $Global:_DriveLogs.Values.ToArray()
            [array]::Sort($All.Timestamp,$All)
            $this.Count = $All.Count
            $this.LastMessage = $All.Timestamp[-1]
        }
        else {
            $this.Count = $Global:_DriveLogs[$this.name].Count
            $this.LastMessage = $Global:_DriveLogs[$this.name].Timestamp[-1]
        }
    }

    [object[]] GetChildItem() {
        if ($this.name -eq 'ALL') {
            $List = [System.Collections.Generic.List[MyLogger.Payload]]::new()
            $List.AddRange([MyLogger.Payload[]]$Global:_DriveLogs.Values.ForEach({$_}))
            $List.Sort([MyLogger.PayloadComparer]::new())
            return $List.ToArray()
        } #if ALL
        else {
            return $Global:_DriveLogs[$this.name].ToArray()
        }
    }

    [void] SetContent([MyLogger.Payload]$log) {
        $Global:_DriveLogs[$this.name].Add($log)
    }

} #LogStream

[Microsoft.PowerShell.SHiPS.SHiPSProvider(UseCache=$false)]
class LogSubscriber : Microsoft.PowerShell.SHiPS.SHiPSDirectory {

    [int]$Count

    # constructors
    LogSubscriber ([string]$name) : base ($name) {
        $this.Count = $Global:_DriveSubs.Count
    }

    [object[]] GetChildItem() {return $Global:_DriveSubs}

    [void] SetContent([System.Management.Automation.PSEventSubscriber]$sub) {
        $Global:_DriveSubs.Add($sub)
    }
} #LogSubscriber

[Microsoft.PowerShell.SHiPS.SHiPSProvider(UseCache=$false)]
class LogStreamFolder : Microsoft.PowerShell.SHiPS.SHiPSDirectory {

    [int]$Count

    # constructors
    LogStreamFolder ([string]$name) : base ($name) {
        $Types = [System.Enum]::GetNames([MyLogger.LogType])
        $Sum   = ($Types | foreach {$Global:_DriveLogs[$_].Count} | Measure-Object -Sum).Sum
        $this.Count = $Sum
    }

    [object[]] GetChildItem() {        
        $List  = [System.Collections.Generic.List[LogStream]]::new()
        $Types = [System.Enum]::GetNames([MyLogger.LogType])

        $List.Add([LogStream]::new('ALL'))    
        foreach ($LogType in $Types) {
            $List.Add([LogStream]::new($LogType))
        }
        
        return $List.ToArray()
    }
} #LogStreamFolder

[Microsoft.PowerShell.SHiPS.SHiPSProvider(UseCache=$false)]
class LogRoot : Microsoft.PowerShell.SHiPS.SHiPSDirectory {
    # constructor
    LogRoot([string]$name): base($name) {}

    [object[]] GetChildItem() {        
        $Array = @(
            [LogStreamFolder]::new('Logs')
            [LogSubscriber]::new('Subs')
        )

        return $Array
    }

} #LogRoot
