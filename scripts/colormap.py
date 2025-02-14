#!/usr/bin/python

import os
import json
import sys
from subprocess import getoutput, run

eww_dir = os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), ".."))

theme = getoutput(f"eww -c {eww_dir} get theme")
theme = json.loads(theme)


cmap = {}
with open(os.path.join(eww_dir, "color_map.scss")) as f:
    for line in f.readlines():
        line = line.strip()
        if line == "":
            continue 
        if line[0] != "$":
            continue

        k, v = line.split(":") 
        k = k.strip()[1:]
        v = v.strip()[:-1]
        cmap[k] = v

# shout out geeks4geeks
def is_hex(str):
 
    if (str[0] != '#'):
        return False
 
    if (not(len(str) == 4 or len(str) == 7)):
        return False
 
    for i in range(1, len(str)):
        if (not((str[i] >= '0' and str[i] <= '9') or (str[i] >= 'a' and str[i] <= 'f') or (str[i] >= 'A' or str[i] <= 'F'))):
            return False
 
    return True

def set_var(k, v): 
    if k == "" or v == "": 
        return
    if not is_hex(v) and v[1:].strip() not in theme:
        return
    cmap[k] = v
    with open(os.path.join(eww_dir, "color_map.scss"), "w") as f: 
        for k, v in cmap.items(): 
            f.write(f"${k}: {v}; \n")
    
    run([os.path.join(eww_dir, "scripts/parsetheme.py")])
    run(["eww", "-c", eww_dir, "reload"])

def get_keys(): 
    return json.dumps(list(cmap.keys()))

def update_eww(k): 
    if k not in cmap: 
        return
    v = cmap[k]
    hex = v
    if v[0] == "$":
        if v[1:] in theme: 
            hex = theme[v[1:]]
    data = {
        "key": k,
        "val": v,
        "hex": hex
    }
    
    run(["eww", "-c", eww_dir, "update", f"colorjson={json.dumps(data)}"])

def get_saved_themes(): 
    themes = []
    for t in os.listdir(os.path.join(eww_dir, "themes")): 
        t = t[:-5]
        themes.append(t)
    return themes

if __name__ == "__main__":
    arg = sys.argv[1]
    if arg == "get_themes": 
        print(get_saved_themes())

        
    if arg == "get_keys": 
        print(get_keys())

    if len(sys.argv) < 3:
        exit(0)
    if arg == "update": 
        k = sys.argv[2]
        update_eww(k)
    if arg == "set" and len(sys.argv) > 3: 
        k, v = sys.argv[2], sys.argv[3]
        set_var(k, v)

