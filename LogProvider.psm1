
# this variable will be our storage that will hold all of the logs
[Hashtable]$Global:_DriveLogs = [ordered]@{}

$Types = [System.Enum]::GetNames([MyLogger.LogType])
foreach ($TypeName in $Types) {
    $List = [System.Collections.Generic.List[MyLogger.Payload]]::new()
    $List.Add([MyLogger.Payload]::new($TypeName,'Initialize PS Drive'))
    $Global:_DriveLogs.Add($TypeName,$List)
}


class LogStream : Microsoft.PowerShell.SHiPS.SHiPSDirectory {

    [int]$Count
    [datetime]$LastMessage

    # constructors
    LogStream ([string]$name) : base ($name) {
        $this.Count = $Global:_DriveLogs[$this.name].Count
        $this.LastMessage = $Global:_DriveLogs[$this.name].Timestamp[-1]
    }

    [object[]] GetChildItem() {return $Global:_DriveLogs[$this.name]}

    [void] SetContent([MyLogger.Payload]$log) {
        $Global:_DriveLogs[$this.name].Add($log)
    }

} #LogStream

[Microsoft.PowerShell.SHiPS.SHiPSProvider(UseCache=$false)]
class LogRoot : Microsoft.PowerShell.SHiPS.SHiPSDirectory {
    # constructor
    LogRoot([string]$name): base($name) {}

    [object[]] GetChildItem() {        
        $List  = [System.Collections.Generic.List[LogStream]]::new()
        $Types = [System.Enum]::GetNames([MyLogger.LogType])
            
        foreach ($LogType in $Types) {
            $List.Add([LogStream]::new($LogType))
        }
        return $List.ToArray()
    }

} #LogRoot

## TODO: add another folder for Event Subscribers and put the streams in a separate folder
