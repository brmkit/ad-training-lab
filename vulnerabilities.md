This is just a recap more for myself than anyone would use this repo, here you can find any vulnerabilities or wrong-action that have been added to the lab to provide a basic way to escalate privileges, mess things up, test new implant capabilities... or just play around.

| MACHINE    | VULNERABILITIES                                                                          |
|------------|------------------------------------------------------------------------------------------|
| DC         | - added 3 *main* accounts (jacktest / jeffadmin / webadmin)<br>                          |
| FS         | - shared folder<br>- jeffadmin is localadmin<br>- DA logged on                           |
| WEB        | - website with windows auth<br>- unconstrained delegation<br>- webadmin is localadmin    |
| WS1        | - vulnerable service<br>- user logged on                                                 |
| WS2        | - plaintext credentials somewhere<br>- jacktest is localadmin<br>- wmi enabled but...    |
| MONITORING | just a wazuh server with a pretty web interface                                          |
| ADCS       | *there's no specific vulns - temporary*                                                  |