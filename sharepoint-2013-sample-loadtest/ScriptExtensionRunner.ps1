param(
	[parameter(Mandatory = $true)][System.String]$LoadTestPackageSourcePath,
	[parameter(Mandatory = $true)][System.String]$LoadTestDestinationPath,
	[parameter(Mandatory = $true)][System.String]$SPSiteURL,
	[parameter(Mandatory = $true)][System.String]$SPServer,
	[parameter(Mandatory = $true)][System.String]$TestUserName,
	[parameter(Mandatory = $true)][System.String]$TestUserPassword,
	[parameter(Mandatory = $true)][System.String]$TestControllerName
)

# Script names
$ltDownloadScript = "DownloadLoadTestPackage.ps1"
$ltPrepareScript = "PrepareSampleLTForRun.ps1"
$ltRunScript = "StartLoadTestRun.ps1"
# Paths
$currentPath = Convert-Path .
$ltDownloadScriptPath = Join-Path $currentPath $ltDownloadScript
$ltPrepareScriptPath = Join-Path $currentPath $ltPrepareScript
$ltRunScriptPath = Join-Path $currentPath $ltRunScript

# Invoke lt download script
Invoke-Command -ComputerName localhost -FilePath $ltDownloadScriptPath -ArgumentList $LoadTestPackageSourcePath,$LoadTestDestinationPath

$Domain = (Get-WmiObject Win32_ComputerSystem).Domain
$SPServerFQDN = "$($SPServer).$($Domain)"
# Invoke lt prep script
Invoke-Command -ComputerName localhost -FilePath $ltPrepareScriptPath -ArgumentList $LoadTestDestinationPath,$SPSiteURL,$SPServerFQDN,$TestUserName,$TestUserPassword

# Invoke lt run script
$ltSubPath = "LoadTests\LoadTest1.loadtest"
$ltPath = Join-Path $LoadTestDestinationPath $ltSubPath
Invoke-Command -ComputerName localhost -FilePath $ltRunScriptPath -ArgumentList $ltPath,$TestControllerName
