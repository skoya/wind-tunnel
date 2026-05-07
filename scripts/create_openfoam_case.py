#!/usr/bin/env python3
from pathlib import Path

case = Path('openfoam/koya_airflow_simple')
(case/'system').mkdir(parents=True, exist_ok=True)
(case/'constant/triSurface').mkdir(parents=True, exist_ok=True)
(case/'0').mkdir(parents=True, exist_ok=True)

# metres
body_w=0.154; body_d=0.208; body_h=0.160
ugreen=(0.052,0.064,0.019, 0.102,0.186,0.043)
piL=(0.033,0.066,0.061, 0.067,0.151,0.117)
piR=(0.087,0.066,0.061, 0.121,0.151,0.117)

def write_box_stl(path, name, box):
    x0,y0,z0,x1,y1,z1=box
    v=[(x0,y0,z0),(x1,y0,z0),(x1,y1,z0),(x0,y1,z0),(x0,y0,z1),(x1,y0,z1),(x1,y1,z1),(x0,y1,z1)]
    # outward-ish triangles
    faces=[(0,2,1),(0,3,2), (4,5,6),(4,6,7), (0,1,5),(0,5,4), (1,2,6),(1,6,5), (2,3,7),(2,7,6), (3,0,4),(3,4,7)]
    with open(path,'w') as f:
        f.write(f'solid {name}\n')
        for a,b,c in faces:
            f.write('  facet normal 0 0 0\n    outer loop\n')
            for i in (a,b,c): f.write('      vertex %.9g %.9g %.9g\n'%v[i])
            f.write('    endloop\n  endfacet\n')
        f.write(f'endsolid {name}\n')

write_box_stl(case/'constant/triSurface/piLeft.stl','piLeft',piL)
write_box_stl(case/'constant/triSurface/piRight.stl','piRight',piR)
write_box_stl(case/'constant/triSurface/ugreen.stl','ugreen',ugreen)

header='''/*--------------------------------*- C++ -*----------------------------------*\\
| =========                 | OpenFOAM case generated for KOYA airflow check   |
\\*---------------------------------------------------------------------------*/\n'''

(case/'system/blockMeshDict').write_text(header+f'''
FoamFile {{ version 2.0; format ascii; class dictionary; object blockMeshDict; }}
scale 1;
vertices
(
    (0 0 0) ({body_w} 0 0) ({body_w} {body_d} 0) (0 {body_d} 0)
    (0 0 {body_h}) ({body_w} 0 {body_h}) ({body_w} {body_d} {body_h}) (0 {body_d} {body_h})
);
blocks
(
    hex (0 1 2 3 4 5 6 7) (31 42 32) simpleGrading (1 1 1)
);
edges ();
boundary
(
    inlet {{ type patch; faces ((0 4 5 1)); }}
    rearOutlet {{ type patch; faces ((3 2 6 7)); }}
    topOutlet {{ type patch; faces ((4 7 6 5)); }}
    walls {{ type wall; faces ((0 1 2 3) (0 3 7 4) (1 5 6 2)); }}
);
mergePatchPairs ();
''')

(case/'system/surfaceFeatureExtractDict').write_text(header+'''
FoamFile { version 2.0; format ascii; class dictionary; object surfaceFeatureExtractDict; }
piLeft.stl { extractionMethod extractFromSurface; extractFromSurfaceCoeffs { includedAngle 150; } writeObj no; }
piRight.stl { extractionMethod extractFromSurface; extractFromSurfaceCoeffs { includedAngle 150; } writeObj no; }
ugreen.stl { extractionMethod extractFromSurface; extractFromSurfaceCoeffs { includedAngle 150; } writeObj no; }
''')

