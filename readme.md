
## **Custom PowerShell Provider for a Log Drive**

## Overview

This module is a proof-of-concept of a PS Drive used for logging purposes.  
It's meant to be used along side a logging module that will add the logs to this drive,  
in addition to any other sink. So this will be the user-interface that an end-user can  
leverage in order to see their logs.

## Sample Usage

```PowerShell

# load the module
Import-Module C:\CoupaCode\MyGithubRepos\LogProvider\LogProvider.psd1

# create the log drive
New-PSDrive -Name LogDrive -PSProvider SHiPS -Root 'LogProvider#LogRoot'

# add a sample log
$log = [MyLogger.Payload]::new('VERB','This is a test message')
(Get-Item LogDrive:\Logs\VERB).SetContent($log)

# show the logs
Get-ChildItem LogDrive:\
Get-ChildItem LogDrive:\Logs\
Get-ChildItem LogDrive:\Logs\VERB\

<# returns the following:

    Directory: LogDrive:\

ItemType  Name    Count
--------  ----    -----
Folder    Logs    4
Folder    Subs    0

    Directory: LogDrive:\Logs

ItemType  Name    Count  LastMessage
--------  ----    -----  -----------
Folder    ALL     4      15:46:56
Folder    VERB    2      15:46:56
Folder    WARN    1      15:46:49
Folder    INFO    1      15:46:49

ComputerName     Type    Timestamp  Message
------------     ----    ---------  -------
DESKTOP          VERB    15:46:49   Initialize PS Drive
DESKTOP          VERB    15:46:56   This is a test message

#>
```

## Remarks

Unfortunately the module must be loaded first in order for the PS drive to be created afterwards.  
That's because the root of the drive is `<Module_Name>#<Class_Name>` which means you need to have  
the module loaded beforehand in order to use the module's name as part of the root name.

## Run the integration tests

You can also run the integration tests of the module on your own if you like, to make sure everything works as expected.
```PowerShell
$path = 'C:\CoupaCode\MyGithubRepos\LogProvider\LogProvider.tests.ps1'
$test = Invoke-Pester -Path $path -PassThru -Output Detailed
$test | select Result, ExecutedAt, TotalCount
```