<#
.SYNOPSIS
    Basic integration tests of the custom PS provider for the Log drive
#>

BeforeDiscovery {
    # Load and register my custom assertion, "HavePropertyName"
    Import-Module "$PSScriptRoot\NewAssertions.psm1" -DisableNameChecking
}

BeforeAll {
    # load the module
    Import-Module $PSScriptRoot\LogProvider.psd1
}

Describe 'LogDrive' {
    BeforeAll {
        # Create the PS drive
        New-PSDrive -Name LogDrive -PSProvider SHiPS -Root 'LogProvider#LogRoot' | Out-Null
    }
    Context 'Basic PS Drive functionality' {
        It 'Creates a PS Drive' {
            [bool](Get-PSDrive | where Name -eq LogDrive) | Should -Be $true
        }
        It 'Sets the root to the "module_name#class_name" format' {
            (Get-PSDrive LogDrive).Root | Should -Be 'LogProvider#LogRoot'
        }
    }
    Context 'Root folder' {
        It 'Can access the Root of the Log drive' {
            {dir LogDrive:\} | Should -Not -Throw
        }
        It 'Finds a "<Folder>" item in the root drive' -ForEach @(
            @{Folder = 'Logs'}
            @{Folder = 'Subs'}
        ) {
            (dir LogDrive:\).Name | Should -Contain $Folder
            {Get-Item LogDrive:\$Folder\} | Should -Not -Throw            
        }
        It 'Confirms that the <_> item is a folder' -ForEach 'Logs','Subs' {
            (Get-Item LogDrive:\$_\).SSItemMode | Should -Be '+'
        }
    }
    Context 'Logs subfolder' {
        It 'Can access the Logs subfolder' {
            {dir LogDrive:\Logs} | Should -Not -Throw
        }
        It 'Finds the item "<_>" in the logs subfolder' -ForEach @(
            'ALL','VERB','WARN','INFO'
        ) {
            (dir LogDrive:\Logs\).Name | Should -Contain $_
        }
        It 'Confirms that all items are folders'{
            dir LogDrive:\Logs | foreach {$_.SSItemMode | Should -Be '+'}
        }
        It 'Confirms that all items have the Count & the LastMessage property' {
            dir LogDrive:\Logs | Should -HavePropertyName Count,LastMessage
        }
    }
    Context 'Add logs to the drive' {
        It 'Adds a log to the <_> folder' -ForEach 'VERB','WARN','INFO' {
            # use the .SetContent() method to add a log
        }
        It 'Increments the log count' {
            # check the count property after you add a log
        }
}