(case/'system/snappyHexMeshDict').write_text(header+'''
FoamFile { version 2.0; format ascii; class dictionary; object snappyHexMeshDict; }
#includeEtc "caseDicts/mesh/generation/snappyHexMeshDict.cfg"
castellatedMesh on;
snap on;
addLayers off;
geometry
{
    piLeft.stl { type triSurfaceMesh; name piLeft; }
    piRight.stl { type triSurfaceMesh; name piRight; }
    ugreen.stl { type triSurfaceMesh; name ugreen; }
    piRefine { type box; min (0.025 0.050 0.050); max (0.130 0.165 0.130); }
}
castellatedMeshControls
{
    features
    (
        { file "piLeft.eMesh"; level 1; }
        { file "piRight.eMesh"; level 1; }
        { file "ugreen.eMesh"; level 1; }
    );
    refinementSurfaces
    {
        piLeft { level (1 2); patchInfo { type wall; } }
        piRight { level (1 2); patchInfo { type wall; } }
        ugreen { level (1 2); patchInfo { type wall; } }
    }
    refinementRegions
    {
        piRefine { mode inside; levels ((1E15 1)); }
    }
    locationInMesh (0.010 0.010 0.010);
}
snapControls { explicitFeatureSnap true; implicitFeatureSnap false; }
addLayersControls {}
meshQualityControls {}
writeFlags ( noRefinement );
mergeTolerance 1e-6;
''')


(case/'system/meshQualityDict').write_text('/*--------------------------------*- C++ -*----------------------------------*\\\n| =========                 |                                                 |\n| \\\\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox           |\n|  \\\\    /   O peration     | Version:  v1912                                 |\n|   \\\\  /    A nd           | Website:  www.openfoam.com                      |\n|    \\\\/     M anipulation  |                                                 |\n\\*---------------------------------------------------------------------------*/\nFoamFile\n{\n    version     2.0;\n    format      ascii;\n    class       dictionary;\n    object      meshQualityDict;\n}\n// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //\n\n#includeEtc "caseDicts/mesh/generation/meshQualityDict.cfg"\n\n//- minFaceWeight (0 -> 0.5)\n//minFaceWeight 0.02;\n\n// ************************************************************************* //\n')

(case/'system/controlDict').write_text(header+'''
FoamFile { version 2.0; format ascii; class dictionary; object controlDict; }
application simpleFoam;
startFrom startTime;
startTime 0;
stopAt endTime;
endTime 250;
deltaT 1;
writeControl timeStep;
writeInterval 250;
purgeWrite 0;
writeFormat ascii;
writePrecision 7;
writeCompression off;
timeFormat general;
timePrecision 6;
runTimeModifiable true;
''')

(case/'system/fvSchemes').write_text(header+'''
FoamFile { version 2.0; format ascii; class dictionary; object fvSchemes; }
ddtSchemes { default steadyState; }
gradSchemes { default Gauss linear; }
divSchemes
{
    default none;
    div(phi,U) bounded Gauss upwind;
    div(phi,k) bounded Gauss upwind;
    div(phi,epsilon) bounded Gauss upwind;
    div((nuEff*dev2(T(grad(U))))) Gauss linear;
}
laplacianSchemes { default Gauss linear corrected; }
interpolationSchemes { default linear; }
snGradSchemes { default corrected; }
wallDist { method meshWave; }
''')

(case/'system/fvSolution').write_text(header+'''
FoamFile { version 2.0; format ascii; class dictionary; object fvSolution; }
solvers
{
    p { solver GAMG; tolerance 1e-7; relTol 0.05; smoother GaussSeidel; }
    pFinal { $p; relTol 0; }
    "(U|k|epsilon)" { solver smoothSolver; smoother symGaussSeidel; tolerance 1e-8; relTol 0.1; }
    "(U|k|epsilon)Final" { $U; relTol 0; }
}
SIMPLE
{
    nNonOrthogonalCorrectors 0;
    consistent yes;
    residualControl
    {
        p 1e-3;
        U 1e-4;
        "(k|epsilon)" 1e-4;
    }
}
relaxationFactors
{
    equations { U 0.7; k 0.7; epsilon 0.7; }
}
''')

(case/'constant/transportProperties').write_text(header+'''
FoamFile { version 2.0; format ascii; class dictionary; object transportProperties; }
transportModel Newtonian;
nu [0 2 -1 0 0 0 0] 1.5e-05;
''')
(case/'constant/turbulenceProperties').write_text(header+'''
FoamFile { version 2.0; format ascii; class dictionary; object turbulenceProperties; }
simulationType RAS;
RAS { RASModel kEpsilon; turbulence on; printCoeffs on; }
''')

