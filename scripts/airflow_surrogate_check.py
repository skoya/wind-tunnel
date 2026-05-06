#!/usr/bin/env python3
"""
Lightweight airflow surrogate for KOYA wind-tunnel CAD.
Solves a 2D Darcy/potential-flow pressure field on simplified slices.
This is NOT a substitute for full OpenFOAM CFD; it is a quick sanity check for
flow paths, bypasses, and dead zones using the current CAD dimensions.
"""
from pathlib import Path
import numpy as np
import matplotlib.pyplot as plt

OUT = Path('exports/airflow')
OUT.mkdir(parents=True, exist_ok=True)

# CAD dimensions, mm
body_w = 154
body_d = 208
body_h = 160
wall = 1.8
front_cassette_d = 36
fan_size = 140
fan_thick = 25
floor_h = 5
ugreen_w, ugreen_l, ugreen_h = 50, 122, 24
ugreen_y = front_cassette_d + 28
ugreen_air_under = 14
ugreen_z = floor_h + ugreen_air_under
ugreen_x0 = (body_w - ugreen_w) / 2
ugreen_x1 = ugreen_x0 + ugreen_w
ugreen_y0, ugreen_y1 = ugreen_y, ugreen_y + ugreen_l
ugreen_z0, ugreen_z1 = ugreen_z, ugreen_z + ugreen_h
pi_stack_t = 34
pi_gap = 8
pi_y = front_cassette_d + 26
pi_z = ugreen_z + ugreen_h + 14
pi_xL0 = body_w/2 - pi_gap/2 - pi_stack_t
pi_xL1 = body_w/2 - pi_gap/2
pi_xR0 = body_w/2 + pi_gap/2
pi_xR1 = pi_xR0 + pi_stack_t
pi_y0, pi_y1 = pi_y + 4, pi_y + 4 + 85
pi_z0, pi_z1 = pi_z + 4, pi_z + 4 + 56
fan_x0, fan_x1 = (body_w-fan_size)/2, (body_w+fan_size)/2
fan_z0, fan_z1 = (body_h-fan_size)/2, (body_h+fan_size)/2
top_fan_y0, top_fan_y1 = 48, 48+140
top_fan_z0, top_fan_z1 = body_h - fan_thick, body_h


def solve_pressure(nx, ny, solid, inlet, outlet, iters=5000, relax=0.72):
    """Stable weighted-Jacobi Laplace solve with fixed inlet/outlet pressure."""
    p = np.zeros((ny, nx), dtype=float)
    fixed = inlet | outlet | solid
    p[inlet] = 1.0
    p[outlet] = 0.0
    yy = np.linspace(1, 0, ny)[:, None]
    p[~fixed] = yy.repeat(nx, axis=1)[~fixed]

    upd = (~solid) & ~inlet & ~outlet
    for _ in range(iters):
        q = p.copy()
        q[solid] = 0.0
        pn = np.pad(q, ((1,1),(1,1)), mode='edge')
        sn = np.pad(solid, ((1,1),(1,1)), mode='edge')
        centre = q
        up = np.where(sn[:-2,1:-1], centre, pn[:-2,1:-1])
        dn = np.where(sn[2:,1:-1], centre, pn[2:,1:-1])
        lf = np.where(sn[1:-1,:-2], centre, pn[1:-1,:-2])
        rt = np.where(sn[1:-1,2:], centre, pn[1:-1,2:])
        avg = 0.25*(up+dn+lf+rt)
        p[upd] = (1-relax)*p[upd] + relax*avg[upd]
        p[inlet] = 1.0
        p[outlet] = 0.0
    p[solid] = np.nan
    return p


def velocity(p, solid, dx=1.0, dy=1.0):
    q = np.nan_to_num(p, nan=0.0)
    gy, gx = np.gradient(q, dy, dx)
    u, v = -gx, -gy
    u[solid] = np.nan; v[solid] = np.nan
    return u, v


def rect(mask, x0, x1, y0, y1, sx=1, sy=1):
    nx = mask.shape[1]; ny = mask.shape[0]
    ix0=max(0,int(round(x0/sx))); ix1=min(nx,int(round(x1/sx)))
    iy0=max(0,int(round(y0/sy))); iy1=min(ny,int(round(y1/sy)))
    mask[iy0:iy1, ix0:ix1] = True


