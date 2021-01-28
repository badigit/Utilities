$Tag = ((Invoke-RestMethod -Uri "https://api.github.com/repos/coelckers/gzdoom/releases" -UseBasicParsing) | Where-Object -FilterScript {$_.prerelease -eq $false}).tag_name[0]
$URL = (((Invoke-WebRequest -Uri "https://api.github.com/repos/coelckers/gzdoom/releases" -UseBasicParsing | ConvertFrom-Json) | Where-Object -FilterScript {$_.prerelease -eq $false} | Where-Object -FilterScript {$_.tag_name -eq $Tag}).assets | Where-Object -FilterScript {$_.browser_download_url -like "*Windows-64bit.zip"}).browser_download_url

$DownloadsFolder = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
$Parameters = @{
	Uri = $URL
	OutFile = "$DownloadsFolder\GZDoom_$Tag.zip"
	Verbose = [switch]::Present
}
Invoke-WebRequest @Parameters

$Parameters = @{
	Path = "$DownloadsFolder\GZDoom_$Tag.zip"
	DestinationPath = "$DownloadsFolder\GZDoom_$Tag"
	Force = [switch]::Present
	Verbose = [switch]::Present
}
if (Test-Path "$DownloadsFolder\GZDoom_$Tag.zip")
{
    Expand-Archive @Parameters
}


Remove-Item -Path "$DownloadsFolder\GZDoom_$Tag\fm_banks" -Recurse -Force
Remove-Item -Path "D:\Downloads\GZDoom_g4.5.0\licenses.zip" -Force
