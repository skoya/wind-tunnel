
// dual_pi5_macmini_v2_1_corrected_stack_koya.scad
//
// Latest v2.2:
// - 140mm front fan-sized pressure duct.
// - UGREEN TB/NVMe enclosure sits BELOW the Pi cassettes.
// - Pi cassettes sit ABOVE the UGREEN cradle.
// - Front patterned grille is clipped/contained within the cassette face: no overspill.
// - Mac mini M4 saddle is corner-guide only, with large open centre + 140mm upward fan.
// - Rear is open for exhaust and cable access.
// - UGREEN sits loose in a low side-keeper cradle; straps/towers removed.
// - v2.3 tightens physical fit: real cassette slots, lower Pi pull tabs, corrected ghosts.
// - v2.4 restores a real 140mm front fan envelope and hollow rear fan pocket.
// - v2.5 adds printable gantry supports under the elevated Pi cassette guides.
// - v2.6 mounts the top fan under the lid, clearing Pi cassettes and preserving Mac airflow.
// - v2.7 removes disconnected STL islands and rebuilds grille/connectivity.
// - v2.8 reduces material and uses a Noctua-inspired smooth radial intake grille.
// - v2.9 imports the real Noctua 120mm high-efficiency grille STL, scaled for 140mm.
// - v2.10 makes the Noctua grille a separate removable front part so airflow is visibly open.
// - v2.11 rebuilds the front cassette as an open frame with integrated Noctua grille overlay.
// - v2.12 simplifies Pi cassettes and adds fitted/full-hardware preview modes.
// - v2.13 trims plastic while preserving PETG-safe wall/post thickness.
// - v2.14 flips the Noctua grille so the fan-side profile faces inward toward the fan.
// - v2.15 slims walls/front clips and adds Noctua USB fan-cable routing clips.
// - v2.16 lowers Mac mini elevation while preserving a clear top-fan outlet plenum.
// - v2.17 vents Pi cassette trays, removes UGREEN straps/towers, adds top Noctua grille.
// - v2.18 aesthetic pass: calmer side strakes, cleaner front brow, and a floating Mac halo.
// - v2.19 accommodates Noctua NF-F12 120x25mm fans above the Mac and under the top lid.
// - v2.20 adds a rear mechanical rocker for the Mac mini M4 underside power button.
// - Airflow-optimised internals keep UGREEN front/rear/underside grilles open.
// - Open front-to-back duct keeps airflow unobstructed; Pi guide vanes removed.
// - Part envelopes are asserted against the Bambu Lab P1S build volume.
// - Export each part separately using EXPORT_PART.
//
// EXPORT_PART:
// "assembly", "base_duct", "front_fan_cassette", "lid_mac_saddle",
// "pi_cassette_left", "pi_cassette_right", "front_noctua_grille",
// "front_cassette_with_grille", "assembly_exploded", "all_print_parts"

$fn = 72;
EXPORT_PART = "assembly";
SHOW_GHOSTS = true;

// -------------------------
// Core dimensions
// -------------------------
wall = 1.8;       // ~4-5 perimeters with 0.4mm nozzle; PETG-safe but less chunky
floor_h = 4;    // support/material-light floor; rely on walls/infill for stiffness
corner_r = 12;

// Aesthetic skin details are shallow, non-structural, and easy to revert.
// They sit outside the airflow path: no internal fins, no extra fan blockage.
aesthetic_skin_t = 1.2;
aesthetic_strake_h = 2.2;
aesthetic_strake_r = 1.1;
aesthetic_brow_h = 5;
clearance = 0.6;
join_clearance = 0.45; // loose printed clearance for removable slide/drop-in joins

fan_size = 140;
fan_thick = 25;
fan_mount_spacing = 124.5; // verify your exact 140mm front fan
fan_screw_d = 5.2;

// Top-base fan is now a Noctua NF-F12, not the previous 140mm fan.
top_base_fan_size = 120;
top_base_fan_thick = 25;
top_base_fan_mount_spacing = 105;
top_base_fan_screw_d = 4.4;
top_base_fan_opening = 108;
noctua_grill_ref = "references/noctua_120mm_high_efficiency_grill.stl";
noctua_grill_scale = fan_size / 120;

// Bambu Lab P1S nominal build volume, used for part envelope asserts.
p1s_build_x = 256;
p1s_build_y = 256;
p1s_build_z = 256;

// Apple Mac mini M4 official body: 127 x 127 x 50mm
mac_w = 127;
mac_d = 127;
mac_h = 50;
mac_clearance = 2;

// Main duct hugs 140mm fan envelope
body_w = 154;     // 140 + side structure
body_d = 208;
body_h = 160;     // leaner height; still leaves clearance over Pi cassettes and under-lid top fan

front_cassette_d = 36;
front_tongue_w = 3.2;
front_tongue_h_margin = 5;
front_fan_pocket_clearance = 1.0;
front_fan_pocket_d = fan_thick + 1.2; // rear pocket accepts a 25mm-thick 140mm fan
front_grille_standoff = 3.0; // grille sits outside/front of fan cassette
rear_plenum_d = 28;
rear_y = body_d - rear_plenum_d;

// Lower UGREEN bay
ugreen_l = 122;   // placeholder; measure real enclosure without silicone
ugreen_w = 50;
ugreen_h = 24;
ugreen_y = front_cassette_d + 28;
ugreen_air_under = 14;
ugreen_z = floor_h + ugreen_air_under; // underside airflow
ugreen_top_clearance = 14;
ugreen_peg_d = 4.5;
ugreen_pad_d = 9;
ugreen_side_keeper_h = 7;

// Upper Pi bay: cassettes sit above UGREEN, not beside/inside it
pi_stack_t = 34;       // assembled Pi + HAT stack thickness across cassette width; verify real build
pi_card_d = 92;
pi_body_h = 56;        // measured installed Pi stack height
pi_card_h = pi_body_h + 2; // small visual/mechanical envelope allowance
pi_gap = 20; // widened centre gap between Pi cassettes for airflow/cable access
pi_y = front_cassette_d + 26;
pi_z = ugreen_z + ugreen_h + ugreen_top_clearance;
pi_lower_guide_h = 10;
pi_upper_keeper_h = 6;
pi_guide_t = 3;
pi_support_post_t = 4.5;
pi_support_beam_h = 3.5;
pi_support_front_y = pi_y - 8;
pi_support_rear_y = pi_y + pi_card_d + 5;
pi_frame_socket_h = 4.5;     // shallow floor sockets; no tall random base poles
pi_frame_socket_boss_d = 10;
pi_frame_socket_d = 7.4;     // leg diameter + clearance
pi_frame_leg_d = 6.6;
pi_frame_leg_clearance = 0.8;
pi_pull_tab_h = 7;       // kept low so installed cassette clears a seated lid
pi_pull_tab_overhang = 6; // rear grip lip, below lid envelope

// Front grille and filter pocket.
// Printed grille is a finger guard and filter support; use removable foam/mesh
// filter media in the rear pocket for real dust capture.
filter_panel_w = 132;
filter_panel_h = 132;
filter_media_t = 2.0;
filter_slot_clearance = 0.5;
filter_channel_w = 4;
pattern_bar_t = 2.2;
grille_spoke_t = 2.4;
grille_swirl_count = 9;
grille_swirl_t = 4.0;
grille_swirl_twist = 1.45;

