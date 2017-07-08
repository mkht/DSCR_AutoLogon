$errorActionPreference = 'Stop'

$script:RootFolderFilePath = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
$script:LsaUtilPath = Join-Path -Path $script:RootFolderFilePath -ChildPath '\Utils\LSAUtil.ps1'
$script:FunctionsPath = Join-Path -Path $script:RootFolderFilePath -ChildPath '\functions\AutoLogon.ps1'
. $FunctionsPath
. $LsaUtilPath

$script:WinLogonKey = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'

function Get-TargetResource {
    [CmdletBinding()]
    [OutputType([Hashtable])]
    param
    (
        [parameter(Mandatory)]
        [ValidateSet("Present", "Absent")]
        [String]
        $Ensure = 'Present',

        [parameter(Mandatory)]
        [PSCredential]
        $AutoLogonCredential,

        [parameter()]
        [bool]
        $Encrypt = $false
    )

    $private:GetRes = @{
        Ensure              = 'Absent'
        AutoLogonCredential = $null
        Encrypt             = $false
        Username            = ''
        Domain              = ''
    }

    $private:Password = $null

    $private:WinLogonParam = Get-ItemProperty -Path $WinLogonKey

    if (-not $WinLogonParam) {
        Write-Error ("'Winlogon' registry key not found.")
        return
    }

    if ((-not $WinLogonParam.AutoAdminLogon) -or ($WinLogonParam.AutoAdminLogon -ne 1)) {
        Write-Verbose ('Auto logon is disabled')
        $GetRes.Ensure = 'Absent'
    }
    else {
        Write-Verbose ('Auto logon is enabled')
        $GetRes.Ensure = 'Present'

        $GetRes.Username = $WinLogonParam.DefaultUserName
        $GetRes.Domain = $WinLogonParam.DefaultDomainName
        if ($WinLogonParam.DefaultPassword) {
            Write-Verbose ('Password is not encrypted')
            $GetRes.Encrypt = $false
            $Password = $WinLogonParam.DefaultPassword
        }
        else {
            $private:LsaUtil = New-Object PInvoke.LSAUtil.LSAutil -ArgumentList "DefaultPassword"
            $private:EncryptedPassword = $LsaUtil.GetSecret()
            if ($EncryptedPassword) {
                Write-Verbose ('Password is encrypted')
                $GetRes.Encrypt = $true
                $Password = $EncryptedPassword
            }
            else {
                $GetRes.Encrypt = $false
                $Password = ''
            }
        }
    }

    if ($Password -and $GetRes.Username) {
        if ($GetRes.Domain) {
            $Fullname = ('{0}\{1}' -f $GetRes.Domain, $GetRes.Username)
        }
        else {
            $Fullname = $GetRes.Username
        }

        #$SecPwd = ConvertTo-SecureString -String $Password -AsPlainText -Force
        $SecPwd = New-Object System.Security.SecureString
        $Password.ToCharArray() | % {$SecPwd.AppendChar($_)}    # Workaround for PSScriptAnalyzer issue
        $GetRes.AutoLogonCredential = New-Object System.Management.Automation.PSCredential $Fullname, $SecPwd
    }

    $GetRes
} # end of Get-TargetResource


function Test-TargetResource {
    [CmdletBinding()]
    [OutputType([Boolean])]
    param
    (
        [parameter(Mandatory)]
        [ValidateSet("Present", "Absent")]
        [String]
        $Ensure = 'Present',

        [parameter(Mandatory)]
        [PSCredential]
        $AutoLogonCredential,

        [parameter()]
        [bool]
        $Encrypt = $false
    )

    $private:GetParam = @{
        Ensure              = $Ensure
        AutoLogonCredential = $AutoLogonCredential
        Encrypt             = $Encrypt
    }

    $GetRes = Get-TargetResource @GetParam

    if ($Ensure -eq 'Absent') {
        switch ($GetRes.Ensure) {
            'Absent' {
                Write-Verbose ('Auto logon is already disabled. Nothing need to do')
                return $true
            }
            'Present' {
                Write-Verbose ('Auto logon is currenly enabled. It is necessary to change the settings')
                return $false
            }
            Default {
                Write-Error 'Test failed (unexpected error)'
            }
        }
    }
    else {
        switch ($GetRes.Ensure) {
            'Absent' {
                Write-Verbose ('Auto logon is currenly disabled. It is necessary to change the settings')
                return $false
            }
            'Present' {

                if ($AutoLogonCredential.GetNetworkCredential().Password -ne $GetRes.AutoLogonCredential.GetNetworkCredential().Password) {
                    Write-Verbose ('Password is not match')
                    return $false
                }
                elseif ($Encrypt -ne $GetRes.Encrypt) {
                    Write-Verbose ('Password encrypt status is not match')
                    return $false
                }

                if ($AutoLogonCredential.GetNetworkCredential().UserName -ne $GetRes.Username) {
                    Write-Verbose ('Username is not match')
                    return $false
                }

                if ($AutoLogonCredential.GetNetworkCredential().Domain -ne $GetRes.Domain) {
                    if (-not $AutoLogonCredential.GetNetworkCredential().Domain) {
                        if ($GetRes.Domain -and ($GetRes.Domain -ne '.')) {
                            Write-Verbose ('Domain is not match')
                            return $false
                        }
                    }
                    else {
                        Write-Verbose ('Domain is not match')
                        return $false
                    }
                }

                Write-Verbose ('Match desired state & current state. Nothing need to do')
                return $true
            }
            Default {
                Write-Error 'Test failed (unexpected error)'
            }
        }
    }
} # end of Test-TargetResource

function Set-TargetResource {
    [CmdletBinding()]
    param
    (
        [parameter(Mandatory)]
        [ValidateSet("Present", "Absent")]
        [String]
        $Ensure = 'Present',

        [parameter(Mandatory)]
        [PSCredential]
        $AutoLogonCredential,

        [parameter()]
        [bool]
        $Encrypt = $false
    )

    if ($Ensure -eq 'Absent') {
        Disable-AutoLogon
    }
    else {
        Set-AutoLogon -Credential $AutoLogonCredential -Encrypt $Encrypt
    }
} # end of Set-TargetResource

Export-ModuleMember -Function *-TargetResource