def plot_case(name, extent, solid, inlet, outlet, labels):
    ny, nx = solid.shape
    p = solve_pressure(nx, ny, solid, inlet, outlet)
    u,v = velocity(p, solid)
    speed = np.sqrt(u*u+v*v)
    fig, ax = plt.subplots(figsize=(9, 6), dpi=160)
    im = ax.imshow(speed, origin='lower', extent=extent, cmap='magma', alpha=0.9)
    # streamplot expects grid x/y increasing
    xs = np.linspace(extent[0], extent[1], nx)
    ys = np.linspace(extent[2], extent[3], ny)
    ax.streamplot(xs, ys, np.nan_to_num(u), np.nan_to_num(v), color='cyan', density=1.25, linewidth=0.7, arrowsize=0.8)
    ax.contour(np.linspace(extent[0], extent[1], nx), np.linspace(extent[2], extent[3], ny), solid.astype(float), levels=[0.5], colors='white', linewidths=1.2)
    for text, xy in labels:
        ax.text(*xy, text, color='white', fontsize=8, ha='center', va='center', bbox=dict(facecolor='black', alpha=0.45, pad=2, edgecolor='none'))
    ax.set_title(name)
    ax.set_aspect('equal')
    ax.set_xlabel('mm')
    ax.set_ylabel('mm')
    fig.colorbar(im, ax=ax, label='relative air speed')
    path = OUT / (name.lower().replace(' ', '_').replace('/', '_') + '.png')
    fig.tight_layout()
    fig.savefig(path)
    plt.close(fig)
    return p,u,v,speed,path

# Plan slice at Pi mid-height: x/y
nx, ny = body_w, body_d
solid = np.zeros((ny,nx), bool)
# side walls
rect(solid, 0, wall, 0, body_d); rect(solid, body_w-wall, body_w, 0, body_d)
# Pi blocks in this z slice
rect(solid, pi_xL0, pi_xL1, pi_y0, pi_y1)
rect(solid, pi_xR0, pi_xR1, pi_y0, pi_y1)
inlet = np.zeros_like(solid); outlet = np.zeros_like(solid)
inlet[0:2, int(fan_x0):int(fan_x1)] = True
outlet[-2:, int(wall):int(body_w-wall)] = True
p,u,v,speed,plan_path = plot_case('Plan slice at Pi height', [0, body_w, 0, body_d], solid, inlet, outlet,
    [('front fan inlet',(body_w/2,8)),('left Pi',((pi_xL0+pi_xL1)/2,(pi_y0+pi_y1)/2)),('centre bypass',(body_w/2,(pi_y0+pi_y1)/2)),('right Pi',((pi_xR0+pi_xR1)/2,(pi_y0+pi_y1)/2)),('rear outlet',(body_w/2,body_d-8))])

# Flux fractions at a section just upstream of Pi fronts
section_y = int(pi_y0-3)
lanes = {
    'left_outer': (int(wall), int(pi_xL0)),
    'left_pi_front_zone': (int(pi_xL0), int(pi_xL1)),
    'centre_gap_between_pis': (int(pi_xL1), int(pi_xR0)),
    'right_pi_front_zone': (int(pi_xR0), int(pi_xR1)),
    'right_outer': (int(pi_xR1), int(body_w-wall)),
}
fluxes = {}
for k,(a,b) in lanes.items():
    # v is + toward rear because pressure falls with y; sum positive rearward component
    vals = np.nan_to_num(v[section_y, a:b], nan=0.0)
    fluxes[k] = float(np.clip(vals, 0, None).sum())
total_flux = sum(fluxes.values()) or 1
flux_pct = {k:100*v/total_flux for k,v in fluxes.items()}

# Speed near Pi side surfaces, useful cooling proxy
left_surface_cols = [max(0,int(pi_xL0)-1), min(nx-1,int(pi_xL1)+1)]
right_surface_cols = [max(0,int(pi_xR0)-1), min(nx-1,int(pi_xR1)+1)]
y0,y1=int(pi_y0),int(pi_y1)
left_surface_speed = np.nanmean(np.r_[speed[y0:y1,left_surface_cols[0]], speed[y0:y1,left_surface_cols[1]]])
right_surface_speed = np.nanmean(np.r_[speed[y0:y1,right_surface_cols[0]], speed[y0:y1,right_surface_cols[1]]])
centre_gap_speed = np.nanmean(speed[y0:y1,int(pi_xL1):int(pi_xR0)])
outer_speed = np.nanmean(np.r_[speed[y0:y1,int(wall):int(pi_xL0)].ravel(), speed[y0:y1,int(pi_xR1):int(body_w-wall)].ravel()])