// Fan cable routing: clips are kept on side walls, outside the main airflow stream.
fan_wire_d = 3.5;
mac_power_cable_d = 7.5; // approximate Mac mini mains lead diameter; holder is intentionally generous
mac_usbc_cable_d = 4.8;  // typical USB-C cable diameter
mac_rj45_cable_d = 6.5;  // ethernet cable, not the RJ45 plug body
wire_clip_gap = 6.8; // generous snap-in throat for ~3.5mm fan lead after PETG shrink/stringing
wire_clip_t = 2.2;
wire_clip_h = 11;
wire_clip_depth = 9.5;
front_fan_wire_side_x = body_w - wall - wire_clip_depth/2 + 0.6;
top_fan_wire_side_x = wall + wire_clip_depth/2 - 0.6;
fan_wire_z = 18;
top_fan_wire_z = body_h - 10;
usb_rear_y = body_d - 18;
top_fan_pi_usb_z = pi_z + 36; // approximate Pi USB cable entry height at rear of cassette
top_fan_pi_usb_x = body_w/2 - pi_gap/2 - 10; // default route to left Pi; mirror manually if needed

// Mac saddle / top fan
top_lid_thick = 5;
top_fan_y = 58;
top_fan_locator_h = 3;   // low top-side screw pads/locators only
mac_air_gap = 10;        // modest outlet plenum above lid; top fan is under the lid
mac_saddle_w = mac_w + mac_clearance*2;
mac_saddle_d = mac_d + mac_clearance*2;
mac_saddle_x = (body_w - mac_saddle_w)/2;
mac_saddle_y = top_fan_y + 7;
mac_deck_lift = 0; // Mac guides sit flush on the lid/roof; fan remains mounted underneath
mac_rail_h = 6;
mac_rail_t = 5;
mac_riser_t = 5;
top_grille_standoff = 0; // top grille removed: Mac is supported by rails, leaving fan outlet open

// Clip-on upper cooler for Mac mini + heatsink + one Noctua NF-F12 fan.
// This is a separate printable bridge so the Mac can still slide out of the saddle.
heatsink_w = 100;
heatsink_d = 100;
heatsink_h = 18;
heatsink_clearance = 3;
upper_fan_size = 120;          // Noctua NF-F12: 120 x 120 x 25mm
upper_fan_thick = 25;
upper_fan_mount_spacing = 105; // Noctua NF-F12 mounting pattern
upper_fan_screw_d = 4.4;
upper_fan_air_opening = 108;   // leaves material under the fan frame
upper_fan_count = 1;
upper_fan_gap = 0;
upper_fan_margin = 5;
upper_bridge_w = upper_fan_size + upper_fan_margin*2;
upper_bridge_d = upper_fan_size + upper_fan_margin*2;
upper_cooler_leg_t = 5.0;
upper_cooler_frame_t = 5;
upper_bridge_corner_r = 8;
upper_bridge_arch_h = 8; // retained for compatibility; no tall side arches now
upper_cooler_gap = 1.5; // tiny anti-rattle clearance: fan frame effectively rests on heatsink
upper_fan_lip_h = 4; // low retaining lip over fan-frame corners
upper_cooler_h = mac_h + heatsink_h + upper_cooler_gap + upper_fan_thick + upper_fan_lip_h;

// Mac mini M4 underside power rocker. Button position is approximate by design:
// the contact pad and lid window are intentionally generous so this can be
// tuned after checking Bobby's actual Mac against the preview/print.
mac_floor_z = top_lid_thick + mac_rail_h + 2;
// Apple/MacRumors place the M4 Mac mini power button on the underside,
// rear-left when viewed from the front, below the three rear Thunderbolt ports.
// In this CAD coordinate system front is low Y, rear is high Y, and left is
// low X when viewed from the front.
mac_power_button_x_left = (body_w - mac_w)/2 + 23;
mac_power_button_x_right = (body_w + mac_w)/2 - 23;
mac_power_button_x = mac_power_button_x_left; // default/reference side
mac_power_button_y = mac_saddle_y + mac_clearance + mac_d - 14;
// Keep the rocker windows small and rear-biased so they do not visually merge
// with the large central top-fan/Mac-airflow opening. Both rear corners get a
// window/mount so the rocker can be installed on the side that matches the real Mac.
mac_power_window_w = 24;
mac_power_window_d = 24;
rocker_pivot_x = mac_power_button_x;
rocker_pivot_y = mac_saddle_y + mac_clearance + mac_d + 5;
rocker_pivot_z = mac_floor_z - 6.5;
rocker_w = 13;
rocker_t = 5;
rocker_pin_d = 3.2;
rocker_barrel_d = 8;
rocker_contact_w = 18;
rocker_contact_d = 13;
rocker_contact_h = 4.2;
rocker_tab_d = 22;
rocker_tab_w = 24;
rocker_tab_h = 5;

// Individual printable envelopes must fit the P1S build volume.
assert(body_w <= p1s_build_x && body_d <= p1s_build_y && body_h <= p1s_build_z,
       "base_duct envelope exceeds Bambu Lab P1S build volume");
assert(body_w <= p1s_build_x && body_d <= p1s_build_y && (top_lid_thick + mac_deck_lift + mac_rail_h) <= p1s_build_z,
       "lid_mac_saddle envelope exceeds Bambu Lab P1S build volume");
assert(upper_bridge_w <= p1s_build_x && upper_bridge_d <= p1s_build_y && upper_cooler_h <= p1s_build_z,
       "upper_mac_fan_bridge envelope exceeds Bambu Lab P1S build volume");
assert((body_w-10) <= p1s_build_x && front_cassette_d <= p1s_build_y && body_h <= p1s_build_z,
       "front_fan_cassette envelope exceeds Bambu Lab P1S build volume");
assert(pi_stack_t <= p1s_build_x && (pi_card_d + pi_pull_tab_overhang) <= p1s_build_y && (pi_card_h + pi_pull_tab_h) <= p1s_build_z,
       "pi_cassette envelope exceeds Bambu Lab P1S build volume");

// -------------------------
// Helpers
// -------------------------
module rounded_box(size=[10,10,10], r=3, center=false) {
    sx=size[0]; sy=size[1]; sz=size[2];
    translate(center ? [-sx/2,-sy/2,-sz/2] : [0,0,0])
    hull() {
        translate([r,r,0]) cylinder(h=sz, r=r);
        translate([sx-r,r,0]) cylinder(h=sz, r=r);
        translate([r,sy-r,0]) cylinder(h=sz, r=r);
        translate([sx-r,sy-r,0]) cylinder(h=sz, r=r);
    }
}

module clipped_filter_grille_pattern() {
    // Decorative printed support pattern. Dust stopping comes from filter media
    // held in the cassette pocket, not from printed plastic alone.
    intersection() {
        translate([0,0,0]) union() {
            difference() {
                cylinder(h=4, d=132, center=true);
                cylinder(h=4.4, d=118, center=true);
            }

            // Circular swirl pattern: supports filter media and reads as a fan grille.
            cylinder(h=4, d=20, center=true);
            for (a=[0:360/grille_swirl_count:359]) {
                swirl_grille_arm(a);
            }
            for (d=[48,78,106]) {
                difference() {
                    cylinder(h=4, d=d, center=true);
                    cylinder(h=4.4, d=d-5, center=true);
                }
            }
        }
        // hard clip to front window
        cube([body_w-24, body_h-24, 8], center=true);
    }
}

module swirl_grille_arm(a) {
    for (r=[14:8:58]) {
        theta0 = a + r*grille_swirl_twist;
        theta1 = a + (r+10)*grille_swirl_twist;
        hull() {
            translate([r*cos(theta0), r*sin(theta0), 0])
                cylinder(h=4, d=grille_swirl_t, center=true);
            translate([(r+10)*cos(theta1), (r+10)*sin(theta1), 0])
                cylinder(h=4, d=grille_swirl_t, center=true);
        }
    }
}

