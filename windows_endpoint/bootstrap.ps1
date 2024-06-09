# setup-audio

# Exit on error
$ErrorActionPreference = "Stop"

# Initialize flags with default values
$FLAG_pulseaudio_configured = $false

function install-pulseaudio {
    
    $pulseaudioArchive = "pulseaudio.zip"
    $pulseaudioPath = "pulseaudio"
    $destinationPath = "C:\"
    
    if (-Not (Test-Path -Path "$pulseaudioPath")) {
        
        New-Item -ItemType Directory -Path "$pulseaudioPath"
    
    }
    
    if (-Not (Test-Path -Path "$destinationPath\pulseaudio")) {
        
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

function main {

    install-pulseaudio
    set-pulseaudio

}

main
