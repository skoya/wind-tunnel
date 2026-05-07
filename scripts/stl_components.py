#!/usr/bin/env python3
from pathlib import Path
import sys, math
from collections import defaultdict, deque

def read_ascii_stl(path):
    tris=[]; cur=[]
    for line in Path(path).read_text(errors='ignore').splitlines():
        s=line.strip().split()
        if len(s)==4 and s[0]=='vertex':
            cur.append(tuple(round(float(x),4) for x in s[1:]))
            if len(cur)==3:
                tris.append(tuple(cur)); cur=[]
    return tris

def comps(path):
    tris=read_ascii_stl(path)
    vmap=defaultdict(list)
    for i,t in enumerate(tris):
        for v in t: vmap[v].append(i)
    seen=[False]*len(tris); sizes=[]; bbs=[]
    for i in range(len(tris)):
        if seen[i]: continue
        q=[i]; seen[i]=True; ids=[]; pts=[]
        while q:
            j=q.pop(); ids.append(j)
            for v in tris[j]:
                pts.append(v)
                for k in vmap[v]:
                    if not seen[k]: seen[k]=True; q.append(k)
        mins=[min(p[a] for p in pts) for a in range(3)]; maxs=[max(p[a] for p in pts) for a in range(3)]
        sizes.append(len(ids)); bbs.append((mins,maxs))
    order=sorted(range(len(sizes)), key=lambda i:sizes[i], reverse=True)
    print(path, 'components', len(sizes), 'triangles', len(tris))
    for n,i in enumerate(order[:12]):
        mins,maxs=bbs[i]
        print(n+1, 'tris', sizes[i], 'bbox', mins, maxs, 'size', [round(maxs[a]-mins[a],2) for a in range(3)])

for p in sys.argv[1:]: comps(p)