module filter_media_pocket() {
    cx = (body_w-10)/2;
    zc = (body_h-12)/2;
    slot_d = filter_media_t + filter_slot_clearance;
    y = front_cassette_d - slot_d - 2;

    // Rear-loading filter-media pocket. Leave the top open so a thin foam or
    // mesh square can slide in after printing.
    translate([cx-filter_panel_w/2-filter_channel_w, y, zc-filter_panel_h/2])
        cube([filter_channel_w, slot_d, filter_panel_h]);
    translate([cx+filter_panel_w/2, y, zc-filter_panel_h/2])
        cube([filter_channel_w, slot_d, filter_panel_h]);
    translate([cx-filter_panel_w/2-filter_channel_w, y, zc-filter_panel_h/2-filter_channel_w])
        cube([filter_panel_w+filter_channel_w*2, slot_d, filter_channel_w]);
}

// -------------------------
// Base duct
// -------------------------
module base_duct() {
    difference() {
        union() {
            rounded_box([body_w, body_d, floor_h], corner_r);

            // solid pressure duct sides
            translate([0,0,0]) rounded_box([wall, body_d, body_h], 3);
            translate([body_w-wall,0,0]) rounded_box([wall, body_d, body_h], 3);

            // Exterior styling strakes/brow removed in the support-light pass:
            // less filament, fewer slicer surprises, same pressure path.

            // Rear keeper removed: the back stays fully open to avoid support,
            // wasted filament, and confusing horizontal bars.

            front_cassette_receivers();

            // UGREEN lower cradle
            ugreen_cradle();

            // The Pi cassette gantry is separate. The base only gets four simple
            // receiver sockets; the removable Pi cage has straight legs that drop in.
            base_pi_frame_mount_bosses();
        }

        // front fan opening
        translate([14, -1, 18]) cube([body_w-28, front_cassette_d+4, body_h-32]);

        // rear exhaust/cable opening
        translate([8, body_d-wall-1, 10]) cube([body_w-16, wall+4, body_h-18]);
        translate([10, body_d-wall-1, 0]) cube([body_w-20, wall+4, 52]);

        // Straight receiver holes for the removable Pi cage legs.
        base_pi_frame_socket_cuts();

        // Floor zip-tie slots replace printed cable lips/hooks in the base.
        cable_tie_floor_slots();
    }
}

module aesthetic_side_strakes() {
    // Three long, quiet horizontal shadow lines on each side. They make the tall
    // duct read more like a deliberate appliance and less like a project box.
    strake_y = 18;
    strake_len = body_d - 48;
    for (side=[-1,1]) {
        x = side < 0 ? -aesthetic_skin_t + 0.25 : body_w - 0.25;
        for (z=[44, 82, 120]) {
            translate([x, strake_y, z])
                rounded_box([aesthetic_skin_t, strake_len, aesthetic_strake_h], aesthetic_strake_r);
        }

        // Short vertical nose accent ties the front cassette into the main body.
        translate([x, 4, 26])
            rounded_box([aesthetic_skin_t, 34, body_h-54], 2.2);
    }
}

module aesthetic_front_brow() {
    // A slim upper brow visually frames the intake without adding bars across it.
    // It overlaps both side walls slightly so it exports as one printable shell.
    translate([0, 1.5, body_h-18])
        rounded_box([body_w, aesthetic_skin_t, aesthetic_brow_h], 2.5);
}

module top_lid_style_reveal() {
    // Raised perimeter/reveal lines on the top lid. The centre remains open for
    // the upward 140mm fan and Mac underside airflow.
    z = top_lid_thick - 0.25;
    inset = 9;
    rail = 2.4;
    translate([inset, inset, z]) rounded_box([body_w-2*inset, rail, 1.6], 1.2);
    translate([inset, body_d-inset-rail, z]) rounded_box([body_w-2*inset, rail, 1.6], 1.2);
    translate([inset, inset, z]) rounded_box([rail, body_d-2*inset, 1.6], 1.2);
    translate([body_w-inset-rail, inset, z]) rounded_box([rail, body_d-2*inset, 1.6], 1.2);
}

module front_cassette_receivers() {
    // Join detail: the side walls form the outer faces; these inner rails create
    // actual clearance channels for the cassette tongues instead of solid butt blocks.
    slot_inner_x = wall + front_tongue_w + join_clearance;
    rail_w = 2.2;
    translate([slot_inner_x, 0, floor_h]) cube([rail_w, front_cassette_d+8, body_h-floor_h-10]);
    translate([body_w-slot_inner_x-rail_w, 0, floor_h]) cube([rail_w, front_cassette_d+8, body_h-floor_h-10]);
}

module pi_frame_mount_centres() {
    // Four simple socket/leg points around the UGREEN footprint. No snap heads,
    // no C-feet: the removable Pi cage drops straight into these holders.
    left_outer_x = body_w/2 - pi_gap/2 - pi_stack_t - 4;
    right_outer_x = body_w/2 + pi_gap/2 + pi_stack_t + 1;
    for (x=[left_outer_x + pi_support_post_t/2, right_outer_x + pi_support_post_t/2],
         y=[pi_support_front_y + pi_support_post_t/2, pi_support_rear_y + pi_support_post_t/2]) {
        translate([x, y, 0]) children();
    }
}

module base_pi_frame_mount_bosses() {
    pi_frame_mount_centres() {
        // Low receiver boss for a straight plug-in Pi cage leg.
        translate([0,0,floor_h]) cylinder(h=pi_frame_socket_h, d=pi_frame_socket_boss_d);
    }
}

module base_pi_frame_socket_cuts() {
    pi_frame_mount_centres() {
        translate([0,0,floor_h+1.0])
            cylinder(h=pi_frame_socket_h+2, d=pi_frame_socket_d);
    }
}

module cable_tie_floor_slots() {
    // Support-free cable management: use zip ties/Velcro through floor slots
    // instead of printed wall hooks with lips/cantilevers.
    slot_w = 2.4;
    slot_l = 10;
    for (y=[front_cassette_d+18, 88, 142, usb_rear_y]) {
        translate([10, y-slot_l/2, -1]) cube([slot_w, slot_l, floor_h+2]);
        translate([body_w-10-slot_w, y-slot_l/2, -1]) cube([slot_w, slot_l, floor_h+2]);
    }
}

module side_cable_hook(y, z, side=1) {
    // Open J-hook for fan leads. The wire is threaded/laid under the lip;
    // no mystery snap-slot. side=1 means left wall, side=-1 means right wall.
    hook_len = 12;
    hook_depth = 10;
    hook_t = 2.4;
    hook_lip_h = 5;
    x0 = side == 1 ? 0 : body_w-hook_t;
    inward = side == 1 ? 1 : -1;

    // Wall pad, shelf, and upturned lip. All overlap the wall so this is one mesh.
    translate([x0, y-hook_len/2, z-hook_lip_h/2]) cube([hook_t, hook_len, hook_lip_h+4]);
    translate([side == 1 ? 0 : body_w-hook_depth, y-hook_len/2, z-hook_t/2]) cube([hook_depth, hook_len, hook_t]);
    translate([side == 1 ? hook_depth-hook_t : body_w-hook_depth, y-hook_len/2, z-hook_t/2]) cube([hook_t, hook_len, hook_lip_h]);
}

module rear_vertical_cable_hook(z) {
    // Rear-left open hook for the top-fan lead as it drops down toward a Pi.
    hook_w = 10;
    hook_t = 2.4;
    hook_h = 12;
    translate([0, usb_rear_y-hook_t/2, z-hook_h/2]) cube([hook_w, hook_t, hook_h]);
    translate([hook_w-hook_t, usb_rear_y-hook_t/2, z-hook_h/2]) cube([hook_t, hook_t+8, hook_t]);
}

