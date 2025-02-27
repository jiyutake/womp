
## Installation/Usage

This config is made for bspwm, and will only work for bspwm. **No, it will *not* work or support Hyprland**.

That said, we only provide a shell, so you will have to set up a bspwm, sxhkd, and picom config yourself. This is done purposefully to ensure that you actually know how your system work, and should not be too much of a trouble to you if you check the documentation and example configurations.

### Dependencies

- pamixer 
- brightnessctl
- playerctl
- xdg-open
- python gobject, dbus
- jq
- zenity
- Ubuntu font
- feh
- acpi

### Installation

> [!WARNING]
> Running the config will override `~/.Xresources`, back it up if you would like to keep your current xresources safe.

To install, clone this folder anywhere, preferably in a directory under `~/.config/eww/`. Then run `./bin/womp.sh start` while under a BSPWM graphic session.
```sh
mkdir -p ~/.config/eww/womp
git clone https://github.com/jiyutake/womp ~/.config/eww/womp
~/.config/eww/womp/bin/womp.sh start
```

`./bin/womp.sh` is a CLI tool for you to interact with Womp, run `./bin/womp.sh help` to see all the commands and options.

> [!TIP]
> The script must stay in this directory when you run it, but you can symlink the script for convenience using two different approaches:
> - Symbolic link on `~/.local/bin`:
> ```sh
> # assuming ~/.local/bin is in your $PATH
> ln -s ~/.config/eww/womp/bin/womp.sh ~/.local/bin/womp.sh
> ```
> - Using aliases:
> ```sh
> # sh/bash
> alias womp="~/.config/womp/bin/womp.sh"
> 
> # fish
> alias --save womp="~/.config/womp/bin/womp.sh"
> ```

> [!IMPORTANT]
> To properly launch Womp, we highly recommend you use `womp.sh start`. Place this command somewhere in your `bspwmrc` config to automate this process.

### Recommended set up

After cloning the repository: 
1. Symlink `womp.sh` for convenience. Make sure the paths are correct.
```sh
# assuming ~/.local/bin is in your $PATH
ln -s ~/.config/eww/womp/bin/womp.sh ~/.local/bin/womp.sh
```

2. Under `bspwmrc`, add 
```sh
womp.sh start &
```
3. Under `sxhkdrc`, add 
```yaml
# toggles applauncher
super + d
    womp.sh window toggle applauncher &

# toggles picom
super + p
    womp.sh compositor toggle &

# opens the settings menu
super + o
    womp.sh window toggle themectl &

# volume control
XF86AudioRaiseVolume
    womp.sh volume increase

XF86AudioLowerVolume
    womp.sh volume decrease

XF86AudioMute
    womp.sh volume toggle
```

More possibilities of the CLI uses can be found by checking `womp.sh help`.
