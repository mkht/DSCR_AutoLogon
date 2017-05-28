DSCR_AutoLogon
====

PowerShell DSC Resource to turn on / off automatic logon in Windows.

## Install
You can install Resource through [PowerShell Gallery](https://www.powershellgallery.com/packages/DSCR_AutoLogon/).
```Powershell
Install-Module -Name DSCR_AutoLogon
```

## Resources
* **cAutoLogon**
PowerShell DSC Resource to turn on / off automatic logon in Windows.

## Properties

+ **[string] Ensure** (Key):
    + Specifies enable or disable automatic logon.
    + This is Key property. You need to specify this. { Present | Absent }

+ **[PSCredential] AutoLogonCredential** (Required):
    + The credential for logon in Windows.

+ **[Boolean] Encrypt** (Write):
    + Specifies whether or not the password should be encrypted. If the value is $false, The password is saved in the registry as plain text.
    + The default value is $false.

## Examples
Please look in the [Example](https://github.com/mkht/DSCR_AutoLogon/tree/master/Example) folder.

## ChangeLog
### 2.0.0
+ Supports password encryption
+ Change resource type from composite to MOF-based.
+ [Breaking change] The "Ensure" property is now mandatory.