module fan_cable_clips() {
    // Front fan USB lead: open hooks along the right wall toward the Pi USB area.
    for (y=[front_cassette_d+10, front_cassette_d+38, 88, 132, 176, usb_rear_y]) {
        side_cable_hook(y, fan_wire_z, -1);
    }

    // Top fan USB lead: open hooks along the left wall from the under-lid fan to the rear.
    for (y=[top_fan_y+top_base_fan_size-10, 168, 142, usb_rear_y]) {
        side_cable_hook(y, top_fan_wire_z, 1);
    }

    // Rear-left descending hooks toward the left Pi USB height.
    for (z=[top_fan_wire_z-18, top_fan_wire_z-42, top_fan_pi_usb_z+16, top_fan_pi_usb_z]) {
        rear_vertical_cable_hook(z);
    }
}


module ugreen_cradle() {
    ux = (body_w - ugreen_w) / 2;
    uy = ugreen_y;

    difference() {
        union() {
            // Thin peg legs and small pads support UGREEN while leaving underside airflow open.
            for (x=[ux+7, ux+ugreen_w-7], yy=[uy+16, uy+ugreen_l/2, uy+ugreen_l-16]) {
                translate([x, yy, floor_h]) cylinder(h=ugreen_air_under, d=ugreen_peg_d);
                translate([x, yy, ugreen_z-1.2]) cylinder(h=1.2, d=ugreen_pad_d);
            }

            // Side-only keeper posts; extend from the base so they are printable, not floating nubs.
            for (x=[ux-6, ux+ugreen_w+6], yy=[uy+18, uy+ugreen_l-18]) {
                translate([x, yy, floor_h]) cylinder(h=ugreen_z-floor_h+ugreen_side_keeper_h, d=ugreen_peg_d);
            }

            // Extra tunnel edge rails removed: they did not hold the UGREEN up and
            // just added plastic/visual clutter.
        }

    }
}


module pi_receiver_supports() {
    // The Pi receiver rails sit above the UGREEN bay, so they need their own
    // removable bridge. It now uses four straight round legs that drop into
    // plain sockets in the base: simpler, less plastic, easier to understand.
    left_outer_x = body_w/2 - pi_gap/2 - pi_stack_t - 4;
    right_outer_x = body_w/2 + pi_gap/2 + pi_stack_t + 1;
    leg_xL = left_outer_x + pi_support_post_t/2;
    leg_xR = right_outer_x + pi_support_post_t/2;
    beam_xL = leg_xL - pi_support_post_t/2;
    beam_xR = leg_xR - pi_support_post_t/2;
    beam_w = beam_xR - beam_xL + pi_support_post_t;
    beam_z = pi_z - pi_support_beam_h;

    // Four straight plug-in legs. The lower section enters the base socket;
    // the upper section carries the Pi cage beams.
    for (x=[leg_xL, leg_xR],
         y=[pi_support_front_y + pi_support_post_t/2, pi_support_rear_y + pi_support_post_t/2]) {
        translate([x, y, floor_h+1.0])
            cylinder(h=beam_z - (floor_h+1.0), d=pi_frame_leg_d);
    }

    // Front and rear beams are above the UGREEN top and below the cassette rails.
    translate([beam_xL, pi_support_front_y, beam_z])
        rounded_box([beam_w, pi_support_post_t, pi_support_beam_h], 2);
    translate([beam_xL, pi_support_rear_y, beam_z])
        rounded_box([beam_w, pi_support_post_t, pi_support_beam_h], 2);

    // Short longitudinal outer rails stiffen the bridge without crossing the
    // UGREEN centre airflow path.
    translate([beam_xL, pi_support_front_y, beam_z])
        rounded_box([pi_support_post_t, pi_support_rear_y-pi_support_front_y+pi_support_post_t, pi_support_beam_h], 2);
    translate([beam_xR, pi_support_front_y, beam_z])
        rounded_box([pi_support_post_t, pi_support_rear_y-pi_support_front_y+pi_support_post_t, pi_support_beam_h], 2);
}

module pi_receiver(x, y) {
    // Integrated Pi holder: the cassette rails/ribs are part of the removable
    // Pi frame now. No separate cassette, no rear back bar.
    rail_z = pi_z - pi_support_beam_h;
    rail_y0 = pi_support_front_y;
    rail_len = pi_support_rear_y - pi_support_front_y + pi_support_post_t;
    rib_w = 2.4;
    rib_h = 4;

    // Side guide rails for the Pi stack.
    translate([x-2, rail_y0, rail_z]) cube([pi_guide_t, rail_len, pi_support_beam_h+pi_lower_guide_h]);
    translate([x+pi_stack_t-1, rail_y0, rail_z]) cube([pi_guide_t, rail_len, pi_support_beam_h+pi_lower_guide_h]);

    // Light underside ribs tie into both side rails; deliberately overlap the
    // rails so the exported Pi frame is one connected mesh, not loose strips.
    for (yy=[y+18, y+46, y+74]) {
        translate([x-2, yy-rib_w/2, rail_z]) cube([pi_stack_t+4, rib_w, rib_h]);
    }
}

module pi_frame_bridge_installed() {
    // Separate clip-in Pi frame. This keeps the base support-light: print the
    // base as a duct shell, then press the frame onto the four PLA snap pegs.
    union() {
        pi_receiver_supports();
        pi_receiver(body_w/2 - pi_gap/2 - pi_stack_t, pi_y);
        pi_receiver(body_w/2 + pi_gap/2, pi_y);
    }
}

module pi_frame_bridge() {
    // Exported upside-down for printing: the high cross-beams sit on the bed
    // and the four straight legs grow upward, avoiding support.
    // In assembly views use pi_frame_bridge_installed().
    translate([0, body_d, pi_z + pi_lower_guide_h])
        rotate([180,0,0]) pi_frame_bridge_installed();
}

// -------------------------
// Front fan cassette
// -------------------------
module front_noctua_grille() {
    // Noctua grille, scaled from Bobby's 120mm STL to 140mm.
    // Flipped through Y so the fan-side/aero-profile faces inward toward the fan pocket.
    // Final local bounds remain approximately X 0..140, Y -2..0, Z 0..140.
    translate([0, -2, 0])
        mirror([0,1,0])
            scale([noctua_grill_scale, 1, noctua_grill_scale])
                translate([120, 0, 128])
                    import(noctua_grill_ref, convexity=10);
}

module front_fan_cassette_body() {
    cassette_w = body_w - 10;
    cassette_h = body_h - 2*front_tongue_h_margin;
    fan_pocket_x = (cassette_w - fan_size - front_fan_pocket_clearance) / 2;
    fan_pocket_z = (cassette_h - fan_size - front_fan_pocket_clearance) / 2;

