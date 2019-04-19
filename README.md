# Chocolatey

A simple powershell script to simplify the use of Chocolatey.

## Getting Started

Just run the powershell script with administrator rights.

### Prerequisites

* Windows 7+ / Windows Server 2003+
* PowerShell v2+ (Not PowerShell Core yet though)
* .NET Framework 4+ (the installation will attempt to install .NET 4.0 if you do not have it installed)

## Description

The script performs the following actions:

* Check and install Chocolatey if not present
* Upgrade all packages
* Check if packages should be installed based on a text file containing package names
* Export the list of packages in this text file
