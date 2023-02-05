[cmdletBinding()]
Param(
    [Parameter(Mandatory)]
    [string[]]$ExtensionUri

)

$jobs = @()
foreach ($uri in $ExtensionUri) {
    $jobs += Start-Job -ScriptBlock {
        param($Uri)

        [string]$firefoxProfile = (Get-ChildItem -Path "$env:APPDATA\Mozilla\Firefox\Profiles" -Directory | Select-Object -First 1).FullName

        [string]$extensionPath = "$firefoxProfile/extensions"
        if (!(Test-Path $extensionPath)) {
            New-Item -ItemType Directory $extensionPath | Out-Null
        }

        $Name = $Uri | Split-Path -Leaf
        $TempZip = "$env:TEMP/$Name.zip"
        $TempDir = "$env:TEMP/$Name"

        Invoke-WebRequest -Uri $Uri -OutFile $TempZip
        Expand-Archive -Path $TempZip -DestinationPath $TempDir

        $manifest = Get-Content "$TempDir\manifest.json" | ConvertFrom-Json
        $id = $null
        if($manifest.applications -and $manifest.applications.gecko -and $manifest.applications.gecko.id) {
            $id = $manifest.applications.gecko.id
        }

        if($manifest.browser_specific_settings -and $manifest.browser_specific_settings.gecko -and $manifest.browser_specific_settings.gecko.id) {
            $id = $manifest.browser_specific_settings.gecko.id
        }

        if(!$id) {
            Write-Error "Could not parse extension ID for extension: $Name"
            return
        }

        Remove-Item $TempDir -Recurse | Out-Null
        Copy-Item -Path $TempZip -Destination "$firefoxProfile/extensions/$id.xpi"
        Remove-Item $TempZip | Out-Null
    } -ArgumentList $uri
}

while ($jobs.Where{ $_.State -ne 'Completed' }){
    Start-Sleep -Seconds 1
}

Receive-Job -Job $jobs | Out-Null
Remove-Job -Job $jobs | Out-Null