    difference() {
        union() {
            // Outer cassette slab becomes a frame after the central cuts below.
            rounded_box([cassette_w, front_cassette_d, cassette_h], 7);

            // Join detail: tongues sit in the base side-wall channels with print clearance.
            translate([-3,0,front_tongue_h_margin]) cube([front_tongue_w+2, front_cassette_d, body_h-24]);
            translate([body_w-11,0,front_tongue_h_margin]) cube([front_tongue_w+2, front_cassette_d, body_h-24]);

            // Small screw pad bosses around the fan holes; these remain after the huge intake cut.
            for (sx=[-1,1], sz=[-1,1]) {
                translate([cassette_w/2 + sx*fan_mount_spacing/2 - 7, 0, cassette_h/2 + sz*fan_mount_spacing/2 - 7])
                    rounded_box([14, front_cassette_d, 14], 3);
            }
        }

        // Full rear-loading 140mm fan pocket. This hollows the cassette behind the front frame.
        translate([fan_pocket_x, front_cassette_d-front_fan_pocket_d, fan_pocket_z])
            rounded_box([fan_size + front_fan_pocket_clearance, front_fan_pocket_d + 2, fan_size + front_fan_pocket_clearance], 5);

        // Obvious through-intake. If this still looks solid in the slicer, you're loading a stale STL.
        translate([cassette_w/2, -4, cassette_h/2])
            rotate([90,0,0]) cylinder(h=front_cassette_d+8, d=136);

        // Square relief behind the round intake avoids a hidden rear skin and makes airflow undeniable.
        translate([cassette_w/2-62, -4, cassette_h/2-62])
            cube([124, front_cassette_d+8, 124]);

        // Fan mount holes pass through the remaining screw pads.
        for (sx=[-1,1], sz=[-1,1]) {
            translate([cassette_w/2 + sx*fan_mount_spacing/2, front_cassette_d/2, cassette_h/2 + sz*fan_mount_spacing/2])
                rotate([90,0,0]) cylinder(h=front_cassette_d+6, d=fan_screw_d, center=true);
        }

        // Noctua grille retainer holes around front face.
        for (sx=[-1,1], sz=[-1,1]) {
            translate([cassette_w/2 + sx*58, -3, cassette_h/2 + sz*58])
                rotate([90,0,0]) cylinder(h=10, d=3.2, center=true);
        }
    }
}

module front_fan_cassette() {
    front_cassette_with_grille();
}

module front_cassette_with_grille() {
    front_fan_cassette_body();
    // Integrated printable grille: it is part of the cassette STL, but sits proud of the open intake.
    translate([(body_w-10)/2 - fan_size/2, -front_grille_standoff, (body_h-2*front_tongue_h_margin)/2 - fan_size/2])
        front_noctua_grille();

    // Tiny bridges tie the grille into the cassette frame so it prints as one part.
    cassette_w = body_w - 10;
    cassette_h = body_h - 2*front_tongue_h_margin;
    for (a=[0:45:359]) {
        translate([cassette_w/2 + 68*cos(a), -front_grille_standoff/2, cassette_h/2 + 68*sin(a)])
            rotate([90,0,0]) cylinder(h=front_grille_standoff+1.2, d=3.5, center=true);
    }
}

module flat_ring(d_outer, d_inner, h=2.0) {
    difference() {
        cylinder(h=h, d=d_outer);
        translate([0,0,-1]) cylinder(h=h+2, d=d_inner);
    }
}

// Mac mini wire guides removed: cable routing is now external/simple.

// -------------------------
// Lid + Mac mini saddle
// -------------------------
module lid_mac_saddle() {
    union() {
        difference() {
            union() {
                rounded_box([body_w, body_d, top_lid_thick], corner_r);

                // Underside locating tongues removed: they forced the slicer to
                // support almost the whole lid. The lid now prints flat on its
                // underside; location comes from the side walls and Mac/fan hardware.

                // Top 140mm fan mount: fan screws underneath the lid; top pads are low locators only.
                translate([(body_w-top_base_fan_size)/2, top_fan_y, top_lid_thick])
                    top_fan_frame();

                // Mac guides touch only corners/edges and sit flush on the lid/roof.
                mac_guides();

                // subtle top reveal makes the Mac look intentionally floated
                top_lid_style_reveal();

                // Rear horizontal cable guard/deck removed for the support-light pass.
                // Mac cables can be handled with adhesive clips/Velcro after print;
                // printed roof bars here cost support and blocked visual access.

                // Rear hinge cheeks for the separate mechanical Mac power rocker.
                mac_power_rocker_mounts();
            }

            // upward fan opening: avoids blocking Mac intake
            translate([body_w/2, top_fan_y+top_base_fan_size/2, -1])
                cylinder(h=34, d=top_base_fan_opening);

            // top fan mount holes
            for (sx=[-1,1], sy=[-1,1]) {
                translate([body_w/2 + sx*top_base_fan_mount_spacing/2, top_fan_y+top_base_fan_size/2 + sy*top_base_fan_mount_spacing/2, -1])
                    cylinder(h=36, d=top_base_fan_screw_d);
            }

            // M4 Mac mini underside power-button access windows for the rocker contact.
            // Mirrored rear windows avoid another left/right orientation trap.
            for (button_x=[mac_power_button_x_left, mac_power_button_x_right]) {
                translate([button_x-mac_power_window_w/2,
                           mac_power_button_y-mac_power_window_d/2,
                           -1])
                    rounded_box([mac_power_window_w, mac_power_window_d, 40], 8);
            }

            // M3/filament hinge-pin holes through the rocker mount cheeks, mirrored.
            for (button_x=[mac_power_button_x_left, mac_power_button_x_right], sx=[-1,1]) {
                translate([button_x + sx*(rocker_w/2 + 3.2), rocker_pivot_y, rocker_pivot_z])
                    rotate([0,90,0]) cylinder(h=8, d=rocker_pin_d, center=true);
            }
        }

        // No printed grille above the top fan: the Mac is supported by rails,
        // and the open centre gives the cleanest upward airflow.
    }
}

module top_fan_frame() {
    // Open top-side locator, not a solid block. The real 140x25mm fan mounts underneath the lid.
    pad = 22;
    lip_t = 3;
    lip_len = 34;

    for (sx=[-1,1], sy=[-1,1]) {
        translate([top_base_fan_size/2 + sx*top_base_fan_mount_spacing/2 - pad/2,
                   top_base_fan_size/2 + sy*top_base_fan_mount_spacing/2 - pad/2,
                   0])
            rounded_box([pad, pad, top_fan_locator_h], 4);
    }

    // Shallow perimeter locator lips; they locate the fan body without blocking intake.
    translate([top_base_fan_size/2-lip_len/2, 0, 0]) cube([lip_len, lip_t, top_fan_locator_h]);
    translate([top_base_fan_size/2-lip_len/2, top_base_fan_size-lip_t, 0]) cube([lip_len, lip_t, top_fan_locator_h]);
    translate([0, top_base_fan_size/2-lip_len/2, 0]) cube([lip_t, lip_len, top_fan_locator_h]);
    translate([top_base_fan_size-lip_t, top_base_fan_size/2-lip_len/2, 0]) cube([lip_t, lip_len, top_fan_locator_h]);
}

module mac_guides() {
    x = mac_saddle_x;
    y = mac_saddle_y;
    z = top_lid_thick + mac_deck_lift;
    puck = 30;
    puck_h = 1.8;

    // Low rounded corner pucks visually echo the Mac mini radius while keeping
    // the centre open for airflow. The taller lips sit only at the corners.
    for (sx=[0,1], sy=[0,1]) {
        translate([x + sx*(mac_saddle_w-puck), y + sy*(mac_saddle_d-puck), z-puck_h])
            rounded_box([puck, puck, puck_h], 7);
    }

    // corner guides only; do not form a tray that blocks underside airflow
    translate([x, y, z]) rounded_box([26, mac_rail_t, mac_rail_h], 3.5);
    translate([x+mac_saddle_w-26, y, z]) rounded_box([26, mac_rail_t, mac_rail_h], 3.5);
    translate([x, y+mac_saddle_d-mac_rail_t, z]) rounded_box([26, mac_rail_t, mac_rail_h], 3.5);
    translate([x+mac_saddle_w-26, y+mac_saddle_d-mac_rail_t, z]) rounded_box([26, mac_rail_t, mac_rail_h], 3.5);

