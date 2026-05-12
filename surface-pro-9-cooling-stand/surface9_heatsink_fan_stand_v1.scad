/* Surface Pro 9 heatsink + Noctua 200mm cooling stand - v1

   Layout, matching Bobby's photo but inverted for use:
   - Noctua 200 x 200 x 30 fan is underneath.
   - Aluminium heatsink is above it, flat face UP, fins/downside toward fan.
   - Surface Pro 9 sits directly on the exposed aluminium top face.

   Real dimensions supplied:
   - Fan:      200 x 200 x 30 mm
   - Heatsink: 300 x 140 x 20 mm, wider than Surface Pro 9

   Design intent:
   - Printed parts do NOT sit between Surface and heatsink.
   - Side rails lightly locate the heatsink without covering the top contact face.
   - Fan tray is split front/rear so it fits ordinary 220mm-ish print beds.
   - The 200mm fan overhangs the 140mm heatsink depth; this is intentional and gives a stable base.
   - Low front lip stops the Surface sliding forward on the aluminium.

   Print parts with:
     openscad -o left_rail_v1.stl        -D 'PART="left_rail"'        surface9_heatsink_fan_stand_v1.scad
     openscad -o right_rail_v1.stl       -D 'PART="right_rail"'       surface9_heatsink_fan_stand_v1.scad
     openscad -o fan_tray_front_v1.stl   -D 'PART="fan_tray_front"'   surface9_heatsink_fan_stand_v1.scad
     openscad -o fan_tray_rear_v1.stl    -D 'PART="fan_tray_rear"'    surface9_heatsink_fan_stand_v1.scad
     openscad -o front_lip_v1.stl        -D 'PART="front_lip"'        surface9_heatsink_fan_stand_v1.scad
     openscad -o rear_keeper_v1.stl      -D 'PART="rear_keeper"'      surface9_heatsink_fan_stand_v1.scad
     openscad -o assembly_preview_v1.stl -D 'PART="assembly"'         surface9_heatsink_fan_stand_v1.scad
*/

PART = "assembly";
$fn = 72;

// ---------- Supplied hardware dimensions ----------
heatsink_w = 300;
heatsink_d = 140;
heatsink_h = 20;

fan_w = 200;
fan_d = 200;
fan_h = 30;
fan_opening = 184;
fan_mount_d = 4.6;        // clearance for M4-ish fan screws or zip-tie holes
fan_mount_patterns = [154, 170]; // common 200mm fan square mount spacings

// Surface Pro 9 approximation, for visual preview only
surface_w = 287;
surface_d = 209;
surface_t = 9.3;

// ---------- Printed stand dimensions ----------
wall = 5;
rail_w = 13;
clearance = 1.0;
base_margin = 8;
fan_tray_w = fan_w + 2*base_margin;   // 216, fits most 220mm beds with care
fan_tray_d = fan_d + 2*base_margin;   // 216
tray_t = 5;

// Fan is centred under the heatsink width and depth. Since fan_d > heatsink_d,
// the fan tray protrudes front/rear by ~42mm each side. This improves stability.
stand_w = heatsink_w + 2*rail_w + 2*clearance; // ~328
stand_d = fan_tray_d;
heatsink_x = (stand_w - heatsink_w)/2;
heatsink_y = (stand_d - heatsink_d)/2;
fan_x = (stand_w - fan_w)/2;
fan_y = (stand_d - fan_d)/2;

// Vertical stack: fan below, heatsink rests on four posts above fan.
// z=0 is bottom of fan tray. Top aluminium contact is at contact_z.
fan_bottom_z = tray_t;
fan_top_z = fan_bottom_z + fan_h;
air_gap = 6;              // gap above fan before heatsink underside/fins
heatsink_bottom_z = fan_top_z + air_gap;
contact_z = heatsink_bottom_z + heatsink_h;

// A mild recline can be added with stick-on rear feet; printed geometry here is flat
// so the heatsink makes predictable full contact with the tablet.

module rounded_box(size=[10,10,10], r=2) {
  // lightweight rounded rectangle extrusion; avoids huge OpenSCAD render time
  hull() {
    for (x=[r, size[0]-r]) for (y=[r, size[1]-r])
      translate([x,y,0]) cylinder(h=size[2], r=r);
  }
}

module screw_hole(h=20, d=4.6) { cylinder(h=h, d=d, center=false); }

module heatsink_reference() {
  color([0.75,0.76,0.72,0.55])
  translate([heatsink_x, heatsink_y, heatsink_bottom_z])
    cube([heatsink_w, heatsink_d, heatsink_h]);
}

module fan_reference() {
  color([0.45,0.30,0.16,0.38])
  translate([fan_x, fan_y, fan_bottom_z])
    cube([fan_w, fan_d, fan_h]);
}

module surface_reference() {
  color([0.03,0.04,0.05,0.35])
  translate([(stand_w-surface_w)/2, heatsink_y - (surface_d-heatsink_d)/2, contact_z])
    cube([surface_w, surface_d, surface_t]);
}

module side_rail(left=true) {
  x = left ? heatsink_x - rail_w - clearance : heatsink_x + heatsink_w + clearance;
  difference() {
    union() {
      // long low side body from base to just below aluminium top
      translate([x, heatsink_y-8, tray_t])
        rounded_box([rail_w, heatsink_d+16, heatsink_h+fan_h+air_gap], 3);

      // small inward shelf under heatsink edge; supports/locates metal but does not cover top face
      translate([left ? heatsink_x-2 : heatsink_x+heatsink_w-4, heatsink_y-2, heatsink_bottom_z-3])
        cube([6, heatsink_d+4, 5]);

      // two triangular-looking stabilising feet, kept minimal so it is not a brick
      translate([x, 8, 0]) rounded_box([rail_w, 42, tray_t+2], 3);
      translate([x, stand_d-50, 0]) rounded_box([rail_w, 42, tray_t+2], 3);
    }
    // cable/air relief windows in rails
    translate([x-1, heatsink_y+18, fan_top_z-4]) cube([rail_w+2, 34, 24]);
    translate([x-1, heatsink_y+88, fan_top_z-4]) cube([rail_w+2, 34, 24]);
  }
}

