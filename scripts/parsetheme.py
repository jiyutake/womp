#!/usr/bin/env python3
import json
import os

line = open("./theme.scss").read().strip()
file = line.split("\"")[1]

theme = {}

for line in open(file).readlines(): 
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

for file in os.listdir("./assets/iconstemplate"): 
    f = open(f"./assets/iconstemplate/{file}")
    content = f.read()
    f.close()
    f = open(f"./assets/icons/{file}", "w")
    for k, v in theme.items():
        content = content.replace(f"parse({k})", v)
    f.write(content)
    f.close()

print(json.dumps(theme))
