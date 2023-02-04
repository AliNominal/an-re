
# Check if winget is installed
$wingetExists = Get-Command winget -ErrorAction SilentlyContinue

# If winget isn't installed, install it
if (!$wingetExists) {
    Write-Host "Winget not found. Installing..."

    # We also need xaml. See: https://github.com/microsoft/winget-cli/issues/1861
    Add-AppxPackage 'https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx'
    Invoke-WebRequest -Uri https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml/2.7.3 -OutFile "$env:TEMP\microsoft.ui.xaml.2.7.3.zip"
    Expand-Archive "$env:TEMP\microsoft.ui.xaml.2.7.3.zip" -DestinationPath "$env:TEMP\microsoft.ui.xaml.2.7.3"
    Remove-Item -Path "$env:TEMP\microsoft.ui.xaml.2.7.3.zip" -Force -Recurse
    Add-AppxPackage "$env:TEMP\microsoft.ui.xaml.2.7.3\tools\AppX\x64\Release\Microsoft.UI.Xaml.2.7.appx"
    Remove-Item -Path "$env:TEMP\microsoft.ui.xaml.2.7.3" -Force -Recurse

    # refresh path so xaml is found
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

    Invoke-WebRequest -Uri https://github.com/microsoft/winget-cli/releases/download/v1.3.2691/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -OutFile "$env:TEMP\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    Add-AppxPackage "$env:TEMP\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    Remove-Item -Path "$env:TEMP\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -Force -Recurse
}
