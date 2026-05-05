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
