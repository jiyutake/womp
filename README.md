
## Installation/Usage

This config is made for bspwm, and will only work for bspwm. No it will not work for Hyprland.

That said, we only provide a shell, so you will have to set up a bspwm, sxhkd, and picom config yourself. This is done purposefully to ensure that you actually know how your system work.

To install, clone this folder anywhere, preferably in a directory under `~/.config/eww/`. Then run `./bin/start.sh`
```
mkdir -p ~/.config/eww/womp
git clone https://github.com/jiyutake/womp ~/.config/eww/womp
~/.config/eww/womp/bin/start.sh
```

Under the `bin` directory is where you will find useful scripts that interact with the shell. You should hook this up with your config to utilize them.

| Script | Function | 
|---|---|
| `start.sh` | Launches the shell properly |
| `toggle_applauncher.sh` | Toggles app launcher |
| `settheme.sh` | Set a theme. Only available themes (as of now) is `rosepine`, `rosepine_dawn`, and `rosepine_moon` |
| `picomcheck.sh` | Enable/disable transparency options based on whether picom is running |
| `picomcheckpoll.sh` | Polls picom status. Enables/disables transparency options accordingly |
| `fullscreencheck.sh` | Hides/opens shell based on whether a window is fullscreened. Should be called whenever a window toggles fullscreen |
