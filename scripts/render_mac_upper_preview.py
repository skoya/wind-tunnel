#!/usr/bin/env python3
from pathlib import Path
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection

out=Path(__file__).resolve().parents[1] / 'preview-latest'
out.mkdir(exist_ok=True)

mac=(127,127,50); hs=(100,100,18); bridge_w=131; bridge_d=131; leg_t=6; fan=100; fan_thick=25; gap=8; frame_t=8
fan_z=mac[2]+hs[2]+gap; leg_h=fan_z+frame_t; fan_top=leg_h+fan_thick

def box_faces(x,y,z,dx,dy,dz):
    X=[x,x+dx]; Y=[y,y+dy]; Z=[z,z+dz]
    return [
        [(X[0],Y[0],Z[0]),(X[1],Y[0],Z[0]),(X[1],Y[1],Z[0]),(X[0],Y[1],Z[0])],
        [(X[0],Y[0],Z[1]),(X[1],Y[0],Z[1]),(X[1],Y[1],Z[1]),(X[0],Y[1],Z[1])],
        [(X[0],Y[0],Z[0]),(X[1],Y[0],Z[0]),(X[1],Y[0],Z[1]),(X[0],Y[0],Z[1])],
        [(X[0],Y[1],Z[0]),(X[1],Y[1],Z[0]),(X[1],Y[1],Z[1]),(X[0],Y[1],Z[1])],
        [(X[0],Y[0],Z[0]),(X[0],Y[1],Z[0]),(X[0],Y[1],Z[1]),(X[0],Y[0],Z[1])],
        [(X[1],Y[0],Z[0]),(X[1],Y[1],Z[0]),(X[1],Y[1],Z[1]),(X[1],Y[0],Z[1])],
    ]

def add_box(ax, x,y,z,dx,dy,dz,color,alpha=0.55):
    pc=Poly3DCollection(box_faces(x,y,z,dx,dy,dz), facecolor=color, edgecolor='white', linewidth=0.5, alpha=alpha)
    ax.add_collection3d(pc)

def make(path, elev=24, azim=-50):
    fig=plt.figure(figsize=(10,8),dpi=160)
    ax=fig.add_subplot(111,projection='3d')
    ax.set_facecolor('#101318'); fig.patch.set_facecolor('#0d0f12')
    # center everything in 131 footprint
    mx=(bridge_w-mac[0])/2; my=(bridge_d-mac[1])/2
    hx=(bridge_w-hs[0])/2; hy=(bridge_d-hs[1])/2
    fx=(bridge_w-fan)/2; fy=(bridge_d-fan)/2
    add_box(ax,mx,my,0,*mac,'#b8beca',0.38)
    add_box(ax,hx,hy,mac[2],*hs,'#4b4f58',0.55)
    # bridge legs, side-only
    for x in [0,bridge_w-leg_t]:
        for y in [18,bridge_d-18-leg_t]: add_box(ax,x,y,0,leg_t,leg_t,leg_h,'#ececec',0.72)
    add_box(ax,fx-4,fy-4,fan_z,fan+8,fan+8,frame_t,'#ececec',0.45)
    add_box(ax,fx,fy,leg_h,fan,fan,fan_thick,'#30343b',0.38)
    ax.text(bridge_w/2, bridge_d/2, mac[2]+hs[2]+2, '100×100×18 heatsink', color='white', ha='center')
    ax.text(bridge_w/2, bridge_d/2, leg_h+fan_thick+4, '100mm fan above heatsink', color='white', ha='center')
    ax.text(bridge_w/2, -18, 18, 'front/rear slide path open', color='#78d6ff', ha='center')
    ax.set_xlim(-10,141); ax.set_ylim(-25,156); ax.set_zlim(0,125)
    ax.set_xlabel('X mm'); ax.set_ylabel('Y mm'); ax.set_zlabel('Z mm')
    ax.tick_params(colors='#a9b0bb')
    for axis in [ax.xaxis,ax.yaxis,ax.zaxis]: axis.label.set_color('#a9b0bb')
    ax.view_init(elev=elev, azim=azim)
    plt.tight_layout(); fig.savefig(path, facecolor=fig.get_facecolor()); plt.close(fig)

make(out/'mac_upper_cooler_stack.png')
make(out/'mac_upper_cooler_side.png', elev=12, azim=-90)
print(out)
