DSCR_AutoLogon
====

PowerShell DSC Resource to turn on / off automatic logon in Windows.

## Install
Not Ready yet.

## Resources
* **cAutoLogon**
PowerShell DSC Resource to turn on / off automatic logon in Windows.

## Properties

+ **[string] Ensure** (Write):
    + Specifies enable or disable automatic logon.
    + The default value is Present. { Present | Absent }.

+ **[PSCredential] AutoLogonCredential** (Required):
    + The credential for logon in Windows.

## Examples
Please look in the [Example](https://github.com/mkht/DSCR_AutoLogon/tree/master/Example) folder.