    translate([x, y, z]) rounded_box([mac_rail_t, 26, mac_rail_h], 3.5);
    translate([x+mac_saddle_w-mac_rail_t, y, z]) rounded_box([mac_rail_t, 26, mac_rail_h], 3.5);
    translate([x, y+mac_saddle_d-26, z]) rounded_box([mac_rail_t, 26, mac_rail_h], 3.5);
    translate([x+mac_saddle_w-mac_rail_t, y+mac_saddle_d-26, z]) rounded_box([mac_rail_t, 26, mac_rail_h], 3.5);
}

module mac_saddle_risers() {
    x = mac_saddle_x;
    y = mac_saddle_y;
    z = top_lid_thick;

    // Four small corner stanchions carry the Mac guide rails above the lid outlet.
    // The top fan sits below the lid, so these posts no longer conflict with the fan body.
    translate([x, y, z]) rounded_box([mac_riser_t, mac_riser_t, mac_deck_lift], 3);
    translate([x+mac_saddle_w-mac_riser_t, y, z]) rounded_box([mac_riser_t, mac_riser_t, mac_deck_lift], 3);
    translate([x, y+mac_saddle_d-mac_riser_t, z]) rounded_box([mac_riser_t, mac_riser_t, mac_deck_lift], 3);
    translate([x+mac_saddle_w-mac_riser_t, y+mac_saddle_d-mac_riser_t, z]) rounded_box([mac_riser_t, mac_riser_t, mac_deck_lift], 3);
}

module mac_power_rocker_mounts() {
    // Rear hinge cheeks hold a separate printed rocker with an M3 screw or
    // short filament pin. Mirrored left/right so the rocker can be installed
    // on whichever rear corner matches the actual Mac orientation.
    cheek_t = 4;
    cheek_d = 15;
    cheek_h = rocker_pivot_z - top_lid_thick + rocker_barrel_d/2 + 2;
    for (button_x=[mac_power_button_x_left, mac_power_button_x_right], sx=[-1,1]) {
        translate([button_x + sx*(rocker_w/2 + cheek_t/2 + 1.2),
                   rocker_pivot_y-cheek_d/2,
                   top_lid_thick])
            rounded_box([cheek_t, cheek_d, cheek_h], 1.8);
    }
}

module mac_power_rocker_local() {
    // Origin is the hinge-pin centre. Front arm reaches under the Mac; rear tab
    // protrudes just past the back of the stand. Press rear tab down -> front
    // contact nub lifts into the Mac's underside power button.
    front_y = mac_power_button_y - rocker_pivot_y - rocker_contact_d/2;
    rear_y = body_d + 13 - rocker_pivot_y;
    lever_len = rear_y - front_y;

    difference() {
        union() {
            translate([-rocker_w/2, front_y, -rocker_t/2])
                rounded_box([rocker_w, lever_len, rocker_t], 2);

            // Hinge barrel for an M3/filament pin, with extra meat above/below
            // the bore so the cut does not split the lever into islands.
            rotate([0,90,0]) cylinder(h=rocker_w+1.6, d=rocker_barrel_d, center=true);
            translate([-rocker_w/2, -3.2, -rocker_t/2])
                rounded_box([rocker_w, 6.4, rocker_t], 1.5);

            // Broad contact nub: forgiving of the still-unverified button position.
            translate([-rocker_contact_w/2, mac_power_button_y-rocker_pivot_y-rocker_contact_d/2, rocker_t/2-0.1])
                rounded_box([rocker_contact_w, rocker_contact_d, rocker_contact_h], 2);

            // External thumb pad behind the Mac/stand.
            translate([-rocker_tab_w/2, body_d+1-rocker_pivot_y, -rocker_t/2])
                rounded_box([rocker_tab_w, rocker_tab_d, rocker_tab_h], 3);
        }
        rotate([0,90,0]) cylinder(h=rocker_w+4, d=rocker_pin_d, center=true);
    }
}

module mac_power_rocker_installed() {
    translate([rocker_pivot_x, rocker_pivot_y, rocker_pivot_z])
        mac_power_rocker_local();
}

module mac_power_rocker() {
    // Print as a separate part, lying on its side so the hinge bore is cleaner.
    rotate([0,-90,0]) mac_power_rocker_local();
}

// -------------------------
// Pi cassettes
// -------------------------
module pi_cassette(label="L") {
    // Open-frame cassette: side rails and a few ribs locate the Pi stack while
    // leaving most of the underside open to airflow and using much less plastic.
    rail_w = 3.2;
    rib_w = 2.4;
    rear_stop_d = 4;

    union() {
        // Side guide rails.
        translate([0,0,0]) cube([rail_w, pi_card_d, pi_lower_guide_h]);
        translate([pi_stack_t-rail_w,0,0]) cube([rail_w, pi_card_d, pi_lower_guide_h]);

        // Thin front/rear cross members keep the cassette square without becoming a tray.
        translate([0,0,0]) cube([pi_stack_t, rib_w, 4]);
        translate([0,pi_card_d-rear_stop_d,0]) cube([pi_stack_t, rear_stop_d, 12]);

        // Three narrow underside ribs instead of a solid floor.
        for (y=[22, 46, 70]) {
            translate([rail_w, y-rib_w/2, 0]) cube([pi_stack_t-2*rail_w, rib_w, 4]);
        }

        // Low rear pull lip/stop, connected to the rear cross member.
        translate([4, pi_card_d-pi_pull_tab_overhang, 11.8])
            cube([pi_stack_t-8, pi_pull_tab_overhang+5, pi_pull_tab_h+0.2]);
    }
}


// -------------------------
// Upper Mac heatsink/fan bridge
// -------------------------
module upper_fan_origins() {
    // Compatibility helper: one NF-F12 frame origin.
    translate([upper_fan_margin, upper_fan_margin, 0]) children();
}

module upper_mac_fan_bridge() {
    // Low retaining clip for one NF-F12 fan sitting directly on/over the heatsink.
    // No tall Mac-surrounding legs: the Mac is already carried by the saddle.
    bridge_w = upper_bridge_w;
    bridge_d = upper_bridge_d;
    fan_x = upper_fan_margin;
    fan_y = upper_fan_margin;
    base_h = 4;
    clip_h = upper_fan_lip_h + base_h;
    lip_overlap = 5;

    difference() {
        union() {
            difference() {
                rounded_box([bridge_w, bridge_d, base_h], upper_bridge_corner_r);
                translate([fan_x + (upper_fan_size-upper_fan_air_opening)/2,
                           fan_y + (upper_fan_size-upper_fan_air_opening)/2,
                           -1])
                    rounded_box([upper_fan_air_opening, upper_fan_air_opening, base_h+2], 3);
            }

            // Small over-lips at the fan-frame corners to stop lift/rattle.
            for (sx=[0,1], sy=[0,1]) {
                translate([fan_x + sx*(upper_fan_size-lip_overlap),
                           fan_y + sy*(upper_fan_size-lip_overlap),
                           base_h])
                    rounded_box([lip_overlap, lip_overlap, upper_fan_lip_h], 1.2);
            }
        }

        // Screw/zip-tie clearance through the ring at the NF-F12 mounting pattern.
        for (sx=[-1,1], sy=[-1,1]) {
            translate([fan_x + upper_fan_size/2 + sx*upper_fan_mount_spacing/2,
                       fan_y + upper_fan_size/2 + sy*upper_fan_mount_spacing/2,
                       -1])
                cylinder(h=clip_h+2, d=upper_fan_screw_d);
        }
    }
}

