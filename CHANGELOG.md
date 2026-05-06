# CHANGELOG.md

## v2.17 - 2026-05-06

- Vented Pi cassette trays with long airflow slots through the cassette floors; verified each cassette exports as one connected component.
- Removed UGREEN straps and strap towers/fixtures; UGREEN now rests in the low cradle/side keepers.
- Added top fan guard between the upward fan and Mac mini. It is a lightweight lid-integrated Noctua-style grid rather than a second raw imported Noctua STL, because importing the high-triangle grille twice caused OpenSCAD assembly exports to time out.
- Revalidated clearances encoded in CAD: Pi ghost top at 109mm, top fan bottom at 135mm, leaving 26mm modelled clearance; front cassette has 26.2mm pocket depth for a 25mm fan and 124.5mm mounting-hole spacing.
- Re-exported printable STLs and preview STLs with no warnings; all printable parts are single connected components.

## v2.16 - 2026-05-05

- Confirmed stack order for front airflow: outside/fingers/dust side has the Noctua grille; fan ghost is now behind it inside the cassette pocket, blowing into the duct.
- Slimmed walls/floor/front cassette clips further: walls 1.8mm, base floor 5mm, smaller front tongues/receiver rails/screw bosses.
- Added more side-wall fan cable clips sized for Noctua USB fan leads routing back to the Pi USB area; removed isolated rear slack clips that created disconnected islands.
- Lowered Mac mini support elevation: top fan remains under the lid, Mac now has a modest 10mm outlet plenum rather than a tall perch.
- Fixed reintroduced disconnected tongue/clip islands; exports have no warnings and main printable parts are single connected components.

## v2.13 - 2026-05-05

- Reduced plastic: wall thickness 2.4mm → 2.0mm, base floor 8mm → 6mm, body height 164mm → 160mm, smaller Pi gantry posts/beams, leaner Mac risers, smaller cassette screw bosses, lighter Pi cassettes/UGREEN straps.
- Added STL preview exports: `fitted_parts_preview.stl`, `fitted_with_hardware_preview.stl`, and `front_fan_cassette_body.stl`.
- Updated the browser STL viewer dropdown to include fitted/full assembly preview options.
- Fixed simplified Pi cassette pull lip overlap so fitted preview exports as one connected component.
- Added `PRINT_NOTES.md` explaining PETG settings and Support PLA usage as slicer support-interface material, not something encoded in STL.

## v2.12 - 2026-05-05

- Re-integrated the scaled Noctua grille into `front_fan_cassette.stl` so the cassette and grille print as one part.
- Kept the cassette intake open behind the grille with a large circular/square relief through-cut.
- Simplified Pi cassettes to low trays: base/side guides/rear stop only, no tall top retention rails.
- Added `fitted_parts` preview mode for the assembled printable modules.
- Added `fitted_with_hardware` preview mode showing Mac mini, UGREEN, Pi stacks, and both 140mm fan ghosts fitted together.
- Regenerated STLs and previews with no export warnings; printable single modules are one connected component except `ugreen_straps.stl`, which intentionally contains two straps.

## v2.10 - 2026-05-05

- Split the Noctua grille out as a separate removable printable part: `front_noctua_grille.stl`.
- Removed the fused/imported grille from `front_fan_cassette.stl`; the cassette now has a visibly open 132mm circular intake.
- Added `front_noctua_grille` to export/validation scripts and `parts_manifest.json`.
- Regenerated STLs and validation outputs with no export warnings.

## v2.9 - 2026-05-05

- Added Bobby-supplied `references/noctua_120mm_high_efficiency_grill.stl`.
- Imported the real Noctua 120mm high-efficiency grille into the front cassette and scaled it to the 140mm fan envelope.
- Added small connector pads so the imported grille and cassette body export as one connected printable component.
- Regenerated all STLs: component check passes for all single printable modules; `ugreen_straps.stl` remains two intentional strap components.
- Export completed without OpenSCAD warnings.

## v2.8 - 2026-05-05

- Reduced material by lowering wall thickness from 3.0mm to 2.4mm, reducing the base floor from 14mm to 8mm, and trimming body height from 172mm to 164mm while retaining top-fan/Pi clearance.
- Replaced the crude front grille with a Noctua-inspired swept radial grille: curved struts, outer/inner connection rings, and screw-pad bridges.
- Regenerated STLs with no OpenSCAD export warnings.
- Connected-component check: all single printable parts are one component; `ugreen_straps.stl` intentionally has two components because it contains two separate straps.
- Approximate solid volume dropped from ~1694cm³ to ~1486cm³ across exported STLs, about 12% less before slicer infill settings.

## v2.7 - 2026-05-05

- Ran connected-component checks on exported STLs and removed actual disconnected/floating islands.
- Rebuilt the front cassette boolean so the fan pocket/opening is cut first and the grille is added back as real connected open bars.
- Connected UGREEN side keepers and strap towers down to the base deck.
- Removed floating upper receiver nubs from the base; retention now lives on the removable Pi cassettes.
- Rebuilt Pi cassettes as connected, OpenSCAD-simple meshes with no export warnings.
- Reworked UGREEN strap cutout so each strap is one connected frame; the straps STL intentionally contains two separate straps.

