param(
	[parameter(Mandatory = $true)][System.String]$LoadTestPackageSourcePath,
	[parameter(Mandatory = $true)][System.String]$LoadTestDestinationPath
)

function Download-LoadTestZip
{
	param(
		[parameter(Mandatory = $true)][System.String] $SourcePath,
		[parameter(Mandatory = $true)][System.String] $TargetPath
	)
	
	if(!(Test-Path $TargetPath))
	{
		New-Item $TargetPath -ItemType directory
	}
	$destFileName = Split-Path $SourcePath -Leaf
	$destFullPath = Join-Path $TargetPath $destFileName
	
	if(!(Test-Path $destFileName))
	{
		$wc = New-Object System.Net.WebClient
    	$wc.DownloadFile($SourcePath, $destFullPath)
	}
}

function Extract-ZipFile
{
	param(
		[parameter(Mandatory = $true)][System.String] $SourceZip,
		[parameter(Mandatory = $true)][System.String] $TargetPath
	)
	if(!(Test-Path $SourceZip))
	{
		throw [System.IO.FileNotFoundException] "$($SourceZip) not found"
	}
	if(!(Test-Path $TargetPath))
	{
		New-Item $TargetPath -ItemType directory
		Add-Type -assembly “System.IO.Compression.Filesystem”
		[System.IO.Compression.ZipFile]::ExtractToDirectory($SourceZip,$TargetPath)
	}	
}

$ltArchiveFolderName = "LoadTestPackages"
$ltArchivePath = Join-Path $env:SystemDrive $ltArchiveFolderName

if(!(Test-Path $ltArchivePath))
{
	New-Item $ltArchivePath -ItemType directory	
}
Download-LoadTestZip -SourcePath $LoadTestPackageSourcePath -TargetPath $ltArchivePath
$ltZipFileName = Split-Path $LoadTestPackageSourcePath -Leaf
$ltZipLocalPath = Join-Path $ltArchivePath $ltZipFileName
Extract-ZipFile -SourceZip $ltZipLocalPath -TargetPath $LoadTestDestinationPath
