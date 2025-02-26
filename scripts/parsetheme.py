#!/usr/bin/env python3
import json
import os
from sys import argv

eww_dir = os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), ".."))
line = open(os.path.join(eww_dir, "theme.scss")).read().strip()
file = line.split("\"")[1]

theme = {"name": file.split("/")[-1][:-5]}

for line in open(os.path.join(eww_dir, file)).readlines() + open(os.path.join(eww_dir, "color_map.scss")).readlines(): 
    line = line.strip()
    if line == "":
        continue
    if line[0] != "$": 
        continue
    k, v = line.split(":")
    k = k.strip()[1:]
    v = v.strip()[:-1]
    if v[0] == "$":
        v = v[1:]
        if v in theme: 
            theme[k] = theme[v]
    else:
        theme[k] = v

# recolor the svgs

def parse(template, target): 
    f = open(template)
    content = f.read()
    f.close()
    f = open(target, "w")
    for k, v in theme.items():
        content = content.replace(f"parse({k})", v)
    f.write(content)
    f.close()

if not (len(argv) > 1 and argv[1] == "norecolor"):
    templatedir = os.path.join(eww_dir, "assets/iconstemplate")
    iconsdir = os.path.join(eww_dir, "assets/icons")
    for file in os.listdir(templatedir): 
        parse(os.path.join(templatedir, file), os.path.join(iconsdir, file))

    # Override Xresources
    parse(os.path.join(eww_dir, "assets/Xresources"), os.path.expanduser("~/.Xresources"))

print(json.dumps(theme))
