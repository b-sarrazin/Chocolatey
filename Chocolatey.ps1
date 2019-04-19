# %ForceElevation% = Yes
#Requires -RunAsAdministrator

$ChocoPackagesPath = ".\Packages.txt"

if (Get-Command choco.exe -ErrorAction SilentlyContinue)
{
	Write-Debug "Chocolatey installed"
}
else
{
	Write-Host
	Write-Host "Installing Chocolatey" -ForegroundColor Magenta
	Set-ExecutionPolicy Bypass -Scope Process -Force
	Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

if (Test-Path $ChocoPackagesPath)
{
	[array]$PackagesToInstall = Get-Content $ChocoPackagesPath
	[array]$PackagesInstalled = choco list -lo -r -y | ForEach-Object { $_.split('|')[0] }
	
	if ($PackagesToInstall.Count -gt 0)
	{
		$PackagesToInstall = Compare-Object -ReferenceObject $PackagesToInstall -DifferenceObject $PackagesInstalled -PassThru
		
		if ($PackagesToInstall.Count -gt 0)
		{
			Write-Host
			Write-Host "Installing packages" -ForegroundColor Magenta
			$PackagesToInstall | ForEach-Object {
				choco install $_ -y
			}
		}
	}
	
	Write-Host
	Write-Host "Upgrading packages" -ForegroundColor Magenta
	choco upgrade all -y
	
	Write-Host
	Write-Host "Exporting packages in : $ChocoPackagesPath" -ForegroundColor Magenta
	choco list -lo -r -y | ForEach-Object {
		$_.split('|')[0]
	} | Out-File $ChocoPackagesPath
}
else
{
	New-Item $ChocoPackagesPath -ItemType file -Force | Out-Null
	choco list -lo -r -y | ForEach-Object {
		$_.split('|')[0]
	} | Out-File $ChocoPackagesPath
	Write-Host
	Write-Host "The following file has been created : ""$ChocoPackagesPath""" -ForegroundColor Magenta
	Write-Host "You can enter the Chocolatey package names in this file (one per line) and then restart the script to install everything automatically."
	Write-Host "You can also open a command window as an administrator and type the following command: choco install <package name>."
	Write-Host
	Write-Host "The file has been updated with already installed chocolatey packages and will be updated each time the script is started."
}