# Side slice through left Pi stack: y/z
nx2, ny2 = body_d, body_h
solid2 = np.zeros((ny2,nx2), bool)
rect(solid2, 0, body_d, 0, floor_h)  # floor
rect(solid2, pi_y0, pi_y1, pi_z0, pi_z1)  # Pi obstruction in side slice
# include UGREEN in side slice? left Pi x overlaps ugreen x partly? yes ugreen x 52..102 overlaps, so obstruction
rect(solid2, ugreen_y0, ugreen_y1, ugreen_z0, ugreen_z1)
inlet2 = np.zeros_like(solid2); outlet2 = np.zeros_like(solid2)
inlet2[int(fan_z0):int(fan_z1), 0:2] = True
outlet2[:, -2:] = True
# top fan extraction as outlet on top between its y range
outlet2[-2:, int(top_fan_y0):int(top_fan_y1)] = True
p2,u2,v2,speed2,side_pi_path = plot_case('Side slice through Pi stack', [0, body_d, 0, body_h], solid2, inlet2, outlet2,
    [('front fan',(8,body_h/2)),('UGREEN',(ugreen_y0+ugreen_l/2,ugreen_z0+ugreen_h/2)),('Pi 56mm',(pi_y0+42,pi_z0+28)),('top fan outlet',(top_fan_y0+70,body_h-8)),('rear outlet',(body_d-8,80))])
side_pi_rear_flux = float(np.clip(np.nan_to_num(u2[:, -3]), 0, None).sum())
side_pi_top_flux = float(np.clip(np.nan_to_num(v2[-3, int(top_fan_y0):int(top_fan_y1)]), 0, None).sum())

# Side slice through centre gap: y/z, UGREEN only, no Pi block
solid3 = np.zeros((ny2,nx2), bool)
rect(solid3, 0, body_d, 0, floor_h)
rect(solid3, ugreen_y0, ugreen_y1, ugreen_z0, ugreen_z1)
inlet3 = inlet2.copy(); outlet3 = outlet2.copy()
p3,u3,v3,speed3,side_gap_path = plot_case('Side slice through centre gap', [0, body_d, 0, body_h], solid3, inlet3, outlet3,
    [('front fan',(8,body_h/2)),('UGREEN',(ugreen_y0+ugreen_l/2,ugreen_z0+ugreen_h/2)),('open gap between Pis',(pi_y0+42,pi_z0+28)),('top fan outlet',(top_fan_y0+70,body_h-8)),('rear outlet',(body_d-8,80))])
side_gap_rear_flux = float(np.clip(np.nan_to_num(u3[:, -3]), 0, None).sum())
side_gap_top_flux = float(np.clip(np.nan_to_num(v3[-3, int(top_fan_y0):int(top_fan_y1)]), 0, None).sum())

summary = OUT / 'airflow_surrogate_summary.txt'
with summary.open('w') as f:
    f.write('KOYA airflow surrogate check\n')
    f.write('Method: 2D pressure/velocity solve on simplified CAD slices; qualitative only.\n\n')
    f.write(f'Pi envelope used: x L {pi_xL0:.1f}-{pi_xL1:.1f}, x R {pi_xR0:.1f}-{pi_xR1:.1f}, y {pi_y0:.1f}-{pi_y1:.1f}, z {pi_z0:.1f}-{pi_z1:.1f} mm (56mm high).\n')
    f.write(f'UGREEN envelope: x {ugreen_x0:.1f}-{ugreen_x1:.1f}, y {ugreen_y0:.1f}-{ugreen_y1:.1f}, z {ugreen_z0:.1f}-{ugreen_z1:.1f} mm.\n')
    f.write(f'Top fan underside starts at z {top_fan_z0:.1f}; clearance above Pi top: {top_fan_z0-pi_z1:.1f} mm.\n\n')
    f.write('Plan-slice front flux distribution just upstream of Pi fronts:\n')
    for k in lanes:
        f.write(f'  {k}: {flux_pct[k]:.1f}%\n')
    f.write('\nRelative speed metrics around Pi zone:\n')
    f.write(f'  left Pi side-surface speed: {left_surface_speed:.4f}\n')
    f.write(f'  right Pi side-surface speed: {right_surface_speed:.4f}\n')
    f.write(f'  centre gap speed: {centre_gap_speed:.4f}\n')
    f.write(f'  outer bypass speed: {outer_speed:.4f}\n')
    f.write('\nSide-slice outlet split, relative flux:\n')
    t = side_pi_rear_flux + side_pi_top_flux or 1
    f.write(f'  through Pi stack slice: rear {100*side_pi_rear_flux/t:.1f}%, top {100*side_pi_top_flux/t:.1f}%\n')
    t = side_gap_rear_flux + side_gap_top_flux or 1
    f.write(f'  through centre gap slice: rear {100*side_gap_rear_flux/t:.1f}%, top {100*side_gap_top_flux/t:.1f}%\n')
    f.write('\nInterpretation hints:\n')
    f.write('  High centre-gap speed compared with Pi side speed means air prefers the gap between Pis.\n')
    f.write('  High outer-bypass speed means side leakage around the Pi stacks.\n')
    f.write('  Side slices show whether top fan/rear outlet pull flow over or around the Pi height.\n')
    f.write('\nGenerated images:\n')
    for pth in [plan_path, side_pi_path, side_gap_path]:
        f.write(f'  {pth}\n')
print(summary)
print(summary.read_text())
