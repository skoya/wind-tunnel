# CHANGELOG.md

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
