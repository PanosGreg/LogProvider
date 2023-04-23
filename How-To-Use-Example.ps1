
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

# try the module

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