module fan_tray_half(front=true) {
  // Local coordinates for a 224 x 112 half. When assembled, front half y=0..112;
  // rear half y=112..224. Both use identical screw bosses and a semicircular airflow cutout.
  half_d = fan_tray_d/2;
  y0 = front ? 0 : half_d;
  local_center_y = front ? half_d : 0;

  difference() {
    union() {
      // outer half-frame
      rounded_box([fan_tray_w, half_d, tray_t], 4);

      // screw bosses / pads near fan mounting holes on this half
      for (spacing = fan_mount_patterns)
        for (sx=[-spacing/2, spacing/2])
          for (sy=[-spacing/2, spacing/2]) {
            yy = fan_tray_d/2 + sy - y0;
            if (yy >= 6 && yy <= half_d-6)
              translate([fan_tray_w/2 + sx, yy, tray_t]) cylinder(h=4, d=13);
          }

      // overlap tabs to join front/rear halves with M3 screws or zip ties
      if (front) {
        translate([18, half_d-8, 0]) rounded_box([44, 18, tray_t+2], 3);
        translate([fan_tray_w-62, half_d-8, 0]) rounded_box([44, 18, tray_t+2], 3);
      } else {
        translate([72, -10, 0]) rounded_box([44, 18, tray_t+2], 3);
        translate([fan_tray_w-116, -10, 0]) rounded_box([44, 18, tray_t+2], 3);
      }
    }

    // airflow opening: subtract full circular opening against each half
    translate([fan_tray_w/2, fan_tray_d/2 - y0, -1]) cylinder(h=tray_t+8, d=fan_opening);

    // fan screw holes
    for (spacing = fan_mount_patterns)
      for (sx=[-spacing/2, spacing/2])
        for (sy=[-spacing/2, spacing/2]) {
          yy = fan_tray_d/2 + sy - y0;
          if (yy >= -2 && yy <= half_d+2)
            translate([fan_tray_w/2 + sx, yy, -1]) screw_hole(tray_t+10, fan_mount_d);
        }

    // joining holes on overlap tabs
    if (front) {
      for (x=[40, fan_tray_w-40]) translate([x, half_d+1, -1]) screw_hole(tray_t+8, 3.4);
    } else {
      for (x=[94, fan_tray_w-94]) translate([x, -1, -1]) screw_hole(tray_t+8, 3.4);
    }
  }
}

module fan_tray_front() { fan_tray_half(true); }
module fan_tray_rear() { fan_tray_half(false); }

module fan_tray_assembled() {
  translate([(stand_w-fan_tray_w)/2, 0, 0]) fan_tray_front();
  translate([(stand_w-fan_tray_w)/2, fan_tray_d/2, 0]) fan_tray_rear();
}

module support_posts() {
  // Four small posts lift the heatsink off the fan, positioned near the heatsink corners.
  // They support the side/edge of the aluminium, not the Surface contact face.
  post_h = heatsink_bottom_z - tray_t;
  for (x=[heatsink_x+18, heatsink_x+heatsink_w-30])
    for (y=[heatsink_y+12, heatsink_y+heatsink_d-24])
      translate([x,y,tray_t]) rounded_box([12,12,post_h], 3);
}

module front_lip() {
  // Low, removable catch. Put a thin felt/rubber strip on the inside face if desired.
  lip_w = 216; // printable on common 220mm beds; centre catch is enough for the Surface
  lip_x = (stand_w - lip_w)/2;
  difference() {
    union() {
      translate([lip_x, heatsink_y-10, contact_z-3])
        rounded_box([lip_w, 10, 15], 3);
      translate([lip_x+28, heatsink_y-18, contact_z-3])
        rounded_box([lip_w-56, 12, 8], 3);
    }
    // centre relief for keyboard/cable edge
    translate([lip_x+70, heatsink_y-20, contact_z-5]) cube([76, 24, 22]);
  }
}

module rear_keeper() {
  // Very low rear stop to keep the heatsink located. Does not touch the tablet face.
  keeper_w = 216;
  translate([(stand_w-keeper_w)/2, heatsink_y+heatsink_d+2, heatsink_bottom_z+2])
    rounded_box([keeper_w, 9, 12], 3);
}

module printable_frame_preview() {
  color("#2f343b") side_rail(true);
  color("#2f343b") side_rail(false);
  color("#22272e") fan_tray_assembled();
  color("#2f343b") support_posts();
  color("#2f343b") front_lip();
  color("#2f343b") rear_keeper();
}

module assembly() {
  printable_frame_preview();
  heatsink_reference();
  fan_reference();
  surface_reference();
}

if (PART == "assembly") assembly();
else if (PART == "printable_frame") printable_frame_preview();
else if (PART == "left_rail") side_rail(true);
else if (PART == "right_rail") side_rail(false);
else if (PART == "fan_tray_front") fan_tray_front();
else if (PART == "fan_tray_rear") fan_tray_rear();
else if (PART == "front_lip") front_lip();
else if (PART == "rear_keeper") rear_keeper();
else if (PART == "heatsink_reference") heatsink_reference();
else if (PART == "fan_reference") fan_reference();
else surface_reference();
