#!/usr/bin/env python3
import json

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

print(json.dumps(theme))
