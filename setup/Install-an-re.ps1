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

Start-Process PowerShell -ArgumentList "-NoExit", "-File Install-Nodejs.ps1"
Start-Process PowerShell -ArgumentList "-NoExit", "-File Initialize-Browsers.ps1"

