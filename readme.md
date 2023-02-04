Admin Powershell:
``` 
Set-ExecutionPolicy Unrestricted;(New-Object System.Net.WebClient).DownloadFile("https://github.com/AliNominal/an-re/archive/refs/heads/main.zip","$env:TEMP\an-re.zip");Expand-Archive -Path $filePath -DestinationPath [Environment]::GetFolderPath('Desktop') -Force;Remove-Item "$env:TEMP\an-re.zip"
```

