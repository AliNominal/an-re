$themeUrl = "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/amro.omp.json"

$themeName = Split-Path $themeUrl -Leaf;
$themeInstallLocation = "$([Environment]::GetFolderPath('MyDocuments'))\OhMyPosh\$themeName"
$fontsDir = "$([System.Environment]::GetFolderPath('Fonts'))"

& ./Install-Winget.ps1

if(!(Get-Command oh-my-posh -ErrorAction SilentlyContinue))
{
    # Use winget to install oh-my-posh
    Write-Host "Installing oh-my-posh..."
    winget install JanDeDobbeleer.OhMyPosh -s winget

    # refresh path so oh my posh is available
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}


if (!(Test-Path $themeInstallLocation)) {
    # Ensure the target location exists
    New-Item -ItemType Directory -Path (Split-Path $themeInstallLocation -Parent) -Force

    # Download a theme
    (New-Object System.Net.WebClient).DownloadFile($themeUrl, "$([Environment]::GetFolderPath('MyDocuments'))\OhMyPosh\$themeName")
}

if((Select-String -Path $profile -Pattern "oh-my-posh") -eq $null)
{
    if (!(Test-Path $profile)) {
        New-Item -ItemType File -Path $profile -Force
    }

    # Write the init to our profile
    $ompCommand = "oh-my-posh.exe init pwsh --config ""$themeInstallLocation"" | Invoke-Expression"
    Add-Content $profile $ompCommand
}


if(!(Test-Path "$fontsDir\Caskaydia Cove Nerd Font Complete Regular.otf"))
{
    $downloadsDir = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
    $filePath = "$downloadsDir\CascadiaCode.zip"

    (New-Object System.Net.WebClient).DownloadFile("https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/CascadiaCode.zip", $filePath)

    Expand-Archive -Path $filePath -DestinationPath $fontsDir -Force

    Remove-Item $filePath
}
