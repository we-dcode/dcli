param (
    [string]$Version = $env:DCLI_VERSION
)

# Function to get the installed dcli version
function Get-InstalledDcliVersion {
    try {
        $output = & "C:\Program Files\Dcode\dcli.exe" -v 2>$null
        if ($output -match 'dcli version (\d+\.\d+\.\d+)') {
            return $matches[1]
        }
    } catch {
        # dcli is not installed or not in PATH
    }
    return $null
}

# Determine the version to install
if (-not $Version) {
    Write-Host "No version provided, fetching latest release..."
    $Version = (Invoke-RestMethod -Uri "https://api.github.com/repos/we-dcode/dcli/releases/latest").tag_name
}

# Check the installed version
$installedVersion = Get-InstalledDcliVersion
if ($installedVersion -eq $Version) {
    Write-Host "dcli version $Version is already installed. Skipping download."
    exit 0
}

# Proceed with installation
$Os = "windows"
$Arch = "amd64"
$ZipName = "dcli_${Version}_${Os}_${Arch}.zip"
$DownloadUrl = "https://github.com/we-dcode/dcli/releases/download/$Version/$ZipName"
$TargetDir = "C:\Program Files\Dcode"
$TempZip = "$env:TEMP\dcli.zip"

Write-Host "Downloading dcli $Version for $Os/$Arch..."
Invoke-WebRequest -Uri $DownloadUrl -OutFile $TempZip

Write-Host "Extracting to $TargetDir..."
if (!(Test-Path -Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}
Expand-Archive -Path $TempZip -DestinationPath $TargetDir -Force

Write-Host "✅ dcli installed to '$TargetDir\dcli.exe'"

Write-Host "`nAdd to PATH if needed:"
Write-Host "setx PATH '`$env:PATH;$TargetDir' /M"
