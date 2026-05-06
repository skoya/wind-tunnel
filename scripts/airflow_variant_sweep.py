#!/usr/bin/env python3
import numpy as np
from airflow_surrogate_check import solve_pressure, velocity, rect

body_w=154; body_d=208; body_h=160; wall=1.8; front_cassette_d=36; fan_size=140
floor_h=5; ugreen_air_under=14; ugreen_z=floor_h+ugreen_air_under; ugreen_h=24
pi_stack_t=34; pi_gap=8; pi_y=front_cassette_d+26; pi_z=ugreen_z+ugreen_h+14
pi_xL0=body_w/2-pi_gap/2-pi_stack_t; pi_xL1=body_w/2-pi_gap/2
pi_xR0=body_w/2+pi_gap/2; pi_xR1=pi_xR0+pi_stack_t
pi_y0=pi_y+4; pi_y1=pi_y+4+85
fan_x0=(body_w-fan_size)/2; fan_x1=(body_w+fan_size)/2

def run(name, mods):
    nx,ny=body_w,body_d
    solid=np.zeros((ny,nx),bool)
    rect(solid,0,wall,0,body_d); rect(solid,body_w-wall,body_w,0,body_d)
    rect(solid,pi_xL0,pi_xL1,pi_y0,pi_y1); rect(solid,pi_xR0,pi_xR1,pi_y0,pi_y1)
    for m in mods: m(solid)
    inlet=np.zeros_like(solid); outlet=np.zeros_like(solid)
    inlet[0:2,int(fan_x0):int(fan_x1)]=True
    outlet[-2:,int(wall):int(body_w-wall)]=True
    p=solve_pressure(nx,ny,solid,inlet,outlet,iters=2500)
    u,v=velocity(p,solid); speed=np.sqrt(u*u+v*v)
    y0,y1=int(pi_y0),int(pi_y1)
    left=np.nanmean(np.r_[speed[y0:y1,max(0,int(pi_xL0)-1)], speed[y0:y1,min(nx-1,int(pi_xL1)+1)]])
    right=np.nanmean(np.r_[speed[y0:y1,max(0,int(pi_xR0)-1)], speed[y0:y1,min(nx-1,int(pi_xR1)+1)]])
    centre=np.nanmean(speed[y0:y1,int(pi_xL1):int(pi_xR0)])
    outer=np.nanmean(np.r_[speed[y0:y1,int(wall):int(pi_xL0)].ravel(), speed[y0:y1,int(pi_xR1):int(body_w-wall)].ravel()])
    score=(left+right)/2 - 0.25*centre - 0.1*outer
    return dict(name=name,left=left,right=right,centre=centre,outer=outer,score=score)

def centre_splitter_short(s): rect(s, pi_xL1+2, pi_xR0-2, front_cassette_d+8, pi_y0+10)
def centre_splitter_long(s): rect(s, pi_xL1+2, pi_xR0-2, front_cassette_d+8, pi_y1)
def side_shoulders(s):
    rect(s, wall, pi_xL0-4, pi_y0-8, pi_y0+18)
    rect(s, pi_xR1+4, body_w-wall, pi_y0-8, pi_y0+18)
def outer_partial_fences(s):
    rect(s, wall, wall+5, pi_y0-10, pi_y1)
    rect(s, body_w-wall-5, body_w-wall, pi_y0-10, pi_y1)
def front_pressure_plate(s): rect(s, 22, body_w-22, front_cassette_d+4, front_cassette_d+8)

cases=[
 ('baseline',[]),
 ('short centre splitter',[centre_splitter_short]),
 ('long centre splitter',[centre_splitter_long]),
 ('side shoulders',[side_shoulders]),
 ('outer partial fences',[outer_partial_fences]),
 ('short splitter + side shoulders',[centre_splitter_short,side_shoulders]),
]
rows=[run(n,m) for n,m in cases]
rows=sorted(rows,key=lambda r:r['score'],reverse=True)
print('name,left,right,centre,outer,score')
for r in rows:
    print(f"{r['name']},{r['left']:.4f},{r['right']:.4f},{r['centre']:.4f},{r['outer']:.4f},{r['score']:.4f}")
