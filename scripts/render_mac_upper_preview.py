#!/usr/bin/env python3
from pathlib import Path
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection

out=Path(__file__).resolve().parents[1] / 'preview-latest'
out.mkdir(exist_ok=True)

mac=(127,127,50); hs=(100,100,18); fan=100; fan_thick=25; gap=1.5
clip_w=110; clip_d=110; clip_h=8; leg_t=5; lip_h=4
fan_z=mac[2]+hs[2]+gap; fan_top=fan_z+fan_thick

def box_faces(x,y,z,dx,dy,dz):
    X=[x,x+dx]; Y=[y,y+dy]; Z=[z,z+dz]
    return [[(X[0],Y[0],Z[0]),(X[1],Y[0],Z[0]),(X[1],Y[1],Z[0]),(X[0],Y[1],Z[0])],[(X[0],Y[0],Z[1]),(X[1],Y[0],Z[1]),(X[1],Y[1],Z[1]),(X[0],Y[1],Z[1])],[(X[0],Y[0],Z[0]),(X[1],Y[0],Z[0]),(X[1],Y[0],Z[1]),(X[0],Y[0],Z[1])],[(X[0],Y[1],Z[0]),(X[1],Y[1],Z[0]),(X[1],Y[1],Z[1]),(X[0],Y[1],Z[1])],[(X[0],Y[0],Z[0]),(X[0],Y[1],Z[0]),(X[0],Y[1],Z[1]),(X[0],Y[0],Z[1])],[(X[1],Y[0],Z[0]),(X[1],Y[1],Z[0]),(X[1],Y[1],Z[1]),(X[1],Y[0],Z[1])]]

def add_box(ax,x,y,z,dx,dy,dz,color,alpha=.55):
    ax.add_collection3d(Poly3DCollection(box_faces(x,y,z,dx,dy,dz),facecolor=color,edgecolor='white',linewidth=.45,alpha=alpha))

def make(path,elev=24,azim=-50):
    fig=plt.figure(figsize=(10,8),dpi=160); ax=fig.add_subplot(111,projection='3d')
    ax.set_facecolor('#101318'); fig.patch.set_facecolor('#0d0f12')
    mx=(mac[0]-mac[0])/2; my=0
    hx=(mac[0]-hs[0])/2; hy=(mac[1]-hs[1])/2
    fx=(mac[0]-fan)/2; fy=(mac[1]-fan)/2
    cx=(mac[0]-clip_w)/2; cy=(mac[1]-clip_d)/2
    add_box(ax,mx,my,0,*mac,'#b8beca',.38)
    add_box(ax,hx,hy,mac[2],*hs,'#4b4f58',.55)
    add_box(ax,fx,fy,fan_z,fan,fan,fan_thick,'#30343b',.38)
    # low retaining clip, four corner keepers and light tie bars
    keeper=16
    for x in [cx+5,cx+clip_w-5-keeper]:
        for y in [cy+5,cy+clip_d-5-keeper]:
            add_box(ax,x,y,fan_z,keeper,leg_t,clip_h,'#ececec',.52)
            add_box(ax,x,y,fan_z,leg_t,keeper,clip_h,'#ececec',.52)
    add_box(ax,cx+21,cy+5,fan_z,clip_w-42,leg_t,4,'#ececec',.45)
    add_box(ax,cx+21,cy+clip_d-10,fan_z,clip_w-42,leg_t,4,'#ececec',.45)
    add_box(ax,cx+5,cy+21,fan_z,leg_t,clip_d-42,4,'#ececec',.45)
    add_box(ax,cx+clip_w-10,cy+21,fan_z,leg_t,clip_d-42,4,'#ececec',.45)
    ax.text(mac[0]/2,mac[1]/2,mac[2]/2,'Mac mini\n127×127×50',color='white',ha='center')
    ax.text(mac[0]/2,mac[1]/2,mac[2]+hs[2]+2,'100×100×18 heatsink',color='white',ha='center')
    ax.text(mac[0]/2,mac[1]/2,fan_top+7,'100mm fan\nrests on heatsink',color='white',ha='center')
    ax.text(mac[0]/2,-18,fan_z+6,'low retaining clip\n(no tall legs)',color='#78d6ff',ha='center')
    ax.text(mac[0]/2,mac[1]+14,18,'Mac slide path clear',color='#ffd166',ha='center')
    ax.set_xlim(-16,143); ax.set_ylim(-25,152); ax.set_zlim(0,115)
    ax.set_xlabel('X mm'); ax.set_ylabel('Y mm'); ax.set_zlabel('Z mm')
    ax.tick_params(colors='#a9b0bb')
    for axis in [ax.xaxis,ax.yaxis,ax.zaxis]: axis.label.set_color('#a9b0bb')
    ax.view_init(elev=elev,azim=azim); plt.tight_layout(); fig.savefig(path,facecolor=fig.get_facecolor()); plt.close(fig)
make(out/'mac_upper_cooler_stack.png')
make(out/'mac_upper_cooler_side.png',elev=12,azim=-90)
print(out)
