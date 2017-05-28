$output = 'C:\MOF'

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName = 'localhost'
            PsDscAllowPlainTextPassword = $true
        }
    )
}

Configuration DSCR_AutoLogon_Example
{
    param
    (
        [Parameter(Mandatory)]
        [PSCredential]
        $AutoLogonCredential
    )

    Import-DscResource -ModuleName DSCR_AutoLogon
    Node localhost
    {
        cAutoLogon AutoLogon_Example
        {
            Ensure = "Present"
            AutoLogonCredential = $AutoLogonCredential
        }
    }
}

DSCR_AutoLogon_Example -OutputPath $output -ConfigurationData $ConfigurationData -AutoLogonCredential (Get-Credential)
#Test-DscConfiguration -Path $output -Verbose
Start-DscConfiguration -Path  $output -Verbose -Wait -Force

