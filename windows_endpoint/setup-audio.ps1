# setup-audio

# Exit on error
$ErrorActionPreference = "Stop"

$pulseaudioArchive = "pulseaudio.zip"
$pulseaudioPath = "pulseaudio"
$destinationPath = "C:\"

if (-Not (Test-Path -Path "$pulseaudioPath")) {
    
    New-Item -ItemType Directory -Path "$pulseaudioPath"

}

if (-Not (Test-Path -Path "$destinationPath\pulseaudio")) {
    
    Expand-Archive -Path "$pulseaudioPath\$pulseaudioArchive" -DestinationPath "$destinationPath"

}