// -------------------------
// Assembly ghost envelopes
// -------------------------
module ghosts() {
    if (SHOW_GHOSTS) {
        // front fan mounted inside cassette behind grille
        translate([(body_w-fan_size)/2, front_cassette_d - fan_thick + 5, (body_h-fan_size)/2])
            rotate([90,0,0]) noctua_140_fan_ghost();
        fan_wire_ghost([
            [body_w-28, 10, body_h/2],
            [front_fan_wire_side_x, front_cassette_d+18, fan_wire_z],
            [front_fan_wire_side_x, 104, fan_wire_z],
            [front_fan_wire_side_x, 166, fan_wire_z],
            [front_fan_wire_side_x, usb_rear_y, fan_wire_z],
            [body_w/2 + pi_gap/2 + 10, usb_rear_y, pi_z+24]
        ]);

        // UGREEN below
        color([0.65,0.65,0.65,0.35])
        translate([(body_w-ugreen_w)/2, ugreen_y, ugreen_z])
            cube([ugreen_w, ugreen_l, ugreen_h]);

        // Pis above UGREEN
        color([0.1,0.6,0.2,0.28])
        translate([body_w/2 - pi_gap/2 - pi_stack_t, pi_y+4, pi_z+4])
            cube([pi_stack_t, 85, pi_body_h]);
        color([0.1,0.6,0.2,0.28])
        translate([body_w/2 + pi_gap/2, pi_y+4, pi_z+4])
            cube([pi_stack_t, 85, pi_body_h]);

        // top-base NF-F12 fan
        translate([(body_w-top_base_fan_size)/2, top_fan_y, body_h-top_base_fan_thick])
            nf_f12_fan_ghost();
        fan_wire_ghost([
            [body_w/2, top_fan_y+top_base_fan_size-12, body_h-top_base_fan_thick/2],
            [top_fan_wire_side_x, top_fan_y+top_base_fan_size-18, top_fan_wire_z],
            [top_fan_wire_side_x, 156, top_fan_wire_z],
            [top_fan_wire_side_x, usb_rear_y, top_fan_wire_z],
            [top_fan_wire_side_x, usb_rear_y, top_fan_pi_usb_z+18],
            [top_fan_pi_usb_x-16, usb_rear_y, top_fan_pi_usb_z],
            [top_fan_pi_usb_x, usb_rear_y, top_fan_pi_usb_z]
        ]);

        // Mac mini + 100x100x18mm heatsink
        mac_top_z = body_h+top_lid_thick+mac_deck_lift+mac_rail_h+2;
        // Mirrored underside power-button target markers.
        color([1,0.2,0.05,0.45])
        for (button_x=[mac_power_button_x_left, mac_power_button_x_right]) {
            translate([button_x, mac_power_button_y, mac_top_z-0.6])
                cylinder(h=1.2, d=10, center=true);
        }
        color([0.75,0.75,0.8,0.35])
        translate([(body_w-mac_w)/2, mac_saddle_y+mac_clearance, mac_top_z])
            cube([mac_w, mac_d, mac_h]);
        color([0.25,0.25,0.28,0.35])
        translate([body_w/2-heatsink_w/2, mac_saddle_y+mac_clearance+mac_d/2-heatsink_d/2, mac_top_z+mac_h])
            cube([heatsink_w, heatsink_d, heatsink_h]);

        // rear cable space
        color([1,0.55,0,0.18])
        translate([12, rear_y, 2])
            cube([body_w-24, rear_plenum_d-4, body_h-10]);
    }
}

module cable_ghost(points, d, rgba=[0.02,0.02,0.02,0.75]) {
    color(rgba)
    for (i=[0:len(points)-2]) {
        wire_segment(points[i], points[i+1], d);
    }
}

module fan_wire_ghost(points) {
    cable_ghost(points, fan_wire_d, [0.02,0.02,0.02,0.75]);
}

module cable_route_ghosts_only() {
    // Fan cable routes inside the duct.
    fan_wire_ghost([
        [body_w-28, 10, body_h/2],
        [front_fan_wire_side_x, front_cassette_d+18, fan_wire_z],
        [front_fan_wire_side_x, 104, fan_wire_z],
        [front_fan_wire_side_x, 166, fan_wire_z],
        [front_fan_wire_side_x, usb_rear_y, fan_wire_z],
        [body_w/2 + pi_gap/2 + 10, usb_rear_y, pi_z+24]
    ]);

    fan_wire_ghost([
        [body_w/2, top_fan_y+top_base_fan_size-12, body_h-top_base_fan_thick/2],
        [top_fan_wire_side_x, top_fan_y+top_base_fan_size-18, top_fan_wire_z],
        [top_fan_wire_side_x, 156, top_fan_wire_z],
        [top_fan_wire_side_x, usb_rear_y, top_fan_wire_z],
        [top_fan_wire_side_x, usb_rear_y, top_fan_pi_usb_z+18],
        [top_fan_pi_usb_x-16, usb_rear_y, top_fan_pi_usb_z],
        [top_fan_pi_usb_x, usb_rear_y, top_fan_pi_usb_z]
    ]);

    // Mac cable ghosts removed with the printed wire guides.
}

module noctua_140_fan_ghost() {
    // Inspection ghost approximating a 140x25mm Noctua-style axial fan:
    // square frame, round inlet, corner pads/mount holes, hub, struts and blades.
    color([0.55,0.43,0.32,0.28])
    difference() {
        rounded_box([fan_size, fan_size, fan_thick], 8);
        translate([fan_size/2, fan_size/2, -1])
            cylinder(h=fan_thick+2, d=126);
        for (sx=[-1,1], sy=[-1,1]) {
            translate([fan_size/2 + sx*fan_mount_spacing/2,
                       fan_size/2 + sy*fan_mount_spacing/2, -1])
                cylinder(h=fan_thick+2, d=fan_screw_d);
        }
    }

    color([0.84,0.72,0.58,0.35])
    for (sx=[-1,1], sy=[-1,1]) {
        translate([fan_size/2 + sx*fan_mount_spacing/2,
                   fan_size/2 + sy*fan_mount_spacing/2, fan_thick/2])
            rounded_box([18,18,4], 4, center=true);
    }

    color([0.18,0.12,0.08,0.45])
    translate([fan_size/2, fan_size/2, fan_thick/2])
        cylinder(h=fan_thick+1, d=34, center=true);

    color([0.18,0.12,0.08,0.35])
    for (a=[45:90:359]) {
        translate([fan_size/2, fan_size/2, fan_thick/2])
            rotate([0,0,a])
                translate([0,35,0]) cube([4,70,4], center=true);
    }

    color([0.58,0.43,0.28,0.32])
    for (a=[0:45:359]) {
        translate([fan_size/2, fan_size/2, fan_thick/2])
            rotate([0,0,a])
                translate([0,31,0])
                    rotate([0,0,18]) rounded_box([14,52,3], 5, center=true);
    }
}

module wire_segment(p0, p1, d) {
    v = [p1[0]-p0[0], p1[1]-p0[1], p1[2]-p0[2]];
    l = norm(v);
    if (l > 0.01) {
        translate(p0)
            rotate([0, acos(v[2]/l), atan2(v[1], v[0])])
                cylinder(h=l, d=d);
    }
}


module nf_f12_fan_ghost() {
    color([0.18,0.18,0.18,0.28])
    difference() {
        rounded_box([top_base_fan_size, top_base_fan_size, top_base_fan_thick], 6);
        translate([top_base_fan_size/2, top_base_fan_size/2, -1])
            cylinder(h=top_base_fan_thick+2, d=104);
        for (sx=[-1,1], sy=[-1,1]) {
            translate([top_base_fan_size/2 + sx*top_base_fan_mount_spacing/2,
                       top_base_fan_size/2 + sy*top_base_fan_mount_spacing/2, -1])
                cylinder(h=top_base_fan_thick+2, d=top_base_fan_screw_d);
        }
    }
    color([0.05,0.05,0.05,0.32])
    translate([top_base_fan_size/2, top_base_fan_size/2, top_base_fan_thick/2])
        cylinder(h=top_base_fan_thick+1, d=32, center=true);
}

