
# load the module
  Import-Module C:\CoupaCode\MyGithubRepos\LogProvider\LogProvider.psd1

# create the log drive
  New-PSDrive -Name Log -PSProvider SHiPS -Root 'LogProvider#LogRoot'

# add a sample log  (2 ways to do that)
  $log = [MyLogger.Payload]::new('VERB','This is a test message')
  
  # via the .SetContent() method
  (Get-Item Log:\Logs\VERB).SetContent($log)
  
  # via the Set-Content function
  # But the value needs to be a string, so I serialize the object in json
  $val = $log | ConvertTo-Json
  Set-Content Log:\Logs\VERB $val
  
# see the results
  cd Log:\
  dir
  cd .\Logs\
  dir
  cd .\VERB\
  dir
  cd c:


###########################


# another take of the above, but in a shorter manner:

Import-Module C:\CoupaCode\MyGithubRepos\LogProvider\LogProvider.psd1
New-PSDrive -Name Log -PSProvider SHiPS -Root 'LogProvider#LogRoot' | Out-Null
$log = [MyLogger.Payload]::new('VERB','test message')
$val = $log | ConvertTo-Json
(Get-Item Log:\Logs\VERB).SetContent($log)
Set-Content Log:\Logs\VERB $val

cd Log:\
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

# Note: the config file is actually optional
#       but I'm using a config file to:
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
using chocolatey
#>
choco install nodejs-lts -y --version=12.22.12
refreshenv

npm install -g terminalizer
refreshenv

# the nodejs version 12.22.12 is the latest LTS for v12 as of April 2023
