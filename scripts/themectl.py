#!/usr/bin/python

import os
import json
import subprocess
import sys

state_path = "/tmp/eww/themestate.json"
eww_dir = os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), ".."))

os.makedirs(os.path.dirname(state_path), exist_ok=True)

def current_state():
    if os.path.exists(state_path): 
        with open(state_path, "r") as f:
            try: 
                theme = json.load(f)
                return theme
            except json.JSONDecodeError: 
                pass

    theme = subprocess.getoutput(f"eww -c {eww_dir} get theme")
    theme = json.loads(theme)
    for k in list(theme.keys()):
        if k not in [
            "base",
            "surface",
            "overlay",
            "muted",
            "subtle",
            "text",
            "highlight",
            "accent",
            "accent2",
            "urgent",
            "font"
            ]:
            del theme[k]
    return theme

def write_state(state):
    with open(state_path, "w") as f: 
        json.dump(state, f, indent=2)

def set_var(var, color): 
    state = current_state()
    state[var] = color
    write_state(state)

translate = {
    "base": "base00",
    "surface": "base01",
    "overlay": "base02",
    "muted": "base03",
    "subtle": "base04",
    "text": "base05",
    "highlight": "base07"
}

def apply_theme(): 
    state = current_state() 
    with open(os.path.join(eww_dir, "themes/temp.scss"), "w") as f: 
        for k, v in state.items(): 
            k = translate.get(k, k)
            f.write(f"${k}: {v};\n")

    subprocess.run([os.path.join(eww_dir, "bin/set_theme.sh"), "temp"])

def save_theme(): 
    name = subprocess.getoutput("zenity --entry --entry-text='Theme Name' --title 'Save theme'").strip()
    state = current_state() 
    with open(os.path.join(eww_dir, f"themes/{name}.scss")) as f: 
        for k, v in state.items(): 
            k = translate.get(k, k)
            f.write(f"${k}: {v};\n")

def reset_theme(default = "rosepine_dawn"): 
    if os.path.exists(os.path.join(eww_dir, "themes/temp.scss")):
        os.remove(os.path.join(eww_dir, "themes/temp.scss"))
    if os.path.exists(state_path):
        os.remove(state_path)
    subprocess.run([os.path.join(eww_dir, "bin/set_theme.sh"), default])

def get_saved_themes(): 
    themes = []
    for t in os.listdir(os.path.join(eww_dir, "themes")): 
        t = t[:-5]
        if t == "temp":
            continue
        themes.append(t)
    return themes

def get_fonts(): 
    output = subprocess.getoutput("fc-list").strip().split("\n")
    fonts = set()
    for line in output: 
        font = line.split(":")[1].split(",")[0].strip()
        fonts.add(font)
    return list(fonts)


if __name__ == "__main__":
    arg = sys.argv[1]
    if arg == "get_themes": 
        print(get_saved_themes())
    if arg == "get_fonts": 
        print(get_fonts())
    if arg == "save_theme": 
        save_theme()
    if arg == "set_col": 
        k = sys.argv[2]
        v = "".join(sys.argv[3:])
        v = tuple(map(int, v[4: -1].split(",")))
        color = "#%02x%02x%02x" % v
        set_var(k, color)
    if arg == "set_font" and len(sys.argv) > 2: 
        k = sys.argv[2]
        set_var("font", k)
    if arg == "reset":
        if len(sys.argv) > 2:
            theme = sys.argv[2] 
            reset_theme(theme)
    if arg == "apply": 
        apply_theme()
