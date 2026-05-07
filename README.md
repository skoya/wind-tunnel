# KOYA Cooling Stand

Modular OpenSCAD design for a dual Raspberry Pi 5 + UGREEN NVMe + Mac mini M4 airflow stand.

## Hardware concept

- Front 140mm USB-powered fan cools the lower duct.
- UGREEN Thunderbolt/USB-C NVMe enclosure sits below the Pi stacks.
- Two Raspberry Pi 5 + Waveshare PoE M.2 HAT+ B stacks sit above the UGREEN bay.
- Mac mini M4 sits on top in low guide rails.
- Second 140mm fan blows upward toward the Mac mini underside.
- Rear remains open for exhaust and cable routing.

## Main CAD file

Place this in the repo root:

`dual_pi5_macmini_v2_1_corrected_stack_koya.scad`

## Exporting parts

```bash
bash scripts/export_parts.sh dual_pi5_macmini_v2_1_corrected_stack_koya.scad
```

Exports go into `exports/`.

## Validating

```bash
bash scripts/validate_scad.sh dual_pi5_macmini_v2_1_corrected_stack_koya.scad
```

## Important

The assembly export is for inspection only. Print individual parts.

### Support-light base notes

The Pi cassette support is now a separate `pi_frame_bridge` part. The base has four low PLA clip pegs around the UGREEN bay, avoiding the old integrated cantilever gantry and avoiding screws/inserts.

Recommended print/assembly order:

1. Print `base_duct.stl` upright.
2. Print `pi_frame_bridge.stl` as exported; it is flipped upside-down so the cross beams sit on the bed and the posts grow upward.
3. Press the Pi frame C-slotted feet down over the four tapered PLA pegs on the base.
4. Slide/fit the Pi cassettes into the removable frame.

Cable management in the base should use the floor zip-tie slots rather than printed overhanging cable lips.
