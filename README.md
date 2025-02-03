
## Installation/Usage

This config is made for bspwm, and will only work for bspwm. No it will not work for Hyprland.

That said, we only provide a shell, so you will have to set up a bspwm, sxhkd, and picom config yourself. This is done purposefully to ensure that you actually know how your system work.

### Dependencies

- pamixer 
- brightnessctl
- playerctl
- python gobject, dbus
- jq

### Installation

To install, clone this folder anywhere, preferably in a directory under `~/.config/eww/`. Then run `./bin/womp.sh start`
```
mkdir -p ~/.config/eww/womp
git clone https://github.com/jiyutake/womp ~/.config/eww/womp
~/.config/eww/womp/bin/womp.sh start
```

`./bin/womp.sh` is a CLI tool for you to interact with Womp, run `./bin/womp.sh help` to see all the commands and options.

> [!TIP]
> The script must stay in this directory when you run it, but you can symlink the script for convenience 
> ```
> ln -s ~/.config/eww/womp/bin/womp.sh ~/.local/bin/womp.sh
> ```

> [!IMPORTANT]
> To properly launch Womp, we highly recommend you use `womp.sh start`. Place this command somewhere in your `bspwmrc` config.

### Recommended set up

After cloning the repository: 
1. Symlink `womp.sh` for convenience. Make sure the paths are correct
```
ln -s ~/.config/eww/womp/bin/womp.sh ~/.local/bin/womp.sh
```

2. Under `bspwmrc`, add 
```
womp.sh start &
```
3. Under `sxhkdrc`, add 
```
# toggles applauncher
super + d
    womp.sh window toggle applauncher &

# toggles picom
super + p
    womp.sh compositor toggle &

# volume control
XF86AudioRaiseVolume
    womp.sh volume increase

XF86AudioLowerVolume
    womp.sh volume decrease

XF86AudioMute
    womp.sh volume toggle
```

More possibilities can be found by checking `womp.sh help`.
