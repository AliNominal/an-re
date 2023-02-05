# should be run after nvm is installed

# refresh the path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Configure node
nvm install latest
nvm use latest
