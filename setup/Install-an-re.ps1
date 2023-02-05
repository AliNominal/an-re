& ./Install-Winget.ps1
& ./Install-OhMyPosh.ps1

# Programming
winget install -e --id Microsoft.VisualStudioCode
winget install -e --id Microsoft.VisualStudio.2022.Community-Preview
winget install -e --id Fork.Fork
winget install -e --id CoreyButler.NVMforWindows
winget install -e --id WinMerge.WinMerge

# techy shit
winget install -e --id Microsoft.WindowsTerminal
winget install -e --id AdoptOpenJDK.OpenJDK.16
winget install -e --id Microsoft.Sysinternals.ProcessExplorer
winget install -e --id voidtools.Everything
winget install -e --id ShareX.ShareX
winget install -e --id Microsoft.PowerToys
winget install -e --id AgileBits.1Password
winget install -e --id 7zip.7zip

# re
winget install -e --id Hex-Rays.IDA.Free
winget install -e --id Telerik.Fiddler.Classic

# apps
# winget install -e --id TorProject.TorBrowser # url in the package manifest is broken at the moment. try again later.
winget install -e --id Mozilla.Firefox
winget install -e --id Discord.Discord
winget install -e --id Valve.Steam

# Refresh path so nvm is accessable
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Configure node
nvm install latest
nvm use latest

# Open firefox so a path to a profile is created
$key = 'HKLM:\Software\Mozilla\Mozilla Firefox'
$version = (Get-ItemProperty -Path $key).'CurrentVersion'
$firefoxExePath = (Get-ItemProperty -Path "$key\$version\Main").PathToExe
if (Test-Path $firefoxExePath) {
  Write-Output "Firefox found at: $firefoxExePath"
  &$firefoxExePath
  # Wait for firefox to launch then wait 5 seconds more for good measure.
  # Don't accidentally wait forever. Max it out at 60s.
  $timeout = 60
  $start = Get-Date
  while ((Get-Process firefox -ErrorAction SilentlyContinue) -eq $null) {
    if ((Get-Date) - $start).TotalSeconds -gt $timeout) {
      Write-Error "Timed out waiting for firefox.exe to start"
      break
    }
    Start-Sleep -Seconds 1
  }
  Start-Sleep -Seconds 5

} else {
  Write-Error "firefox.exe path not found in registry at $firefoxExePath"
}


# Configure firefox
$firefoxProfile = (Get-ChildItem -Path "$env:APPDATA\Mozilla\Firefox\Profiles" -Directory | Select-Object -First 1).FullName
if(Test-Path $firefoxProfile)
{
    Write-Host "Installing arkenfox"
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/arkenfox/user.js/master/user.js" -OutFile "$firefoxProfile\user.js"
    Write-Host "Installing extensions"
    & ./setup/Install-FirefoxExtension.ps1 -ExtensionUri asd -ExtensionPath "$firefoxProfile/extensions" -Hive 'HKLM'
}
else
{
    Write-Warning "Could not find firefox profile."
}


&.\setup\Install-FirefoxExtension.ps1 -ExtensionUri @(
    "https://addons.mozilla.org/firefox/downloads/file/4047353/ublock_origin-1.46.0.xpi",
    "https://addons.mozilla.org/firefox/downloads/file/4032427/return_youtube_dislikes-3.0.0.7.xpi",
    "https://addons.mozilla.org/firefox/downloads/file/4061902/1password_x_password_manager-2.6.0.xpi",
    "https://addons.mozilla.org/firefox/downloads/file/4058426/multi_account_containers-8.1.2.xpi",
    "https://addons.mozilla.org/firefox/downloads/file/3920533/skip_redirect-2.3.6.xpi"
)