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

# Stronger-top-fan scenario.
# The Noctua NF-F12 replacing the old 140mm top-base fan is not a full CFD fan
# curve, but modelling the top extraction as a lower-pressure outlet gives a
# useful conservative check for whether the faster 120mm top-base pull starves
# rear flow or improves over-Mac/Pi flow.
TOP_OUTLET_PRESSURE = -0.35
TOP_FAN_MODEL_LABEL = 'single Noctua NF-F12 top-base pull, qualitative pressure-biased surrogate'

# CAD dimensions, mm
body_w = 154
body_d = 208
body_h = 160
wall = 1.8
front_cassette_d = 36
fan_size = 140
fan_thick = 25
top_base_fan_size = 120
top_base_fan_thick = 25
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
pi_gap = 20
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
top_fan_y0, top_fan_y1 = 58, 58+top_base_fan_size
top_fan_z0, top_fan_z1 = body_h - top_base_fan_thick, body_h


def solve_pressure(nx, ny, solid, inlet, outlet, iters=5000, relax=0.72, fixed_pressure=None):
    """Stable weighted-Jacobi Laplace solve with fixed pressure boundaries.

    Default: inlet=1, outlet=0. If fixed_pressure is supplied, finite entries
    override those defaults, which lets us model a stronger top fan as a lower
    pressure outlet while keeping the rear outlet at normal pressure.
    """
    p = np.zeros((ny, nx), dtype=float)
    if fixed_pressure is None:
        fixed_pressure = np.full((ny, nx), np.nan, dtype=float)
        fixed_pressure[inlet] = 1.0
        fixed_pressure[outlet] = 0.0
    fixed_boundary = np.isfinite(fixed_pressure)
    fixed = fixed_boundary | solid
    p[fixed_boundary] = fixed_pressure[fixed_boundary]
    yy = np.linspace(1, 0, ny)[:, None]
    p[~fixed] = yy.repeat(nx, axis=1)[~fixed]

    upd = (~solid) & ~fixed_boundary
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
        p[fixed_boundary] = fixed_pressure[fixed_boundary]
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


def plot_case(name, extent, solid, inlet, outlet, labels, fixed_pressure=None):
    ny, nx = solid.shape
    p = solve_pressure(nx, ny, solid, inlet, outlet, fixed_pressure=fixed_pressure)
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
inlet2 = np.zeros((ny2,nx2), bool); outlet2 = np.zeros((ny2,nx2), bool)
inlet2[int(fan_z0):int(fan_z1), 0:2] = True
rear_outlet2 = np.zeros((ny2,nx2), bool)
top_outlet2 = np.zeros((ny2,nx2), bool)
rear_outlet2[:, -2:] = True
# top extraction outlet between its y range, pressure-biased for faster top fans
top_outlet2[-2:, int(top_fan_y0):int(top_fan_y1)] = True
outlet2 = rear_outlet2 | top_outlet2
fixed2 = np.full((ny2,nx2), np.nan, dtype=float)
fixed2[inlet2] = 1.0
fixed2[rear_outlet2] = 0.0
fixed2[top_outlet2] = TOP_OUTLET_PRESSURE


def add_ugreen_solid(mask):
    rect(mask, ugreen_y0, ugreen_y1, ugreen_z0, ugreen_z1)


def add_ugreen_vented(mask):
    """Conservative vent approximation for UGREEN.

    The real enclosure has adapters/plugs and unknown internal blockage, so this
    is not treated as an empty tunnel. It models front-to-back vent slots through
    the UGREEN envelope: three horizontal air bands remain open, with solid top,
    bottom, and ribs. If the actual vents are only on the sides/top, this will
    overestimate pass-through from the front fan.
    """
    add_ugreen_solid(mask)
    # Open three front-to-back bands inside the UGREEN height. Leave material at
    # top/bottom and between bands so the box is still a meaningful obstruction.
    for z0, z1 in [(ugreen_z0+4, ugreen_z0+8), (ugreen_z0+11, ugreen_z0+15), (ugreen_z0+18, ugreen_z0+21)]:
        mask[int(round(z0)):int(round(z1)), int(round(ugreen_y0)):int(round(ugreen_y1))] = False


def outlet_split(u, v):
    rear = float(np.clip(np.nan_to_num(u[:, -3]), 0, None).sum())
    top = float(np.clip(np.nan_to_num(v[-3, int(top_fan_y0):int(top_fan_y1)]), 0, None).sum())
    total = rear + top or 1
    return rear, top, 100*rear/total, 100*top/total

# Solid UGREEN baseline through Pi stack.
solid2 = np.zeros((ny2,nx2), bool)
rect(solid2, 0, body_d, 0, floor_h)  # floor
rect(solid2, pi_y0, pi_y1, pi_z0, pi_z1)  # Pi obstruction in side slice
add_ugreen_solid(solid2)
p2,u2,v2,speed2,side_pi_path = plot_case('Side slice through Pi stack solid UGREEN', [0, body_d, 0, body_h], solid2, inlet2, outlet2,
    [('front fan',(8,body_h/2)),('solid UGREEN',(ugreen_y0+ugreen_l/2,ugreen_z0+ugreen_h/2)),('Pi 56mm',(pi_y0+42,pi_z0+28)),('stronger top pull',(top_fan_y0+70,body_h-8)),('rear outlet',(body_d-8,80))], fixed_pressure=fixed2)
side_pi_rear_flux, side_pi_top_flux, side_pi_rear_pct, side_pi_top_pct = outlet_split(u2, v2)