## v2.6 - 2026-05-05

- Changed top fan topology: the 140x25mm fan now mounts underneath the lid, inside the upper duct, rather than occupying the Mac saddle support volume.
- Raised the base duct height to leave roughly 16mm clearance between Pi cassette top and the underside of the top fan envelope.
- Reworked top fan geometry to low screw/locator pads rather than a solid block.
- Preserved an 18mm outlet plenum between the lid/top-fan outlet and Mac mini guide rails.
- Validated and regenerated all printable STLs and preview renders after the topology change.

## v2.5 - 2026-05-05

- Added printable gantry supports under the elevated Pi cassette receiver rails; the guides no longer float above the UGREEN bay.
- Support posts sit outside the UGREEN footprint and cross-beams sit above the UGREEN top clearance.
- Validated and regenerated all printable STLs plus preview renders after the support fix.

## v2.4 - 2026-05-05

- Enlarged the base and front cassette height back to a true 140mm fan envelope.
- Hollowed the rear of the front fan cassette with a 25mm fan pocket for mounting a real Noctua-style 140mm fan.
- Kept screw-through mounting holes and a 126mm circular airflow opening through the printed front grille/filter face.

## v2.3 - 2026-05-05

- Lowered Pi cassette rear pull lips from 11mm to 7mm so installed cassettes clear the physically seated lid envelope.
- Reworked front fan cassette receivers into real side-wall clearance channels instead of solid butt blocks.
- Corrected the UGREEN inspection ghost to match the cradle support height.
- Changed the default assembly view to show physically seated lid and front cassette placement rather than a semi-exploded inspection pose.
- Installed OpenSCAD CLI on the Pi, validated all six printable modules, regenerated STLs, and added hosted preview assets under `preview/`.
- Remaining print-critical measurements are still required before final print: exact UGREEN enclosure, Pi/HAT stack thickness, fan model/hole spacing, rear plug/bend depths, and Mac mini M4 power-button position.

## v2.2 - 2026-05-04

- Replaced the front KOYA text grille with a decorative diamond/ring support pattern.
- Revised the front fan grille again to a more circular radial/ring pattern.
- Revised the front fan grille to a curved swirl/ring pattern.
- Added a rear-loading filter-media pocket to the front fan cassette; printed plastic supports the filter, removable mesh/foam performs dust capture.
- Added four corner Mac saddle stanchions so the Mac guide rails visibly sit on the lid/top-fan-frame perimeter while leaving the central underside airflow path open.
- Shortened UGREEN support legs by reducing the underside tunnel from 24mm to 14mm, lowering the UGREEN and Pi stack.
- Recessed the top 140mm fan frame 10mm into the lid/ceiling and compacted the base duct height.
- Reduced case depth from 238mm to 208mm and rear plenum from 50mm to 28mm.
- Removed the internal fan splitter and guide vanes to keep the Pi airflow path open and less visually cluttered.
- Replaced cube fan ghosts with Noctua-style 140mm inspection ghosts showing frame, round opening, hub, struts, blades, pads and screw holes.
- Added named join-detail modules for front cassette receivers and lid support rails.
- Added `assembly_exploded` export plus inspection script output so connector directions are visible in OpenSCAD/STL review.
- Added side-wall fan cable clips and inspection ghost routes for front/top USB fan leads to rear Pi USB area, avoiding the primary airflow stream.
- Kept the post-fan duct open after the 140mm front fan.
- Reworked the UGREEN cradle to side rails only, with no solid shelf and no crosswise front/rear stops blocking enclosure grilles.
- Replaced continuous UGREEN support rails with thin peg legs and small pads to open the underside airflow path.
- Added a clear lower airflow tunnel under the UGREEN enclosure using side tunnel rails.
- Removed the rear cable comb posts from the primary airflow stream and enlarged the rear exhaust/cable opening.
- Increased Mac saddle lift to give roughly 18mm clear plenum above a 25mm top fan in the assembly view.
- Increased base duct height to the 140mm fan envelope and corrected Pi cassette assembly placement so holders sit below the upper fan volume.
- Reworked Pi receivers and cassettes from full-height rails to low-profile edge guides with small upper anti-tip tabs.
- Added a separate assembly-inspection export script for reviewing how modules fit together without treating the assembly as printable.
- Aligned UGREEN strap export geometry with base duct strap towers in the assembly.
- Added vertical strap-tower screw clearance through the base duct UGREEN cradle.
- Added Bambu Lab P1S build-volume assertions for individual printable modules.
- Validated and exported all six printable modules with OpenSCAD CLI.
- Dimensions still requiring real-world measurement: UGREEN bare enclosure, assembled Pi + Waveshare HAT stack thickness, exact 140mm fan model/hole spacing, rear cable plug depths and bend radii, and Mac mini M4 power-button position.

## v2.1

- Corrected UGREEN to sit below the Pi cassettes.
- Corrected Pi cassettes to sit above UGREEN bay.
- Clipped KOYA grille within front fan cassette face.
- Kept Mac mini saddle as corner-guide only to preserve underside airflow.
- Kept rear open for exhaust and cable routing.

## Next

- Validate with real hardware measurements.
- Export individual printable STLs.
- Slice on Bambu P1S.
