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

# recolor the svgs

templatedir = os.path.join(eww_dir, "assets/iconstemplate")
iconsdir = os.path.join(eww_dir, "assets/icons")
for file in os.listdir(templatedir): 
    f = open(os.path.join(templatedir, file))
    content = f.read()
    f.close()
    f = open(os.path.join(iconsdir, file), "w")
    for k, v in theme.items():
        content = content.replace(f"parse({k})", v)
    f.write(content)
    f.close()

print(json.dumps(theme))
