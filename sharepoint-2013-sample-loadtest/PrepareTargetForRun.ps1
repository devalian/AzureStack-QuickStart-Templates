param(
	[parameter(Mandatory = $true)][System.String]$ServiceUserName
)
Import-Module NetSecurity -ErrorAction SilentlyContinue
$Domain = (Get-WmiObject Win32_ComputerSystem).Domain
$group = [ADSI]"WinNT://localhost/Administrators,group"
$members = $group.psbase.Invoke("Members")
if(($members | foreach {$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)}) -notcontains $ServiceUserName)
{
	$group.psbase.Invoke("Add",([ADSI]"WinNT://$Domain/$ServiceUserName").path)
}
Enable-NetFirewallRule –Group "@FirewallAPI.dll,-34752"
