Admin Powershell:
``` 
Set-ExecutionPolicy Unrestricted -Force;
(New-Object System.Net.WebClient).DownloadFile("https://github.com/AliNominal/an-re/archive/refs/heads/main.zip","$env:TEMP\an-re.zip");
Expand-Archive -Path "$env:TEMP\an-re.zip" -DestinationPath "$([Environment]::GetFolderPath('Desktop'))" -Force;Remove-Item "$env:TEMP\an-re.zip";
Copy-Item -Path "$([Environment]::GetFolderPath('Desktop'))\an-re-main\*" -Destination "$([Environment]::GetFolderPath('Desktop'))" -Recurse;
Remove-Item "$([Environment]::GetFolderPath('Desktop'))\an-re-main\" -Recurse -Force | Out-Null;
Push-Location "$([Environment]::GetFolderPath('Desktop'))\Setup";
& "$([Environment]::GetFolderPath('Desktop'))\setup\Install-an-re.ps1";
Pop-Location;
```

