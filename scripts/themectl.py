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
                for k in theme.keys():
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
                        ]:
                        del theme[k]
                return theme
            except json.JSONDecodeError: 
                pass

    theme = subprocess.getoutput(f"eww -c {eww_dir} get theme")
    return json.loads(theme)

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
    "overlay": "base01",
    "muted": "base03",
    "subtle": "base04",
    "text": "base05",
    "highlight": "base07"
}

def apply_theme(): 
    state = current_state() 
    with open(os.path.join(eww_dir, "themes/temp.scss")) as f: 
        for k, v in state.items(): 
            k = translate.get(k, k)
            f.write(f"{k}: {v};")

    subprocess.run([os.path.join(eww_dir, "bin/set_theme.sh"), "temp"])

def save_theme(name): 
    state = current_state() 
    with open(os.path.join(eww_dir, f"themes/{name}.scss")) as f: 
        for k, v in state.items(): 
            k = translate.get(k, k)
            f.write(f"{k}: {v};")

def reset_theme(default = "rosepine_dawn"): 
    subprocess.run([os.path.join(eww_dir, "bin/set_theme.sh"), default])

# def get_themes(): 
#     return list(map(os.listdir(os.path.join(eww_dir, "themes")), lambda x: x[:-5])).remove("temp")
        
