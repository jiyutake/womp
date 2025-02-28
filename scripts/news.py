#!/usr/bin/env python3

import random
import time
from subprocess import PIPE, run, getoutput, Popen

lines = open("./assets/newsline.txt", "r").read().strip().split("\n")

while True: 
    if getoutput("./bin/performancevar.sh get news").strip() == "false":
        time.sleep(5)
        continue
    line = random.choice(lines)
    print(line, flush=True)
    time.sleep(2)
    for i in range(len(line)): 
        print(line[i:], flush=True)
        time.sleep(0.1)
    print(flush=True)
    time.sleep(random.randint(3, 9))


