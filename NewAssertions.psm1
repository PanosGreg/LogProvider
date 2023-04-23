#Requires -Modules @{ModuleName='Pester'; ModuleVersion='5.0.0'}

function Should-HavePropertyName ($ActualValue, [string[]]$ExpectedValue, [switch]$Negate, [string]$Because) {
<#
.SYNOPSIS
    Checks provided object(s) for specific property (or properties)
.EXAMPLE
    Get-Service LanmanServer,LanmanWorkstation | Should -HavePropertyName StartupType

    Checks if a service has the StartupType property. This should pass.
.EXAMPLE
    Get-Service LanmanServer,LanmanWorkstation | Should -Not -HavePropertyName State

    Checks if a service does NOT have the State property. This should pass, there's no such property.
#>

    $ActualValName   = ($ActualValue | foreach {$_.ToString()}) -join ','
    $ExpectedValName = $ExpectedValue -join ','

    $Results = foreach ($Value in $ActualValue) {
        $AllProps = ($Value | Get-Member -MemberType Properties).Name
        foreach ($Expected in $ExpectedValue) {
            $HasProperty = $AllProps -contains $Expected
            Write-Output $HasProperty
            if (-not $HasProperty) {
                $ActualValName   = $Value.ToString()
                $ExpectedValName = $Expected
                break
            }
        }
    }
    $Succeeded = $Results -notcontains $false
    
    if ($Negate) {$Succeeded = -not $Succeeded}


    if (-not $Succeeded) {
        if ($Negate) {
            $FailureMessage = "Expected '$ActualValName' has a $ExpectedValName property$(if($Because) { " because $Because"})."
        }
        else {
            $FailureMessage = "Expected '$ActualValName' does not have a $ExpectedValName property$(if($Because) { " because $Because"})."
        }
    }

    return [pscustomobject]@{
        Succeeded      = $Succeeded
        FailureMessage = $FailureMessage
    }
}

# add assertion into "Should" command
$params = @{
    Name               = 'HavePropertyName'
    InternalName       = 'Should-HavePropertyName'
    Test               = ${function:Should-HavePropertyName}
    SupportsArrayInput = $true
}
Add-ShouldOperator @params