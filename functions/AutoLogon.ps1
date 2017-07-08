$script:RootFolderFilePath = Split-Path -Path $PSScriptRoot -Parent
$script:LsaUtilPath = Join-Path -Path $script:RootFolderFilePath -ChildPath '\Utils\LSAUtil.ps1'
if (Test-Path $LsaUtilPath) {
    # Load LSA module
    . $LsaUtilPath
}

$script:WinLogonKey = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'

function Set-AutoLogon {
    [CmdletBinding(SupportsShouldProcess)]
    param
    (
        [parameter(Mandatory, ValueFromPipeline, Position = 0)]
        [PSCredential]
        $Credential,

        [parameter()]
        [bool]
        $Encrypt = $false
    )

    if ($Credential.GetNetworkCredential().Domain) {
        $DefaultDomainName = $Credential.GetNetworkCredential().Domain
    }
    elseif ((Get-WMIObject Win32_ComputerSystem).PartOfDomain) {
        $DefaultDomainName = "."
    }
    else {
        $DefaultDomainName = ""
    }

    if ($PSCmdlet.ShouldProcess(('User "{0}\{1}"' -f $DefaultDomainName, $Credential.GetNetworkCredential().UserName), "Set Auto logon")) {
        Write-Verbose ('DomainName: {0} / UserName: {1}' -f $DefaultDomainName, $Credential.GetNetworkCredential().UserName)
        Set-ItemProperty -Path $WinLogonKey -Name "AutoAdminLogon" -Value 1
        Set-ItemProperty -Path $WinLogonKey -Name "DefaultDomainName" -Value $DefaultDomainName
        Set-ItemProperty -Path $WinLogonKey -Name "DefaultUserName" -Value $Credential.GetNetworkCredential().UserName
        Remove-ItemProperty -Path $WinLogonKey -Name "AutoLogonCount" -ErrorAction SilentlyContinue

        if ($Encrypt) {
            Write-Verbose ('Password will be encrypted')
            Remove-ItemProperty -Path $WinLogonKey -Name "DefaultPassword" -ErrorAction SilentlyContinue
            $private:LsaUtil = New-Object PInvoke.LSAUtil.LSAutil -ArgumentList "DefaultPassword"
            $LsaUtil.SetSecret($Credential.GetNetworkCredential().Password)
        }
        else {
            Write-Verbose ('Password will be saved as plain text')
            Set-ItemProperty -Path $WinLogonKey -Name "DefaultPassword" -Value $Credential.GetNetworkCredential().Password
        }

        Write-Verbose ('Auto logon has been enabled')
    }
}

function Disable-AutoLogon {
    [CmdletBinding(SupportsShouldProcess)]
    param ()

    if ($PSCmdlet.ShouldProcess('Disable Auto logon')) {
        Set-ItemProperty -Path $WinLogonKey -Name "AutoAdminLogon" -Value 0
        Remove-ItemProperty -Path $WinLogonKey -Name "DefaultPassword" -ErrorAction SilentlyContinue
        $private:LsaUtil = New-Object PInvoke.LSAUtil.LSAutil -ArgumentList "DefaultPassword"
        if ($LsaUtil.GetSecret()) {
            $LsaUtil.SetSecret($null)   #Clear existing password
        }
        Write-Verbose ('Auto logon has been disabled')
    }
}
