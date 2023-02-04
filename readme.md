`aps> Set-ExecutionPolicy Unrestricted;`

`ps> (New-Object System.Net.WebClient).DownloadFile("https://github.com/AliNominal/an-re/archive/refs/heads/main.zip","$([Environment]::GetFolderPath('Desktop'))\an-re.zip")`
