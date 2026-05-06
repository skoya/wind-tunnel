#!/usr/bin/env python3
from pathlib import Path
import xml.etree.ElementTree as ET
import numpy as np

path=Path('openfoam/koya_airflow_simple/VTK_ASCII/koya_airflow_simple_250/internal.vtu')
out=Path('openfoam/koya_airflow_simple/openfoam_internal_zone_summary.txt')
root=ET.parse(path).getroot()
piece=root.find('.//Piece')
pts=np.fromstring(piece.find('./Points/DataArray').text or '', sep=' ').reshape((-1,3))
U=None
pd=piece.find('./PointData')
for da in pd.findall('DataArray'):
    if da.attrib.get('Name')=='U':
        U=np.fromstring(da.text or '', sep=' ').reshape((-1,3)); break
if U is None: raise SystemExit('No point U')
speed=np.linalg.norm(U,axis=1)

def zone(name, x0,x1,y0,y1,z0,z1):
    m=(pts[:,0]>=x0)&(pts[:,0]<=x1)&(pts[:,1]>=y0)&(pts[:,1]<=y1)&(pts[:,2]>=z0)&(pts[:,2]<=z1)
    s=speed[m]
    return name, int(m.sum()), float(np.mean(s)), float(np.percentile(s,50)), float(np.percentile(s,90)), float(np.max(s))
# zones around/near the hardware, metres
zones=[
 zone('left Pi neighbourhood',0.034,0.078,0.060,0.156,0.055,0.122),
 zone('right Pi neighbourhood',0.076,0.120,0.060,0.156,0.055,0.122),
 zone('centre gap between Pis',0.073,0.081,0.066,0.151,0.061,0.117),
 zone('over Pi tops / under top fan',0.030,0.124,0.060,0.156,0.117,0.135),
 zone('UGREEN neighbourhood',0.045,0.109,0.060,0.190,0.014,0.048),
 zone('front plenum before Pis',0.010,0.144,0.036,0.064,0.030,0.140),
]
lines=['OpenFOAM internal velocity zone summary','Point-sampled speeds from VTK_ASCII/internal.vtu at t=250','']
for name,n,avg,med,p90,mx in zones:
    lines.append(f'{name}: n={n}, avg={avg:.4f} m/s, median={med:.4f}, p90={p90:.4f}, max={mx:.4f}')
out.write_text('\n'.join(lines)+'\n')
print(out)
print(out.read_text())
