# AGENTS.md

## Mission

You are helping build a modular OpenSCAD design for a desktop cooling stand / airflow plinth named **KOYA Cooling Stand**.

The product should:
- Hold and cool **2× Raspberry Pi 5** units.
- Each Pi 5 uses a **Waveshare PoE M.2 HAT+ B** and is PoE-powered.
- Hold a **UGREEN Thunderbolt/USB-C NVMe enclosure** below the Pi stacks.
- Use a **front 140mm USB-powered Noctua-style fan** to push air through the Pi/UGREEN duct.
- Support an **Apple Mac mini M4** on top in low guide rails.
- Use a **second top 140mm fan** to gently blow air upward toward the Mac mini underside.
- Keep all rear cable routing open and serviceable.
- Use a front finger-safe grille with **KOYA** integrated into the grille design.
- Be printable on a **Bambu Lab P1S**.

## Current source file

Start from:

`dual_pi5_macmini_v2_1_corrected_stack_koya.scad`

If that file is not present, ask the user to copy it into the repo root before making geometry changes.

## Non-negotiable design requirements

### Assembly and serviceability

Do not make the case one solid object.

Required separate printable modules:
- `base_duct`
- `front_fan_cassette`
- `lid_mac_saddle`
- `pi_cassette_left`
- `pi_cassette_right`
- `ugreen_straps`

The assembly view is only for inspection. It must not be treated as a printable part.

### Airflow

Front airflow:
- A 140mm front fan defines the main pressure duct.
- The duct should be close to the fan outline, not a wide tray.
- Air should flow front-to-back.
- Rear should remain open for exhaust and cables.
- No random side/top vents unless explicitly requested.

UGREEN:
- The UGREEN enclosure sits below the Pi stacks.
- It must have air clearance above and below.
- It must not collide with the Pi cassettes.
- Prefer rails/straps, not a solid shelf.

Raspberry Pis:
- The Pis sit above the UGREEN bay.
- The Pi holders must not obstruct the Pi faces/components.
- Prefer edge-guides, slide-in cassettes and light retention tabs.
- Leave rear plenum room for 2× PoE Ethernet plugs and bend radius.

Mac mini:
- Use Apple Mac mini M4 dimensions: 127mm × 127mm × 50mm unless updated by user measurement.
- Mac mini sits on top in corner/edge guides only.
- Do not enclose the Mac mini.
- Do not block the Mac mini underside intake area.
- Rear Mac exhaust/cables must remain open.
- Include access for the bottom power button.

### Front grille

The front grille must:
- Be contained within the front fan cassette face.
- Not overspill beyond the case edges.
- Include the word `KOYA` as a structural/finger-guard element.
- Prioritise airflow over decorative density.

### Rounded styling

External edges should be rounded/softened where feasible.
Avoid sharp slab-like aesthetics.

## OpenSCAD style rules

- Keep geometry parametric.
- Keep dimensions near the top of the file.
- Use named modules.
- Do not hard-code magic numbers deep inside modules unless unavoidable.
- Add comments where a dimension relates to real hardware.
- Keep `EXPORT_PART` as the main export switch.
- Keep `SHOW_GHOSTS` for assembly inspection.
- Avoid complex fragile geometry if a simpler printable shape works.

## Printability rules for Bambu P1S

Target material:
- Prefer PETG for structural parts.
- PLA is acceptable only for non-heat-critical prototypes.
- Avoid ABS/ASA unless the user explicitly wants it and has ventilation/warping handled.

Design for:
- 0.4mm nozzle.
- 0.2mm layer height.
- 3–4 walls.
- 20–30% gyroid infill.
- Minimal supports.
- Flat-bottom orientation where possible.
- Avoid long unsupported bridges over fan openings unless broken up with ribs.

Recommended tolerances:
- Sliding fit clearance: 0.4–0.6mm.
- Loose hardware clearance: 0.6–1.0mm.
- Do not make snap-fit retention aggressive; PETG tabs should be gentle.

## Validation checklist before any final STL export

Before claiming the design is ready to print, inspect/check:

- [ ] `base_duct` renders without errors.
- [ ] `front_fan_cassette` renders without errors.
- [ ] `lid_mac_saddle` renders without errors.
- [ ] `pi_cassette_left` and `pi_cassette_right` render without errors.
- [ ] `ugreen_straps` renders without errors.
- [ ] Assembly view shows no collision between UGREEN and Pi cassettes.
- [ ] Front KOYA grille does not overspill beyond front cassette.
- [ ] Mac mini guides do not cover the central underside airflow path.
- [ ] Rear plenum has enough room for cables.
- [ ] All modules fit inside Bambu P1S build volume when exported individually.
- [ ] Notes clearly mark any dimensions still needing real-world measurement.

## Required user-measured dimensions before final print

Ask the user for these if they have not been supplied:
- Exact UGREEN enclosure length/width/height without silicone case.
- Exact assembled Pi + Waveshare HAT stack thickness.
- Exact 140mm Noctua fan model and mounting hole spacing.
- Ethernet plug depth from Pi rear.
- USB-C/TB cable plug depth and bend radius from UGREEN rear.
- Mac mini M4 power button position relative to rear/side edges.

## Commands

Use these scripts when available:
- `scripts/export_parts.sh`
- `scripts/validate_scad.sh`

Assume OpenSCAD CLI is available as `openscad`. If not, explain how to install/configure it rather than faking outputs.

## Output discipline

When making changes:
1. Explain the design intent.
2. Modify the `.scad` file.
3. Export or validate each printable part.
4. Provide a short collision/printability summary.
5. Update `CHANGELOG.md`.

Never say “ready to print” unless the validation checklist has passed and the user-measured dimensions are reflected in the parameters.
