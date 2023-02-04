# Install oh my posh
winget install JanDeDobbeleer.OhMyPosh -s winget

# refresh path so oh my posh is available
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Todo: download into ""
# .

# Download a theme
(New-Object System.Net.WebClient).DownloadFile("https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/amro.omp.json", "$([Environment]::GetFolderPath('MyDocuments'))\OhMyPosh\amro.omp.json")
 
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

# Download nerd fonts
$DownloadsDir = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders\" -Name "{374DE290-123F-4565-9164-39C4925E467B}"
(New-Object System.Net.WebClient).DownloadFile("https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/CascadiaCode.zip", "$DownloadsDir\CascadiaCode.zip")

# Install nerd fonts
Expand-Archive C:\a.zip -DestinationPath C:\a

Start-Process powershell -Verb runAs 