# Vented UGREEN through Pi stack.
solid2v = np.zeros((ny2,nx2), bool)
rect(solid2v, 0, body_d, 0, floor_h)
rect(solid2v, pi_y0, pi_y1, pi_z0, pi_z1)
add_ugreen_vented(solid2v)
p2v,u2v,v2v,speed2v,side_pi_vented_path = plot_case('Side slice through Pi stack vented UGREEN', [0, body_d, 0, body_h], solid2v, inlet2, outlet2,
    [('front fan',(8,body_h/2)),('vented UGREEN model',(ugreen_y0+ugreen_l/2,ugreen_z0+ugreen_h/2)),('Pi 56mm',(pi_y0+42,pi_z0+28)),('stronger top pull',(top_fan_y0+70,body_h-8)),('rear outlet',(body_d-8,80))], fixed_pressure=fixed2)
side_pi_vent_rear_flux, side_pi_vent_top_flux, side_pi_vent_rear_pct, side_pi_vent_top_pct = outlet_split(u2v, v2v)
ugreen_slot_speed_pi = np.nanmean(speed2v[int(ugreen_z0+4):int(ugreen_z0+21), int(ugreen_y0):int(ugreen_y1)])

# Side slice through centre gap: y/z, UGREEN only, no Pi block
solid3 = np.zeros((ny2,nx2), bool)
rect(solid3, 0, body_d, 0, floor_h)
add_ugreen_solid(solid3)
inlet3 = inlet2.copy(); outlet3 = outlet2.copy()
p3,u3,v3,speed3,side_gap_path = plot_case('Side slice through centre gap solid UGREEN', [0, body_d, 0, body_h], solid3, inlet3, outlet3,
    [('front fan',(8,body_h/2)),('solid UGREEN',(ugreen_y0+ugreen_l/2,ugreen_z0+ugreen_h/2)),('open gap between Pis',(pi_y0+42,pi_z0+28)),('stronger top pull',(top_fan_y0+70,body_h-8)),('rear outlet',(body_d-8,80))], fixed_pressure=fixed2)
side_gap_rear_flux, side_gap_top_flux, side_gap_rear_pct, side_gap_top_pct = outlet_split(u3, v3)

solid3v = np.zeros((ny2,nx2), bool)
rect(solid3v, 0, body_d, 0, floor_h)
add_ugreen_vented(solid3v)
p3v,u3v,v3v,speed3v,side_gap_vented_path = plot_case('Side slice through centre gap vented UGREEN', [0, body_d, 0, body_h], solid3v, inlet3, outlet3,
    [('front fan',(8,body_h/2)),('vented UGREEN model',(ugreen_y0+ugreen_l/2,ugreen_z0+ugreen_h/2)),('open gap between Pis',(pi_y0+42,pi_z0+28)),('stronger top pull',(top_fan_y0+70,body_h-8)),('rear outlet',(body_d-8,80))], fixed_pressure=fixed2)
side_gap_vent_rear_flux, side_gap_vent_top_flux, side_gap_vent_rear_pct, side_gap_vent_top_pct = outlet_split(u3v, v3v)
ugreen_slot_speed_gap = np.nanmean(speed3v[int(ugreen_z0+4):int(ugreen_z0+21), int(ugreen_y0):int(ugreen_y1)])

summary = OUT / 'airflow_surrogate_summary.txt'
with summary.open('w') as f:
    f.write('KOYA airflow surrogate check\n')
    f.write('Method: 2D pressure/velocity solve on simplified CAD slices; qualitative only.\n')
    f.write(f'Top fan scenario: {TOP_FAN_MODEL_LABEL}; top outlet pressure {TOP_OUTLET_PRESSURE:.2f} vs rear outlet 0.00.\n\n')
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
    f.write(f'  through Pi stack slice, solid UGREEN: rear {side_pi_rear_pct:.1f}%, top {side_pi_top_pct:.1f}%\n')
    f.write(f'  through Pi stack slice, vented UGREEN: rear {side_pi_vent_rear_pct:.1f}%, top {side_pi_vent_top_pct:.1f}%\n')
    f.write(f'  through centre gap slice, solid UGREEN: rear {side_gap_rear_pct:.1f}%, top {side_gap_top_pct:.1f}%\n')
    f.write(f'  through centre gap slice, vented UGREEN: rear {side_gap_vent_rear_pct:.1f}%, top {side_gap_vent_top_pct:.1f}%\n')
    f.write('\nUGREEN vent pass-through check:\n')
    f.write('  Model assumption: three front-to-back vent bands through the UGREEN envelope; real adapters/internal PCB will reduce this.\n')
    f.write(f'  mean relative speed inside vent bands under Pi slice: {ugreen_slot_speed_pi:.4f}\n')
    f.write(f'  mean relative speed inside vent bands through centre gap slice: {ugreen_slot_speed_gap:.4f}\n')
    if ugreen_slot_speed_gap > 0.01:
        f.write('  result: if the real UGREEN vents align front-to-back, fan pressure should push some air through them.\n')
    else:
        f.write('  result: the model shows little useful pass-through; treat the UGREEN as mostly a blockage.\n')
    f.write('  caution: if vents are only side/top vents rather than front/rear pass-through, the front fan will mostly flow around/under/over the UGREEN, not through it.\n')
    f.write('\nInterpretation hints:\n')
    f.write('  High centre-gap speed compared with Pi side speed means air prefers the gap between Pis.\n')
    f.write('  High outer-bypass speed means side leakage around the Pi stacks.\n')
    f.write('  Side slices show whether top fan/rear outlet pull flow over or around the Pi height.\n')
    f.write('\nGenerated images:\n')
    for pth in [plan_path, side_pi_path, side_pi_vented_path, side_gap_path, side_gap_vented_path]:
        f.write(f'  {pth}\n')
print(summary)
print(summary.read_text())
