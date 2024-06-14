# setup-audio

# Exit on error
$ErrorActionPreference = "Stop"

# Declare constants
$DISTRO_NAME = "ubuntu-24.04"

# Initialize flags with default values
$FLAG_distro_installed = $false
$FLAG_pulseaudio_installed = $false
$FLAG_pulseaudio_configured = $false

function install-pulseaudio {
    
    $pulseaudioArchive = "pulseaudio.zip"
    $pulseaudioPath = ".\pulseaudio"
    $destinationPath = "C:\"

    # (read: in case you remove that stub text file that's keeping the local pulseaudio folder synced with git)
    if (-Not (Test-Path -Path "$pulseaudioPath")) {
        
        New-Item -ItemType Directory -Path "$pulseaudioPath"
    
    }

    if (Test-Path -Path "$destinationPath\pulseaudio") {

        $FLAG_pulseaudio_installed = $true

    }

    if (-Not $FLAG_pulseaudio_installed) {

        Expand-Archive -Path "$pulseaudioPath\$pulseaudioArchive" -DestinationPath "$destinationPath"

    }
    
}

function set-pulseaudio {

    $daemonConfigPath = "C:\pulseaudio\etc\pulse\daemon.conf"
    $defaultConfigPath = "C:\pulseaudio\etc\pulse\default.pa"

    $defaultContent = Get-Content -Path "$defaultConfigPath"
    $daemonContent = Get-Content -Path "$daemonConfigPath"

    $searchString = "load-module module-waveout sink_name=output source_name=input record=0"

    if ($defaultContent | Select-String $searchString) {

        $FLAG_pulseaudio_configured = $true

    }

    if (-not $FLAG_pulseaudio_configured) {

        # comment-out one line...

        $pattern = "load-module module-waveout"

        $modifiedContent = $defaultContent -replace ("^(.*$pattern.*)$", "# `$1")

        # ...add three lines to the bottom...

        $linesToAdd = @"

`n#########################################
#                                       #
#          BEGIN CUSTOM CONFIG          #
#                                       #
#########################################

load-module module-waveout sink_name=output source_name=input record=0
load-module module-esound-protocol-tcp port=4714 auth-ip-acl=172.16.0.0/12
load-module module-native-protocol-tcp port=4713 auth-ip-acl=172.16.0.0/12`n

"@

        $modifiedContent += "`n$linesToAdd`n"

        # ... and save default.pa content

        $modifiedContent | Set-Content -Path $defaultConfigPath

        # add line to another file...

        $newLine = "exit-idle-time = -1"

        $modifiedContent = $daemonContent
        $modifiedContent += "`n$newLine`n"

        # ...and save daemon.conf

        $modifiedContent | Set-Content -Path $daemonConfigPath

    }

}

function install-ubuntu {

    # NOTE: Windows PowerShell appears to decode UTF-encoded output from wsl -l as ASCII and the string therefore contains a bunch of NUL-bytes. The proper solution requires (temporarily) setting [Console]::OutputEncoding = [System.Text.Encoding]::Unicode to ensure that PowerShell decodes the output from wsl -l properly.

    # source: https://stackoverflow.com/questions/69811624/in-powershell-how-to-detect-if-wsl-ubuntu-is-installed

    if (wsl --distribution $DISTRO_NAME echo "Hello world.") {
        
        $FLAG_distro_installed = $true
        
    }
        
    if (-Not $FLAG_distro_installed) {

        wsl --install $DISTRO_NAME

    }

}

function main {

    install-pulseaudio

    set-pulseaudio

    install-ubuntu

}

main
