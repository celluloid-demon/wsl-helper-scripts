xfce wsl notes
==============

(in no particular order)

- starting xfce in fedora results in segfault unless gui apps are disabled (see .wslconf)
- list officially supported wsl distro-containers with `wsl --list --online` (those officially supported will likely have systemd enabled by default)
- disabling gui apps will probably result in WSL's "native" pulseaudio not working (no sound at all in wsl)
- may get good performance initially, but on session reconnects may be choppy, killing xfce PID and clearing .config/xfce works (there's an offending file somewhere)
- current bug with loading compositor, but not when initializing it? workaround is to delete key `<property name="use_compositing" type="bool" value="true"/>` in `${HOME}/.confid/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml` (it will successfully re-initialize)
- modern wsl-based linux containers come with systemd already configured, otherwise edit `/etc/wsl.conf`:

```bash

[boot]
systemd=true

```

- xfce appears to be set up with lightdm/gdm by default, no configuration necessary if you're using this (different story with kde plasma, which defaults to sddm, and isn't optimized for x11-forwarding anyway like xfce is)

- options of interest for vcxsrv:

	- start no client (start with custom wrapper)
	- native opengl (native windows opengl library, wgl)
	- additional parameters:
		`-ac`
