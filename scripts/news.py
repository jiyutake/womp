#!/usr/bin/env python3

import random
import time
import json
from subprocess import PIPE, run, getoutput, Popen

lines = open("./assets/newsline.txt", "r").read().strip().split("\n")

while True: 
    if getoutput("./bin/performancevar.sh get news").strip() == "false":
        time.sleep(5)
        continue
    data = {}
    data["line"] = 60*" "+random.choice(lines)
    # decrease number to go slower
    step = 50/len(data["line"])
    data["translate"] = 0;
    while data["translate"] > -101:
        print(json.dumps(data), flush=True)
        data["translate"] -= step
        time.sleep(1/40)
    time.sleep(random.randint(3, 9))


