
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