param(
	[parameter(Mandatory = $true)][System.String]$LTFolderPath,
	[parameter(Mandatory = $true)][System.String]$SPSiteURL,
	[parameter(Mandatory = $true)][System.String]$SPServerFQDN,
	[parameter(Mandatory = $true)][System.String]$TestUserName,
	[parameter(Mandatory = $true)][System.String]$TestUserPassword
)
$outFileName = "EndpointConfigDone.txt"
$outFilePath = Join-Path $LTFolderPath $outFileName

$configXMLSubPath = "Config\Config.xml"
$configXMLPath = Join-Path $LTFolderPath $configXMLSubPath
if(!(Test-Path $configXMLPath))
{
	throw [System.IO.FileNotFoundException] "Config xml file not found at the expected path: $($configXMLPath)"
}

$usersCSVSubPath = "Config\Users.csv"
$usersCSVPath = Join-Path $LTFolderPath $usersCSVSubPath
if(!(Test-Path $usersCSVPath))
{
	throw [System.IO.FileNotFoundException] "Users csv file not found at the expected path: $($usersCSVPath)"
}

$loadTestSubPath = "LoadTests\LoadTest1.loadtest"
$loadTestPath = Join-Path $LTFolderPath $loadTestSubPath
if(!(Test-Path $loadTestPath))
{
	throw [System.IO.FileNotFoundException] "Loadtest file not found at the expected path: $($loadTestPath)"
}

#Run the prep only once
if(!(Test-Path $outFilePath))
{
	(Get-Content $configXMLPath).replace('%SPROOTURL%',$SPSiteURL) | Set-Content $configXMLPath -Encoding Oem
	(Get-Content $usersCSVPath).replace('%TESTUSER%',$TestUserName) | Set-Content $usersCSVPath -Encoding Oem
	(Get-Content $usersCSVPath).replace('%TESTUSERPASSWORD%',$TestUserPassword) | Set-Content $usersCSVPath -Encoding Oem
	(Get-Content $loadTestPath).replace('%SPSERVERNAME%',$SPServerFQDN) | Set-Content $loadTestPath -Encoding Oem
	
	$outFileName = "EndpointConfigDone.txt"
	$outFilePath = Join-Path $LTFolderPath $outFileName
	New-Item $outFilePath -ItemType File
}





