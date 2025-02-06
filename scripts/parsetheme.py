#!/usr/bin/env python3
import json
import os

eww_dir = os.path.abspath(os.path.join(os.path.dirname(os.path.realpath(__file__)), ".."))
line = open(os.path.join(eww_dir, "theme.scss")).read().strip()
file = line.split("\"")[1]

theme = {}

for line in open(os.path.join(eww_dir, file)).readlines(): 
    line = line.strip()
    if line == "":
        continue
    if line[0] != "$": 
        continue
    k, v = line.split(":")
    k = k.strip()[1:]
    v = v.strip()[:-1]
    if v[0] == "#":
        theme[k] = v
    else:
        v = v[1:]
        if v in theme: 
            theme[k] = theme[v]

translate = {
    "base": "base00",
    "surface": "base01",
    "overlay": "base01",
    "muted": "base03",
    "subtle": "base04",
    "text": "base05",
    "highlight": "base07"
}

for k, v in translate.items():
    if v in theme:
        theme[k] = theme[v]

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


templatedir = os.path.join(eww_dir, "assets/iconstemplate")
iconsdir = os.path.join(eww_dir, "assets/icons")
for file in os.listdir(templatedir): 
    parse(os.path.join(templatedir, file), os.path.join(iconsdir, file))

# Override Xresources
parse(os.path.join(eww_dir, "assets/Xresources"), os.path.expanduser("~/.Xresources"))

print(json.dumps(theme))