module upper_nf_f12_fan_ghost() {
    color([0.18,0.18,0.18,0.28])
    difference() {
        rounded_box([upper_fan_size, upper_fan_size, upper_fan_thick], 6);
        translate([upper_fan_size/2, upper_fan_size/2, -1])
            cylinder(h=upper_fan_thick+2, d=104);
        for (sx=[-1,1], sy=[-1,1]) {
            translate([upper_fan_size/2 + sx*upper_fan_mount_spacing/2,
                       upper_fan_size/2 + sy*upper_fan_mount_spacing/2, -1])
                cylinder(h=upper_fan_thick+2, d=upper_fan_screw_d);
        }
    }

    color([0.05,0.05,0.05,0.32])
    translate([upper_fan_size/2, upper_fan_size/2, upper_fan_thick/2])
        cylinder(h=upper_fan_thick+1, d=32, center=true);
}

module mac_upper_cooler_preview() {
    color([0.75,0.75,0.8,0.35]) translate([(upper_bridge_w-mac_w)/2, (upper_bridge_d-mac_d)/2, 0]) cube([mac_w, mac_d, mac_h]);
    color([0.25,0.25,0.28,0.45]) translate([(upper_bridge_w-heatsink_w)/2, (upper_bridge_d-heatsink_d)/2, mac_h]) cube([heatsink_w, heatsink_d, heatsink_h]);
    // Clip is shown at fan level, around the single NF-F12 frame, not as a tall stand.
    translate([0, 0, mac_h + heatsink_h + upper_cooler_gap]) {
        upper_fan_origins() upper_nf_f12_fan_ghost();
        color([0.9,0.9,0.9,0.72]) upper_mac_fan_bridge();
    }
}

module hardware_ghosts_only() {
    // front fan mounted inside the cassette, behind the external grille, blowing into the duct
    translate([(body_w-fan_size)/2, front_cassette_d - fan_thick + 5, (body_h-fan_size)/2])
        rotate([90,0,0]) noctua_140_fan_ghost();

    // UGREEN below
    color([0.65,0.65,0.65,0.35])
    translate([(body_w-ugreen_w)/2, ugreen_y, ugreen_z])
        cube([ugreen_w, ugreen_l, ugreen_h]);

    // Pi stacks in the cassettes
    color([0.1,0.6,0.2,0.28])
    translate([body_w/2 - pi_gap/2 - pi_stack_t, pi_y+4, pi_z+4])
        cube([pi_stack_t, 85, pi_body_h]);
    color([0.1,0.6,0.2,0.28])
    translate([body_w/2 + pi_gap/2, pi_y+4, pi_z+4])
        cube([pi_stack_t, 85, pi_body_h]);

    // top fan under lid, inside upper duct
    translate([(body_w-top_base_fan_size)/2, top_fan_y, body_h-top_base_fan_thick])
        nf_f12_fan_ghost();

    // Mac mini seated above lid outlet, with 100x100x18mm heatsink on top.
    mac_top_z = body_h+top_lid_thick+mac_deck_lift+mac_rail_h+2;
    color([0.75,0.75,0.8,0.35])
    translate([(body_w-mac_w)/2, mac_saddle_y+mac_clearance, mac_top_z])
        cube([mac_w, mac_d, mac_h]);
    color([0.25,0.25,0.28,0.35])
    translate([body_w/2-heatsink_w/2, mac_saddle_y+mac_clearance+mac_d/2-heatsink_d/2, mac_top_z+mac_h])
        cube([heatsink_w, heatsink_d, heatsink_h]);

    // One Noctua NF-F12 on the Mac/heatsink upper cooler.
    translate([body_w/2 - upper_bridge_w/2,
               mac_saddle_y+mac_clearance+mac_d/2 - upper_bridge_d/2,
               mac_top_z + mac_h + heatsink_h + upper_cooler_gap])
        upper_fan_origins() upper_nf_f12_fan_ghost();

    cable_route_ghosts_only();
}

module fitted_parts() {
    base_duct();
    color([0.92,0.92,0.92,0.70]) pi_frame_bridge_installed();
    translate([0,0,body_h]) color([0.86,0.86,0.86,0.72]) lid_mac_saddle();
    // Show one installed rocker only. The lid has mirrored mount/window options,
    // but you print/install a single rocker on the correct side.
    translate([0,0,body_h]) color([1.0,0.72,0.25,0.82]) mac_power_rocker_installed();
    translate([5,0,6]) color([0.9,0.9,0.9,0.78]) front_fan_cassette();
    // Pi holders are integrated into pi_frame_bridge_installed(); no separate cassettes.
    translate([body_w/2-upper_bridge_w/2,
               mac_saddle_y+mac_clearance+mac_d/2-upper_bridge_d/2,
               body_h+top_lid_thick+mac_deck_lift+mac_rail_h+2 + mac_h + heatsink_h + upper_cooler_gap])
        color([0.9,0.9,0.9,0.58]) upper_mac_fan_bridge();
}

module fitted_with_hardware() {
    fitted_parts();
    hardware_ghosts_only();
}

module assembly() {
    fitted_with_hardware();
}

module assembly_exploded() {
    // Inspection-only view showing join directions:
    // lid drops onto the base rim, front cassette slides into front receivers,
    // removable Pi bridge snaps onto four base pegs, then Pi cassettes slide in.
    base_duct();

    translate([0,0,body_h+48])
        color([0.86,0.86,0.86,0.72]) lid_mac_saddle();

    translate([5,-62,6])
        color([0.9,0.9,0.9,0.78]) front_fan_cassette();

    translate([0,0,28])
        color([0.92,0.92,0.92,0.70]) pi_frame_bridge_installed();

    // Pi holders are integrated into the removable Pi frame.


    ghosts();
}

module all_print_parts() {
    base_duct();
    translate([body_w+20,0,0]) lid_mac_saddle();
    translate([body_w*2+40,0,0]) front_fan_cassette();
    translate([0,body_d+25,0]) pi_frame_bridge();
    translate([115,body_d+25,0]) upper_mac_fan_bridge();
    translate([0,body_d+95,0]) mac_power_rocker();
}

if (EXPORT_PART == "assembly") assembly();
else if (EXPORT_PART == "assembly_exploded") assembly_exploded();
else if (EXPORT_PART == "fitted_parts") fitted_parts();
else if (EXPORT_PART == "fitted_with_hardware") fitted_with_hardware();
else if (EXPORT_PART == "cable_route_ghosts") cable_route_ghosts_only();
else if (EXPORT_PART == "base_duct") base_duct();
else if (EXPORT_PART == "front_fan_cassette") front_fan_cassette();
else if (EXPORT_PART == "front_fan_cassette_body") front_fan_cassette_body();
else if (EXPORT_PART == "lid_mac_saddle") lid_mac_saddle();
else if (EXPORT_PART == "pi_frame_bridge") pi_frame_bridge();
else if (EXPORT_PART == "pi_cassette_left") pi_cassette("L");
else if (EXPORT_PART == "pi_cassette_right") pi_cassette("R");
else if (EXPORT_PART == "front_noctua_grille") front_noctua_grille();
else if (EXPORT_PART == "front_cassette_with_grille") front_cassette_with_grille();
else if (EXPORT_PART == "upper_mac_fan_bridge") upper_mac_fan_bridge();
else if (EXPORT_PART == "mac_power_rocker") mac_power_rocker();
else if (EXPORT_PART == "mac_upper_cooler_preview") mac_upper_cooler_preview();
else if (EXPORT_PART == "all_print_parts") all_print_parts();
else assembly();
