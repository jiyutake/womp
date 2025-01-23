#!/usr/bin/python3

import subprocess
import threading
import json
import time

FPS = 30

proc = subprocess.Popen(["playerctl", "status", "-F"], stdout=subprocess.PIPE, text=True)

playing = False
r = 0
h = -2
def spinning():
    global playing, r
    while playing: 
        r += 0.3
        r %= 100
        update()
        time.sleep(1/FPS)

def handmove(): 
    global playing, h
    cstate = playing
    target = 4 if playing else -2
    while abs(h-target) > 0.01: 
        if playing != cstate: 
            return
        h += (target - h) * 0.3
        if not playing: 
            update()
        time.sleep(1/FPS)

def update(): 
    global r, h
    print("{" + f"\"disc\": {r}, \"hand\": {h}" + "}", flush=True)

if __name__ == "__main__": 
    while True: 
        out = proc.stdout.readline().strip()
        playing = out == "Playing"
        if playing: 
            threading.Thread(target=spinning, daemon=True).start()
            threading.Thread(target=handmove, daemon=True).start()
        else:
            threading.Thread(target=handmove, daemon=True).start()

