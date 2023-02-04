
function Get-GithubLatestRelease {
    param (
        [parameter(Mandatory)][string]$project, # e.g. paintdotnet/release
        [parameter(Mandatory)][string]$pattern, # regex. e.g. install.x64.zip
        [switch]$prerelease
    )

    # Get all releases and then get the first matching release. Necessary because a project's "latest"
    # release according to Github might be of a different product or component than the one you're
    # looking for. Also, Github's 'latest' release doesn't include prereleases.
    $releases = Invoke-RestMethod -Method Get -Uri "https://api.github.com/repos/$project/releases"
    $downloadUrl = $releases |
                   Where-Object { $_.prerelease -eq $prerelease } |
                   ForEach-Object { $_.assets } |
                   Where-Object { $_.name -match $pattern } |
                   Select-Object -First 1 -ExpandProperty "browser_download_url"

    return $downloadUrl
}


# Check if winget is installed
$wingetExists = Get-Command winget -ErrorAction SilentlyContinue

# If winget isn't installed, install it
if (!$wingetExists) {
    Write-Host "Winget not found. Installing..."

    # We also need xaml. See: https://github.com/microsoft/winget-cli/issues/1861
    Invoke-WebRequest -Uri https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.3 -OutFile "$env:TEMP\microsoft.ui.xaml.2.7.3.zip"
    Expand-Archive "$env:TEMP\microsoft.ui.xaml.2.7.3.zip" -DestinationPath "$env:TEMP\microsoft.ui.xaml.2.7.3"
    Remove-Item -Path "$env:TEMP\microsoft.ui.xaml.2.7.3.zip" -Force -Recurse
    Add-AppxPackage "$env:TEMP\microsoft.ui.xaml.2.7.3\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx"
    Remove-Item -Path "$env:TEMP\microsoft.ui.xaml.2.7.3" -Force -Recurse

    Invoke-WebRequest -Uri https://github.com/microsoft/winget-cli/releases/download/v1.3.2691/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -OutFile "$env:TEMP\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    Add-AppxPackage "$env:TEMP\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    Remove-Item -Path "$env:TEMP\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -Force -Recurse
}

# Use winget to install oh-my-posh
Write-Host "Installing oh-my-posh..."
winget install JanDeDobbeleer.OhMyPosh -s winget

# refresh path so oh my posh is available
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")


if (!(Test-Path "$([Environment]::GetFolderPath('MyDocuments'))\OhMyPosh\")) {
    New-Item -ItemType Directory -Path "$([Environment]::GetFolderPath('MyDocuments'))\OhMyPosh\"
}


# Download a theme
(New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/amro.omp.json", "$([Environment]::GetFolderPath('MyDocuments'))\OhMyPosh\amro.omp.json")

if (!(Test-Path $profile)) {
    if (!(Test-Path (Split-Path $profile -Parent))) {
        New-Item -ItemType Directory -Path (Split-Path $profile -Parent)
    }
    New-Item -ItemType File -Path $profile
}


$sel = Select-String -Path $profile -Pattern "oh-my-posh" 
if($sel -eq $null)
{
  # Write the init to our profile
  $ompCommand = 'oh-my-posh.exe init pwsh --config "$([Environment]::GetFolderPath(''MyDocuments''))\OhMyPosh\amro.omp.json" | Invoke-Expression'
  Add-Content $profile $ompCommand
}
else
{
  Write-Warning "oh-my-posh already present in the powershell profile: $profile"
}

# Download fonts directly into C:/Windows/Fonts
#(New-Object System.Net.WebClient).DownloadData("https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/CascadiaCode.zip") | Expand-Archive -DestinationPath "$([System.Environment]::GetFolderPath('Fonts'))"

$destination = "$([System.Environment]::GetFolderPath('Fonts'))"
$downloadsDir = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
$filePath = "$downloadsDir\CascadiaCode.zip"

(New-Object System.Net.WebClient).DownloadFile("https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/CascadiaCode.zip", $filePath)

Expand-Archive -Path $filePath -DestinationPath $destination -Force

Remove-Item $filePath
