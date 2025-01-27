#!/usr/bin/env python3

import requests
import json
import threading
import time
from subprocess import PIPE, run, getoutput, Popen

UNRELIABLE = ["firefox", "soundcloud", "chromium"]

class Manager: 
    def __init__(self): 
        self.song: list[str] = []
        self.lrc = None
        self.lrind = 0
        self.ts = -1
        self.running = False
        threading.Thread(target=self.listen_metadata, daemon=True).start()
        threading.Thread(target=self.listen_playback, daemon=True).start()
        self.loop()

    def search(self): 
        name, artist, player_name = self.song

        if player_name in UNRELIABLE:
            url = "https://lrclib.net/api/search?"
            url += f"&q={'+'.join(name.split())}"
        else:
            url = "https://lrclib.net/api/get?"
            url += f"artist_name={'+'.join(artist.split('/')[0].split())}"
            url += f"&track_name={'+'.join(name.split())}"
        
        res = requests.get(url)

        if not res.ok: 
            return None 

        data = res.json()
        if player_name in UNRELIABLE:
            if len(data) > 0: 
                data = data[0]
            else:
                return None
            
        if "syncedLyrics" not in data:
            return None

        rlrc = data["syncedLyrics"]
        if not rlrc: 
            return None

        return rlrc

    def parse_rlrc(self, rlrc): 
        rlrc = rlrc.split("\n")
        lrc= [] 
        for l in rlrc: 
            l = l.strip()
            ts, lr = j if len((j := l.split("] "))) == 2 else (j[0][:-1], "")
            ts = ts[1:]
            h, m = ts.split(":")
            h = int(h)
            m = float(m)
            m += h*60
            lrc.append((m, lr))
        return lrc
    
    def new_metadata(self): 
        rlrc = self.search()
        if rlrc: 
            self.lrc = self.parse_rlrc(rlrc)
        else:
            self.lrc = []
        self.lrind = 0

    def reset(self): 
        cur = float(getoutput("playerctl metadata -f '{{position}}'"))/1000000
        self.ts = time.time() - cur

        i = 0 
        if not self.lrc:
            self.print_output()
            return 
        while i < len(self.lrc) and self.lrc[i][0] <= cur:
            i += 1
        self.lrind = i
        self.print_output()

    def loop(self):
        while True: 
            if self.running:
                cur = time.time() - self.ts
                nap = self.next_update(cur)
                time.sleep(min(max(nap, 0), 0.1))
            else:
                time.sleep(0.1)

    def next_update(self, cur): 
        if self.lrc and self.lrind < len(self.lrc): 
            if self.lrc[self.lrind][0] <= cur:
                l = self.lrc[self.lrind][1]
                self.print_output()
                self.lrind += 1
            if self.lrind < len(self.lrc):
                l = self.lrc[self.lrind][0]
                return l-cur
        return 0.1
    
    def print_output(self): 
        data = {}
        if not self.lrc:
            data["found"] = False
            data["lyrics"] = "Can't find lyrics :("
        else:
            data["found"] = True
            data["lyrics"] = ""
            j = self.lrind - 5
            i = 0
            while i <= 15: 
                if j < 0:
                    j += 1
                    continue
                if j >= len(self.lrc): 
                    break
                i += 1
                if j <= self.lrind: 
                    data["lyrics"] += f"<b>{self.lrc[j][1]}</b>\n"
                else:
                    data["lyrics"] += f"{self.lrc[j][1]}\n"
                j += 1
        print(json.dumps(data), flush=True)


    def listen_playback(self): 
        proc = Popen(["playerctl", "status", "-F"], stdout=PIPE, text=True)
        initial = True
        while True: 
            out = proc.stdout.readline().strip()
            
            # stupid playerctl bug
            
            if initial: 
                out = getoutput("playerctl status").strip()
                initial = False

            self.running = out == "Playing"
            self.reset()

    def listen_metadata(self): 
        proc = Popen(["playerctl", "metadata", "-f", "[ \"{{title}}\", \"{{artist}}\", \"{{playerName}}\" ]", "-F"], stdout=PIPE, text=True)
        while True: 
            out = proc.stdout.readline().strip()
            try:
                self.song = json.loads(out)
                self.new_metadata()
                self.reset()
            except:
                pass

if __name__ == "__main__": 
    Manager()
