# KOYA Cooling Stand — Bambu/P1S print notes

## Material
- Main parts: PETG recommended.
- PLA is fine for quick fit prototypes, but PETG is safer near warm electronics/fans.

## Support PLA / support interface
STL files cannot reliably encode “use Support PLA here” or assign internal support material. Do this in Bambu Studio/Orca instead:

- Main filament: PETG.
- Support filament/interface: Support PLA or PLA only as **support interface**, not as structural infill.
- Use supports only where slicer genuinely requires them; the model is being kept support-light.
- For PETG + PLA support interface, leave a small interface gap according to your slicer profile and dry both filaments.

Recommended starting point:
- 0.4mm nozzle
- 0.2mm layer height
- 4–5 walls for structural parts
- 20–25% gyroid infill
- 5 top / 5 bottom layers
- Brim optional for tall parts

## Print orientation
- `base_duct.stl`: flat on base.
- `front_fan_cassette.stl`: rear fan pocket facing up or as slicer suggests; inspect grille bridging.
- `lid_mac_saddle.stl`: flat lid side down where possible.
- `pi_cassette_left/right.stl`: flat tray side down.
- `upper_mac_fan_bridge.stl`: flat on the broad bridge face; inspect fan-guard bridging.

## Mac mini M4 power rocker

- `mac_power_rocker.stl` is a separate moving part.
- Fit it into the rear hinge cheeks on `lid_mac_saddle.stl` with an M3 screw or short filament pin.
- The orange/red preview marker is only an approximate Mac underside power-button target; confirm against the real Mac before committing to a long final print.
- If the button is off, adjust `mac_power_button_x` / `mac_power_button_y` in the SCAD file.

## Reminder
Do not print preview/assembly STLs. They are for visual inspection only. UGREEN straps were removed in v2.17; the enclosure now sits in the cradle/side keepers.
