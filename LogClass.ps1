
Add-Type -Path $PSScriptRoot\LogClass.cs

$HasClass = [bool]('MyLogger.Payload' -as [type])
if (-not $HasClass) {throw 'Could not load MyLogger.Payload class'}
