@echo off

REM /B; don't start its own window

start "" /B ".\config.xlaunch"
start "" /B "C:\pulseaudio\bin\pulseaudio.exe"

wsl.exe --distribution ubuntu-24.04 -e bash -c "if [ -z $(pidof xfce4-session) ]; then export DISPLAY=$(ip route list default | awk '{print $3}'):0; export PULSE_SERVER=tcp:$(ip route list default | awk '{print $3}'); xfce4-session; pkill '(gpg|ssh)-agent'; taskkill.exe /IM pulseaudio.exe /F; taskkill.exe /IM vcxsrv.exe /F; fi"
