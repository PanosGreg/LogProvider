
# load the module
Import-Module C:\CoupaCode\MyGithubRepos\LogProvider\LogProvider.psd1


# create the log drive
New-PSDrive -Name LogDrive -PSProvider SHiPS -Root 'LogProvider#LogRoot' | Out-Null
$HasDrive = (Get-PSDrive | where Name -eq LogDrive) -as [bool]
if (-not $HasDrive) {throw 'The Log PS Drive was not loaded'}
else                {dir LogDrive:\}


# add a sample log
$log = [MyLogger.Payload]::new('VERB','This is a test message')
(Get-Item LogDrive:\Logs\VERB).SetContent($log)
cd LogDrive:\Logs\VERB\
dir
dir LogDrive:\Logs\



###########################


# another take of the above, but in a shorter manner:

Import-Module C:\CoupaCode\MyGithubRepos\LogProvider\LogProvider.psd1
New-PSDrive -Name LogDrive -PSProvider SHiPS -Root 'LogProvider#LogRoot' | Out-Null
(Get-Item LogDrive:\Logs\VERB).SetContent([MyLogger.Payload]::new('VERB','This is a test message'))

cd LogDrive:\
dir
cd .\Logs\
dir
cd .\VERB\
dir


################################

# run the pester tests

$path = 'C:\CoupaCode\MyGithubRepos\LogProvider\LogProvider.tests.ps1'
Invoke-Pester -Path $path -Output Detailed

##############################

# record a terminalizer demo

terminalizer record .\DemoTest.yml --config .\Terminalizer.config.yml

# Note: I'm using a config file to:
# a) use pwsh instead of powershell (which is the default)
# b) set a max idle time to 400ms, instead of 2sec
# c) set some colors for the console

# playback the recording

terminalizer play .\DemoTest.yml

# Note: you don't need the config file for the playback


# Terminalizer installation notes
<#
terminalizer requires a specific maximum version of node.js.
it can work with up to v12, and it won't work with newer versions.

So here's an example of how you can install both node and terminalizer
using choicolatey
#>
choco install nodejs-lts -y --version=12.22.12
refreshenv

npm install -g terminalizer
refreshenv

# the nodejs version 12.22.12 is the latest LTS as of April 2023