def field(name, cls, dims, internal, boundaries):
    txt=header+f'''FoamFile {{ version 2.0; format ascii; class {cls}; object {name}; }}
dimensions {dims};
internalField uniform {internal};
boundaryField
{{
'''
    for patch,body in boundaries.items():
        txt+=f'    {patch}\n    {{\n{body}\n    }}\n'
    txt+='}\n'
    (case/'0'/name).write_text(txt)

field('U','volVectorField','[0 1 -1 0 0 0 0]','(0 0.8 0)',{
'inlet':'        type fixedValue;\n        value uniform (0 0.8 0);',
'rearOutlet':'        type pressureInletOutletVelocity;\n        value uniform (0 0 0);',
'topOutlet':'        type pressureInletOutletVelocity;\n        value uniform (0 0 0);',
'walls':'        type noSlip;',
'piLeft':'        type noSlip;',
'piRight':'        type noSlip;',
'ugreen':'        type noSlip;',
})
field('p','volScalarField','[0 2 -2 0 0 0 0]','0',{
'inlet':'        type zeroGradient;',
'rearOutlet':'        type fixedValue;\n        value uniform 0;',
'topOutlet':'        type fixedValue;\n        value uniform 0;',
'walls':'        type zeroGradient;',
'piLeft':'        type zeroGradient;',
'piRight':'        type zeroGradient;',
'ugreen':'        type zeroGradient;',
})
field('k','volScalarField','[0 2 -2 0 0 0 0]','0.0024',{
'inlet':'        type fixedValue;\n        value uniform 0.0024;',
'rearOutlet':'        type inletOutlet;\n        inletValue uniform 0.0024;\n        value uniform 0.0024;',
'topOutlet':'        type inletOutlet;\n        inletValue uniform 0.0024;\n        value uniform 0.0024;',
'walls':'        type kqRWallFunction;\n        value uniform 0.0024;',
'piLeft':'        type kqRWallFunction;\n        value uniform 0.0024;',
'piRight':'        type kqRWallFunction;\n        value uniform 0.0024;',
'ugreen':'        type kqRWallFunction;\n        value uniform 0.0024;',
})
field('epsilon','volScalarField','[0 2 -3 0 0 0 0]','0.003',{
'inlet':'        type fixedValue;\n        value uniform 0.003;',
'rearOutlet':'        type inletOutlet;\n        inletValue uniform 0.003;\n        value uniform 0.003;',
'topOutlet':'        type inletOutlet;\n        inletValue uniform 0.003;\n        value uniform 0.003;',
'walls':'        type epsilonWallFunction;\n        value uniform 0.003;',
'piLeft':'        type epsilonWallFunction;\n        value uniform 0.003;',
'piRight':'        type epsilonWallFunction;\n        value uniform 0.003;',
'ugreen':'        type epsilonWallFunction;\n        value uniform 0.003;',
})
field('nut','volScalarField','[0 2 -1 0 0 0 0]','0',{
'inlet':'        type calculated;\n        value uniform 0;',
'rearOutlet':'        type calculated;\n        value uniform 0;',
'topOutlet':'        type calculated;\n        value uniform 0;',
'walls':'        type nutkWallFunction;\n        value uniform 0;',
'piLeft':'        type nutkWallFunction;\n        value uniform 0;',
'piRight':'        type nutkWallFunction;\n        value uniform 0;',
'ugreen':'        type nutkWallFunction;\n        value uniform 0;',
})

(case/'Allrun').write_text('''#!/usr/bin/env bash
set -eo pipefail
source /usr/share/openfoam/etc/bashrc
set -u
cd "$(dirname "$0")"
rm -rf constant/polyMesh [1-9]* postProcessing log.*
blockMesh | tee log.blockMesh
surfaceFeatureExtract | tee log.surfaceFeatureExtract
snappyHexMesh -overwrite | tee log.snappyHexMesh
checkMesh | tee log.checkMesh
simpleFoam | tee log.simpleFoam
foamToVTK -latestTime | tee log.foamToVTK
''')
(case/'Allrun').chmod(0o755)
print(case)
