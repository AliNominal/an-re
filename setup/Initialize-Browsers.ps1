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
  &.\setup\Install-FirefoxExtension.ps1 -ExtensionUri @(
      "https://addons.mozilla.org/firefox/downloads/file/4047353/ublock_origin-1.46.0.xpi",
      "https://addons.mozilla.org/firefox/downloads/file/4032427/return_youtube_dislikes-3.0.0.7.xpi",
      "https://addons.mozilla.org/firefox/downloads/file/4061902/1password_x_password_manager-2.6.0.xpi",
      "https://addons.mozilla.org/firefox/downloads/file/4058426/multi_account_containers-8.1.2.xpi",
      "https://addons.mozilla.org/firefox/downloads/file/3920533/skip_redirect-2.3.6.xpi"
  )
}
else
{
    Write-Warning "Could not find firefox profile."
}
