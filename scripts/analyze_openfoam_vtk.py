#!/usr/bin/env python3
from pathlib import Path
import xml.etree.ElementTree as ET
import numpy as np

base = Path('openfoam/koya_airflow_simple/VTK_ASCII/koya_airflow_simple_250/boundary')
out = Path('openfoam/koya_airflow_simple/openfoam_summary.txt')

def arr_text(elem):
    return np.fromstring(elem.text or '', sep=' ')

def read_vtp(name):
    root = ET.parse(base/f'{name}.vtp').getroot()
    piece = root.find('.//Piece')
    pts_da = piece.find('./Points/DataArray')
    pts = arr_text(pts_da).reshape((-1,3))
    point_data = {}
    pd = piece.find('./PointData')
    if pd is not None:
        for da in pd.findall('DataArray'):
            ncomp = int(da.attrib.get('NumberOfComponents','1'))
            vals = arr_text(da)
            point_data[da.attrib['Name']] = vals.reshape((-1,ncomp)) if ncomp>1 else vals
    polys = piece.find('./Polys')
    conn = offs = None
    for da in polys.findall('DataArray'):
        if da.attrib['Name']=='connectivity': conn = arr_text(da).astype(int)
        if da.attrib['Name']=='offsets': offs = arr_text(da).astype(int)
    faces=[]; start=0
    for off in offs:
        faces.append(conn[start:off]); start=off
    return pts, point_data, faces

def face_area_vec(poly_pts):
    # Newell area vector
    n=np.zeros(3)
    for i,p in enumerate(poly_pts):
        q=poly_pts[(i+1)%len(poly_pts)]
        n += np.array([(p[1]-q[1])*(p[2]+q[2]), (p[2]-q[2])*(p[0]+q[0]), (p[0]-q[0])*(p[1]+q[1])])
    return 0.5*n

def patch_flux(name, expected_normal=None):
    pts,pd,faces=read_vtp(name)
    U=pd['U']
    flux=0; area=0; mag_u_area=0
    for f in faces:
        pp=pts[f]
        avec=face_area_vec(pp)
        a=np.linalg.norm(avec)
        if a == 0: continue
        if expected_normal is not None and np.dot(avec, expected_normal) < 0:
            avec=-avec
        u=U[f].mean(axis=0)
        flux += float(np.dot(u, avec))
        area += float(a)
        mag_u_area += float(np.linalg.norm(u)*a)
    return flux, area, mag_u_area/max(area,1e-30)

def patch_speed(name):
    pts,pd,faces=read_vtp(name)
    U=pd['U']
    speeds=[]; weights=[]
    for f in faces:
        pp=pts[f]
        a=np.linalg.norm(face_area_vec(pp))
        speeds.append(np.linalg.norm(U[f].mean(axis=0)))
        weights.append(a)
    speeds=np.array(speeds); weights=np.array(weights)
    return float(np.average(speeds, weights=weights)), float(speeds.max()), float(weights.sum())

rear=patch_flux('rearOutlet', np.array([0,1,0]))
top=patch_flux('topOutlet', np.array([0,0,1]))
inlet=patch_flux('inlet', np.array([0,-1,0]))
piL=patch_speed('piLeft')
piR=patch_speed('piRight')
ug=patch_speed('ugreen')
# flow into domain at inlet has negative outward-normal flux; use magnitude
rear_q=max(rear[0],0); top_q=max(top[0],0); inlet_q=abs(inlet[0])
total_out=rear_q+top_q
text=[]
text.append('KOYA OpenFOAM simplified airflow result')
text.append('Case: openfoam/koya_airflow_simple')
text.append('Solver: simpleFoam, k-epsilon RANS, 250 iterations, inlet 0.8 m/s over front face')
text.append('Geometry: simplified duct + closed wall blocks for two 56mm Pi stacks and UGREEN')
text.append('')
text.append(f'Mesh: see log.checkMesh; 150159 cells, Mesh OK')
text.append(f'Inlet volumetric flow magnitude: {inlet_q:.6f} m^3/s')
text.append(f'Rear outlet flow: {rear_q:.6f} m^3/s ({100*rear_q/max(total_out,1e-30):.1f}% of outlet flow)')
text.append(f'Top outlet flow: {top_q:.6f} m^3/s ({100*top_q/max(total_out,1e-30):.1f}% of outlet flow)')
text.append(f'Outlet/inlet balance: {100*total_out/max(inlet_q,1e-30):.1f}%')
text.append('')
text.append(f'Area-weighted speed on left Pi block: avg {piL[0]:.4f} m/s, max face {piL[1]:.4f} m/s')
text.append(f'Area-weighted speed on right Pi block: avg {piR[0]:.4f} m/s, max face {piR[1]:.4f} m/s')
text.append(f'Area-weighted speed on UGREEN block: avg {ug[0]:.4f} m/s, max face {ug[1]:.4f} m/s')
text.append('')
text.append('Interpretation: airflow reaches both Pi envelopes with roughly symmetrical wall speeds; top and rear outlets share extraction rather than one path completely starving the other.')
text.append('Caveats: front inlet is whole-front simplified, top outlet is whole-top simplified, fan curves and thermal loads are not modelled yet.')
out.write_text('\n'.join(text)+'\n')
print(out)
print(out.read_text())
