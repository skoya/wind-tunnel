# Surface Pro 9 heatsink/fan cooling stand v1

Designed around Bobby's actual stack:

- Surface Pro 9 rests directly on aluminium.
- Heatsink: 300 x 140 x 20 mm, flat face up.
- Noctua fan: 200 x 200 x 30 mm underneath.
- Printed parts only locate/support the metal and fan; they do not sit between Surface and heatsink.

## Parts

Print:

- `left_rail_v1.stl`
- `right_rail_v1.stl`
- `fan_tray_front_v1.stl`
- `fan_tray_rear_v1.stl`
- `front_lip_v1.stl`
- `rear_keeper_v1.stl`

Inspection/reference:

- `surface9_heatsink_fan_stand_v1.scad`
- `assembly_v1.stl` - includes translucent/reference solids for fan/heatsink/Surface footprint
- `printable_frame_v1.stl` - printed parts assembled only

## Assembly concept

1. Join the two fan-tray halves with small screws, zip ties, or CA glue at the overlap tabs.
2. Mount the 200mm Noctua fan in the tray. The model includes 154mm and 170mm square hole patterns.
3. Place the heatsink flat face up in the side rails. It sits above the fan with a small air gap.
4. Add the low front lip so the Surface cannot slide forward.
5. Optional: add thin felt/rubber to the lip and rail contact points. Do not add anything between the Surface and aluminium contact face.

## Print guidance

- PETG or ABS/ASA preferred because this lives near heat. PLA may creep over time.
- 0.2mm layers, 3-4 perimeters, 25-35% infill is fine.
- Fan tray halves are about 216mm wide, intentionally trimmed to fit common 220mm beds with careful skirt/brim settings.
- Rails are separate so the 300mm heatsink does not force a 300mm print.

## Notes

The fan is larger than the heatsink depth, so it intentionally protrudes front/rear. That makes the base more stable and keeps the stand from becoming a tall ugly tower. The visual aim is matte black rails/tray with the aluminium slab doing the useful work.
