Configuration cAutoLogon
{
   Param (
      [Parameter(Mandatory)]
      [PSCredential] $AutoLogonCredential,

      [Parameter()]
      [ValidateSet("Present","Absent")]
      [String]$Ensure = "Present"
   )

   $Key = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'

   #Get the default domain name from the credential object
   if ($AutoLogonCredential.GetNetworkCredential().Domain){
       $DefaultDomainName = $AutoLogonCredential.GetNetworkCredential().Domain
   }
   elseif((Get-WMIObject Win32_ComputerSystem).PartOfDomain){
       $DefaultDomainName = "."
   }
   else{
       $DefaultDomainName = ""
   }

   Registry DefaultDomainName
   {
      Ensure = $Ensure
      Key = $Key
      ValueName = 'DefaultDomainName'
      ValueData = $DefaultDomainName
   }

   Registry DefaultUserName
   {
      Ensure = $Ensure
      Key = $Key
      ValueName = 'DefaultUserName'
      ValueData = $AutoLogonCredential.GetNetworkCredential().UserName
   }

   Registry DefaultPassword
   {
      Ensure = $Ensure
      Key = $Key
      ValueName = 'DefaultPassword'
      ValueData = $AutoLogonCredential.GetNetworkCredential().Password
   }

   Registry AutoAdminLogon
   {
       Ensure = $Ensure
       Key = $Key
       ValueName = 'AutoAdminLogon'
       ValueData = 1
   }
}
