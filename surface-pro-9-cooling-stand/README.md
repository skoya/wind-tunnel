# Surface Pro 9 heatsink/fan cooling stand

Current recommended version: **v2**.

Designed around Bobby's actual stack:

- Surface Pro 9 rests directly on aluminium.
- Heatsink: **300 x 140 x 20 mm**, flat face up.
- Noctua fan: **200 x 200 x 30 mm** underneath.
- Printed parts locate/support the metal and fan; they do **not** sit between Surface and heatsink.



## v3 - smoother enclosed version

Current aesthetic candidate: **v3**.

v3 keeps the v2 airflow/fastening logic but makes the stand less like scaffolding:

- rounded charcoal side shrouds and front/rear fascias;
- warm Noctua-style accent on the front catch and removable dust grille;
- fan is mostly hidden in normal use;
- side/front/rear vents keep airflow moving without exposing the whole fan;
- removable `bottom_dust_grille_v3.stl` lets you access the fan for dust cleaning;
- Surface still touches only the exposed aluminium heatsink.

Print for v3:

- `left_rail_v3.stl`
- `right_rail_v3.stl`
- `fan_tray_front_v3.stl`
- `fan_tray_rear_v3.stl`
- `front_lip_v3.stl`
- `rear_keeper_v3.stl`
- `bottom_dust_grille_v3.stl`

Inspect:

- `surface9_heatsink_fan_stand_v3.scad`
- `assembly_v3.stl`
- `preview_v3.png`
- `surface-pro-9-cooling-stand-v3.zip`

## Why v2 exists

v1 proved the layout, but had two real problems:

1. The fan did not have an explicit intake path if the tray sat flat on a desk.
2. The parts were not clearly fastened together.

v2 fixes both.

## v2 parts to print

Print these:

- `left_rail_v2.stl`
- `right_rail_v2.stl`
- `fan_tray_front_v2.stl`
- `fan_tray_rear_v2.stl`
- `front_lip_v2.stl`
- `rear_keeper_v2.stl`

Inspection/reference:

- `surface9_heatsink_fan_stand_v2.scad`
- `assembly_v2.stl` - assembled preview with reference solids for fan/heatsink/Surface
- `printable_frame_v2.stl` - assembled printed parts only

## v2 airflow

The fan tray is lifted **14mm off the desk** on printed feet. That creates an underside intake plenum so the 200mm fan can draw air from below instead of being choked against the table.

Air path:

`room air -> 14mm underside plenum -> fan -> 6mm upper gap -> heatsink fins/underside -> out through open sides/front/rear`

The fan opening is cut through the tray, and the sides are deliberately open rather than boxed in.

## v2 attachment scheme

Use M3 screws/nuts, small self-tappers, or zip ties through the provided holes. Screws are cleaner; zip ties are fine for a first fit.

- **Fan tray front + rear halves**
  - Overlap at the centre seam.
  - Use the centre tab holes to bolt/zip-tie the two halves together.

- **Fan to tray**
  - Fan holes include common 200mm fan mount patterns: **154mm** and **170mm** square.
  - Use whichever aligns with the Noctua frame.

- **Rails to tray**
  - Left/right rails now have inward outrigger tabs.
  - These align with holes near the left/right edges of the fan tray.
  - This turns the tray and rails into one assembly, rather than loose parts around the heatsink.

- **Front lip to tray**
  - The front lip has two vertical risers that bolt/zip-tie down into the front tray holes.
  - Its upper catch stops the Surface sliding forward.

- **Rear keeper to tray**
  - The rear keeper has two vertical risers that bolt/zip-tie into the rear tray holes.
  - It locates the heatsink from the back without touching the Surface face.

- **Heatsink**
  - Drops into the rails, flat face up.
  - Printed shelves/posts support the edges/underside.
  - The aluminium top remains exposed and is the tablet contact surface.

## Print guidance

- PETG, ABS, or ASA preferred. PLA may creep over time near heat.
- 0.2mm layers, 3-4 perimeters, 25-35% infill.
- Fan tray halves are about **216 x 108 x 23mm** each.
- Rails are about **78 x 174 x 72mm** each.
- Lip/keeper include vertical risers; use brim if your printer dislikes tall narrow pieces.

## Files

The original v1 files are retained for comparison. Use v2 unless you specifically want the simpler unfastened concept.
