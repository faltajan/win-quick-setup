param (
    [string]$directory
)
# Validate the directory parameter
if (-not (Test-Path -Path $directory -PathType Container)) {
    Write-Error "The specified directory does not exist: $directory"
    exit 1
}

# Ensure ssh-agent is running
Start-Service ssh-agent -ErrorAction SilentlyContinue

# Get all private key files based on typical file names and extensions
$privateKeys = Get-ChildItem -Path $directory -File | Where-Object {
    $_.Name -match "^(id_|ssh-key-).*" -and $_.Name -notmatch "\.pub$"
}

foreach ($key in $privateKeys) {
    ssh-add $key.FullName
}

Write-Output "All private keys have been added to the ssh-agent."