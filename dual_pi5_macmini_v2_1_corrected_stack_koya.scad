
// dual_pi5_macmini_v2_1_corrected_stack_koya.scad
//
// Latest v2.2:
// - 140mm front fan-sized pressure duct.
// - UGREEN TB/NVMe enclosure sits BELOW the Pi cassettes.
// - Pi cassettes sit ABOVE the UGREEN cradle.
// - Front patterned grille is clipped/contained within the cassette face: no overspill.
// - Mac mini M4 saddle is corner-guide only, with large open centre + 140mm upward fan.
// - Rear is open for exhaust and cable access.
// - UGREEN straps align to screw towers in the base duct.
// - Airflow-optimised internals keep UGREEN front/rear/underside grilles open.
// - Open front-to-back duct keeps airflow unobstructed; Pi guide vanes removed.
// - Part envelopes are asserted against the Bambu Lab P1S build volume.
// - Export each part separately using EXPORT_PART.
//
// EXPORT_PART:
// "assembly", "base_duct", "front_fan_cassette", "lid_mac_saddle",
// "pi_cassette_left", "pi_cassette_right", "ugreen_straps",
// "assembly_exploded", "all_print_parts"

$fn = 72;
EXPORT_PART = "assembly";
SHOW_GHOSTS = true;

// -------------------------
// Core dimensions
// -------------------------
wall = 3;
corner_r = 12;
clearance = 0.6;

fan_size = 140;
fan_thick = 25;
fan_mount_spacing = 124.5; // verify your exact 140mm fan
fan_screw_d = 5.2;
strap_screw_d = 4.2;       // loose M4/class-equivalent clearance for UGREEN straps

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
body_h = 132;     // compacted after lowering UGREEN/Pi stack; still clears 140mm front fan ghost

front_cassette_d = 36;
rear_plenum_d = 28;
rear_y = body_d - rear_plenum_d;

// Lower UGREEN bay
ugreen_l = 122;   // placeholder; measure real enclosure without silicone
ugreen_w = 50;
ugreen_h = 24;
ugreen_y = front_cassette_d + 28;
ugreen_air_under = 14;
ugreen_z = 14 + ugreen_air_under; // underside airflow
ugreen_top_clearance = 14;
ugreen_strap_w = ugreen_w + 30;
ugreen_strap_mount_z = ugreen_z + ugreen_h + 3; // strap sits just over measured enclosure height
ugreen_peg_d = 4.5;
ugreen_pad_d = 9;
ugreen_side_keeper_h = 7;

// Upper Pi bay: cassettes sit above UGREEN, not beside/inside it
pi_stack_t = 34;       // assembled Pi + HAT thickness placeholder
pi_card_d = 92;
pi_card_h = 58;
pi_gap = 8;
pi_y = front_cassette_d + 26;
pi_z = ugreen_z + ugreen_h + ugreen_top_clearance;
pi_lower_guide_h = 10;
pi_upper_keeper_h = 6;
pi_guide_t = 3;

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
fan_wire_d = 3;
wire_clip_gap = 4.2;
wire_clip_t = 2;
wire_clip_h = 7;
wire_clip_depth = 6;
front_fan_wire_side_x = body_w - wall - 8;
top_fan_wire_side_x = wall + 8;
fan_wire_z = 18;
top_fan_wire_z = body_h - 10;
usb_rear_y = body_d - 18;

// Mac saddle / top fan
top_lid_thick = 5;
top_fan_recess = 10;
top_fan_y = 48;
mac_saddle_w = mac_w + mac_clearance*2;
mac_saddle_d = mac_d + mac_clearance*2;
mac_saddle_x = (body_w - mac_saddle_w)/2;
mac_saddle_y = top_fan_y + 7;
mac_deck_lift = 24; // gives ~18mm clear plenum above recessed 25mm top fan in assembly
mac_rail_h = 8;
mac_rail_t = 5;
mac_riser_t = 8;

// Individual printable envelopes must fit the P1S build volume.
assert(body_w <= p1s_build_x && body_d <= p1s_build_y && body_h <= p1s_build_z,
       "base_duct envelope exceeds Bambu Lab P1S build volume");
assert(body_w <= p1s_build_x && body_d <= p1s_build_y && (top_lid_thick + 13 + mac_deck_lift + mac_rail_h) <= p1s_build_z,
       "lid_mac_saddle envelope exceeds Bambu Lab P1S build volume");
assert((body_w-10) <= p1s_build_x && front_cassette_d <= p1s_build_y && (body_h-12) <= p1s_build_z,
       "front_fan_cassette envelope exceeds Bambu Lab P1S build volume");
assert(pi_stack_t <= p1s_build_x && pi_card_d <= p1s_build_y && (pi_card_h + 11) <= p1s_build_z,
       "pi_cassette envelope exceeds Bambu Lab P1S build volume");
assert(ugreen_strap_w <= p1s_build_x && (ugreen_l-52+14) <= p1s_build_y && 5 <= p1s_build_z,
       "ugreen_straps envelope exceeds Bambu Lab P1S build volume");

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
            rounded_box([body_w, body_d, 14], corner_r);

            // solid pressure duct sides
            translate([0,0,0]) rounded_box([wall, body_d, body_h], 3);
            translate([body_w-wall,0,0]) rounded_box([wall, body_d, body_h], 3);

            // rear low lip, no mesh
            translate([0, body_d-wall, 0]) cube([body_w, wall, 34]);

            front_cassette_receivers();

            lid_support_rails();

            // UGREEN lower cradle
            ugreen_cradle();

            // Pi upper cassette receiver rails
            pi_receiver(body_w/2 - pi_gap/2 - pi_stack_t, pi_y);
            pi_receiver(body_w/2 + pi_gap/2, pi_y);

            fan_cable_clips();
        }

        // front fan opening
        translate([14, -1, 18]) cube([body_w-28, front_cassette_d+4, body_h-32]);

        // rear exhaust/cable opening
        translate([8, body_d-wall-1, 10]) cube([body_w-16, wall+4, body_h-18]);
        translate([10, body_d-wall-1, 0]) cube([body_w-20, wall+4, 52]);
    }
}

module front_cassette_receivers() {
    // Join detail: front_fan_cassette tongues slide into these two vertical receivers.
    translate([6, 0, 14]) cube([5, front_cassette_d+8, body_h-24]);
    translate([body_w-11, 0, 14]) cube([5, front_cassette_d+8, body_h-24]);
}

module lid_support_rails() {
    // Join detail: lid_mac_saddle underside tongues drop onto these ledges.
    translate([wall+1, 10, body_h-6]) cube([8, body_d-20, 4]);
    translate([body_w-wall-9, 10, body_h-6]) cube([8, body_d-20, 4]);
}

module cable_clip(x, y, z, side=1) {
    // Low-force open clip for USB fan leads. The mouth faces inward, but the
    // clip body lives on the side wall to avoid blocking duct airflow.
    translate([x, y, z])
    difference() {
        cube([wire_clip_depth, wire_clip_t, wire_clip_h], center=true);
        translate([side*wire_clip_depth/4, 0, 0])
            cube([wire_clip_depth/2+0.2, wire_clip_t+0.4, wire_clip_gap], center=true);
    }
}

module fan_cable_clips() {
    // Front fan lead: route along right wall to rear USB area.
    for (y=[front_cassette_d+18, 104, 166, usb_rear_y]) {
        cable_clip(front_fan_wire_side_x, y, fan_wire_z, -1);
    }

    // Top fan lead: route down the left rear/side wall, staying out of the top fan opening.
    for (y=[top_fan_y+fan_size-18, 156, usb_rear_y]) {
        cable_clip(top_fan_wire_side_x, y, top_fan_wire_z, 1);
    }
}

module ugreen_cradle() {
    ux = (body_w - ugreen_w) / 2;
    uy = ugreen_y;

    difference() {
        union() {
            // Thin peg legs and small pads support UGREEN while leaving underside airflow open.
            for (x=[ux+7, ux+ugreen_w-7], yy=[uy+16, uy+ugreen_l/2, uy+ugreen_l-16]) {
                translate([x, yy, 14]) cylinder(h=ugreen_air_under, d=ugreen_peg_d);
                translate([x, yy, ugreen_z-1.2]) cylinder(h=1.2, d=ugreen_pad_d);
            }

            // Side-only keeper nubs; no front/rear cross stop over the enclosure grilles.
            for (x=[ux-6, ux+ugreen_w+6], yy=[uy+18, uy+ugreen_l-18]) {
                translate([x, yy, ugreen_z]) cylinder(h=ugreen_side_keeper_h, d=ugreen_peg_d);
            }

            // strap towers align with separate ugreen_straps screw holes
            for (yy=[uy+18, uy+ugreen_l-34]) {
                translate([ux-14, yy, ugreen_z]) cube([6, 14, 30]);
                translate([ux+ugreen_w+8, yy, ugreen_z]) cube([6, 14, 30]);
            }

            // Tunnel edge rails define the lower airflow path without carrying the enclosure.
            translate([ux-17, uy-8, 14]) cube([3, min(ugreen_l+16, body_d-uy-10), ugreen_air_under-3]);
            translate([ux+ugreen_w+14, uy-8, 14]) cube([3, min(ugreen_l+16, body_d-uy-10), ugreen_air_under-3]);
        }

        // vertical clearance through strap towers for heat-set inserts or loose fasteners
        for (yy=[uy+18+7, uy+ugreen_l-34+7]) {
            translate([ux-11, yy, ugreen_z-1]) cylinder(h=34, d=strap_screw_d);
            translate([ux+ugreen_w+11, yy, ugreen_z-1]) cylinder(h=34, d=strap_screw_d);
        }
    }
}

module pi_receiver(x, y) {
    // Low-profile guides keep the Pi cassette located without covering board faces.
    translate([x-2, y, pi_z]) cube([pi_guide_t, pi_card_d, pi_lower_guide_h]);
    translate([x+pi_stack_t-1, y, pi_z]) cube([pi_guide_t, pi_card_d, pi_lower_guide_h]);

    // rear stop/tab
    translate([x-2, y+pi_card_d-5, pi_z]) cube([pi_stack_t+4, 5, 8]);

    // small upper anti-tip nubs only; airflow remains open around the Pi faces.
    translate([x-2, y+18, pi_z+pi_card_h-pi_upper_keeper_h]) cube([pi_guide_t+1, 14, pi_upper_keeper_h]);
    translate([x+pi_stack_t-2, y+18, pi_z+pi_card_h-pi_upper_keeper_h]) cube([pi_guide_t+1, 14, pi_upper_keeper_h]);
    translate([x-2, y+pi_card_d-34, pi_z+pi_card_h-pi_upper_keeper_h]) cube([pi_guide_t+1, 14, pi_upper_keeper_h]);
    translate([x+pi_stack_t-2, y+pi_card_d-34, pi_z+pi_card_h-pi_upper_keeper_h]) cube([pi_guide_t+1, 14, pi_upper_keeper_h]);
}

// -------------------------
// Front fan cassette
// -------------------------
module front_fan_cassette() {
    difference() {
        union() {
            rounded_box([body_w-10, front_cassette_d, body_h-12], 8);

            // Join detail: these tongues slide into base_duct front_cassette_receivers().
            translate([-4,4,6]) cube([5, front_cassette_d-8, body_h-24]);
            translate([body_w-11,4,6]) cube([5, front_cassette_d-8, body_h-24]);

            // rear pocket holds removable filter media behind the printed pattern.
            filter_media_pocket();

            // decorative filter-support pattern is embedded in face and clipped.
            translate([(body_w-10)/2, -1.6, (body_h-12)/2])
                rotate([90,0,0]) clipped_filter_grille_pattern();
        }

        // airflow opening behind grille
        translate([(body_w-10)/2, -4, (body_h-12)/2])
            rotate([90,0,0]) cylinder(h=front_cassette_d+8, d=122);

        // fan mount holes
        for (sx=[-1,1], sz=[-1,1]) {
            translate([(body_w-10)/2 + sx*fan_mount_spacing/2, front_cassette_d/2, (body_h-12)/2 + sz*fan_mount_spacing/2])
                rotate([90,0,0]) cylinder(h=front_cassette_d+6, d=fan_screw_d, center=true);
        }
    }
}

// -------------------------
// Lid + Mac mini saddle
// -------------------------
module lid_mac_saddle() {
    difference() {
        union() {
            rounded_box([body_w, body_d, top_lid_thick], corner_r);

            // underside locating tongues
            translate([wall+1, 12, -5]) cube([8, body_d-24, 5]);
            translate([body_w-wall-9, 12, -5]) cube([8, body_d-24, 5]);

            // top 140mm fan frame, recessed into the lid/ceiling.
            translate([(body_w-fan_size)/2, top_fan_y, top_lid_thick-top_fan_recess])
                top_fan_frame();

            // Mac guides sit on four corner stanchions rising from the lid/top-fan frame.
            mac_saddle_risers();

            // Mac guides touch only corners/edges; centre is open
            mac_guides();

            // rear cable guard for Mac, not a wall blocking exhaust
            translate([mac_saddle_x, mac_saddle_y+mac_saddle_d+7, top_lid_thick])
                rounded_box([mac_saddle_w, 6, mac_rail_h], 3);
        }

        // upward fan opening: avoids blocking Mac intake
        translate([body_w/2, top_fan_y+fan_size/2, -1])
            cylinder(h=34, d=126);

        // top fan mount holes
        for (sx=[-1,1], sy=[-1,1]) {
            translate([body_w/2 + sx*fan_mount_spacing/2, top_fan_y+fan_size/2 + sy*fan_mount_spacing/2, -1])
                cylinder(h=36, d=fan_screw_d);
        }

        // M4 Mac mini bottom power-button access cut-out, generous.
        // Verify exact button location on your own unit.
        translate([body_w/2-18, mac_saddle_y+mac_saddle_d-30, -1])
            rounded_box([36, 28, 36], 9);
    }
}

module top_fan_frame() {
    difference() {
        rounded_box([fan_size, fan_size, 13], 8);
        translate([fan_size/2, fan_size/2, -1])
            cylinder(h=18, d=126);
    }
}

module mac_guides() {
    x = mac_saddle_x;
    y = mac_saddle_y;
    z = top_lid_thick - top_fan_recess + 13 + mac_deck_lift;

    // corner guides only; do not form a tray that blocks underside airflow
    translate([x, y, z]) rounded_box([24, mac_rail_t, mac_rail_h], 3);
    translate([x+mac_saddle_w-24, y, z]) rounded_box([24, mac_rail_t, mac_rail_h], 3);
    translate([x, y+mac_saddle_d-mac_rail_t, z]) rounded_box([24, mac_rail_t, mac_rail_h], 3);
    translate([x+mac_saddle_w-24, y+mac_saddle_d-mac_rail_t, z]) rounded_box([24, mac_rail_t, mac_rail_h], 3);

    translate([x, y, z]) rounded_box([mac_rail_t, 24, mac_rail_h], 3);
    translate([x+mac_saddle_w-mac_rail_t, y, z]) rounded_box([mac_rail_t, 24, mac_rail_h], 3);
    translate([x, y+mac_saddle_d-24, z]) rounded_box([mac_rail_t, 24, mac_rail_h], 3);
    translate([x+mac_saddle_w-mac_rail_t, y+mac_saddle_d-24, z]) rounded_box([mac_rail_t, 24, mac_rail_h], 3);
}

module mac_saddle_risers() {
    x = mac_saddle_x;
    y = mac_saddle_y;
    z = top_lid_thick - top_fan_recess + 13;

    // Four small corner stanchions carry the Mac guide rails. They sit on the
    // lid/fan-frame perimeter and stay outside the central underside airflow path.
    translate([x, y, z]) rounded_box([mac_riser_t, mac_riser_t, mac_deck_lift], 3);
    translate([x+mac_saddle_w-mac_riser_t, y, z]) rounded_box([mac_riser_t, mac_riser_t, mac_deck_lift], 3);
    translate([x, y+mac_saddle_d-mac_riser_t, z]) rounded_box([mac_riser_t, mac_riser_t, mac_deck_lift], 3);
    translate([x+mac_saddle_w-mac_riser_t, y+mac_saddle_d-mac_riser_t, z]) rounded_box([mac_riser_t, mac_riser_t, mac_deck_lift], 3);
}

// -------------------------
// Pi cassettes
// -------------------------
module pi_cassette(label="L") {
    difference() {
        union() {
            rounded_box([pi_stack_t, 5, pi_lower_guide_h], 2);

            // low side edge guides hold the stack without masking the Pi faces
            translate([0,0,0]) cube([4, pi_card_d, pi_lower_guide_h]);
            translate([pi_stack_t-4,0,0]) cube([4, pi_card_d, pi_lower_guide_h]);

            // bottom support, kept shallow and open above
            translate([0,0,0]) cube([pi_stack_t, pi_card_d, 5]);

            // small upper retention tabs stop tipping without becoming full-height rails
            for (yy=[18, pi_card_d-34]) {
                translate([0, yy, pi_card_h-pi_upper_keeper_h]) cube([2, 14, pi_upper_keeper_h]);
                translate([pi_stack_t-2, yy, pi_card_h-pi_upper_keeper_h]) cube([2, 14, pi_upper_keeper_h]);
            }

            // top pull tab
            translate([4, pi_card_d-2, pi_card_h])
                rounded_box([pi_stack_t-8, 10, 11], 3);
        }

        // lighten the shallow base while preserving edge support.
        translate([7, 10, -1]) cube([pi_stack_t-14, pi_card_d-20, 7]);
    }
}

module ugreen_straps() {
    for (yy=[0, ugreen_l-52]) {
        translate([0, yy, 0])
        difference() {
            rounded_box([ugreen_strap_w, 14, 5], 4);
            translate([10, -1, -1]) cube([ugreen_strap_w-20, 16, 7]);
            translate([5,7,-1]) cylinder(h=8, d=strap_screw_d);
            translate([ugreen_strap_w-5,7,-1]) cylinder(h=8, d=strap_screw_d);
        }
    }
}

// -------------------------
// Assembly ghost envelopes
// -------------------------
module ghosts() {
    if (SHOW_GHOSTS) {
        // front fan
        translate([(body_w-fan_size)/2, 5, (body_h-fan_size)/2+10])
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
        translate([(body_w-ugreen_w)/2, ugreen_y, ugreen_z+8])
            cube([ugreen_w, ugreen_l, ugreen_h]);

        // Pis above UGREEN
        color([0.1,0.6,0.2,0.28])
        translate([body_w/2 - pi_gap/2 - pi_stack_t, pi_y+4, pi_z+6])
            cube([pi_stack_t, 85, pi_card_h-12]);
        color([0.1,0.6,0.2,0.28])
        translate([body_w/2 + pi_gap/2, pi_y+4, pi_z+6])
            cube([pi_stack_t, 85, pi_card_h-12]);

        // top fan
        translate([(body_w-fan_size)/2, top_fan_y, body_h+10+top_lid_thick-top_fan_recess])
            noctua_140_fan_ghost();
        fan_wire_ghost([
            [body_w/2, top_fan_y+fan_size-12, body_h+10+top_lid_thick-top_fan_recess+fan_thick/2],
            [top_fan_wire_side_x, top_fan_y+fan_size-18, top_fan_wire_z],
            [top_fan_wire_side_x, 156, top_fan_wire_z],
            [top_fan_wire_side_x, usb_rear_y, top_fan_wire_z],
            [body_w/2 - pi_gap/2 - 10, usb_rear_y, pi_z+36]
        ]);

        // Mac mini
        color([0.75,0.75,0.8,0.35])
        translate([(body_w-mac_w)/2, mac_saddle_y+mac_clearance,
                   body_h+10+top_lid_thick-top_fan_recess+13+mac_deck_lift+mac_rail_h+10])
            cube([mac_w, mac_d, mac_h]);

        // rear cable space
        color([1,0.55,0,0.18])
        translate([12, rear_y, 2])
            cube([body_w-24, rear_plenum_d-4, body_h-10]);
    }
}

module fan_wire_ghost(points) {
    color([0.02,0.02,0.02,0.75])
    for (i=[0:len(points)-2]) {
        wire_segment(points[i], points[i+1], fan_wire_d);
    }
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

module assembly() {
    base_duct();

    translate([0,0,body_h+10])
        color([0.86,0.86,0.86,0.72]) lid_mac_saddle();

    translate([5,-22,6])
        color([0.9,0.9,0.9,0.78]) front_fan_cassette();

    translate([body_w/2 - pi_gap/2 - pi_stack_t, pi_y+2, pi_z])
        color([0.9,0.9,0.9,0.78]) pi_cassette("L");
    translate([body_w/2 + pi_gap/2, pi_y+2, pi_z])
        color([0.9,0.9,0.9,0.78]) pi_cassette("R");

    translate([(body_w-ugreen_strap_w)/2, ugreen_y+18, ugreen_strap_mount_z])
        color([0.9,0.9,0.9,0.78]) ugreen_straps();

    ghosts();
}

module assembly_exploded() {
    // Inspection-only view showing join directions:
    // lid drops onto side ledges, front cassette slides into front receivers,
    // Pi cassettes slide into low-profile receiver guides, straps screw to towers.
    base_duct();

    translate([0,0,body_h+48])
        color([0.86,0.86,0.86,0.72]) lid_mac_saddle();

    translate([5,-62,6])
        color([0.9,0.9,0.9,0.78]) front_fan_cassette();

    translate([body_w/2 - pi_gap/2 - pi_stack_t - 18, pi_y+2, pi_z+10])
        color([0.9,0.9,0.9,0.78]) pi_cassette("L");
    translate([body_w/2 + pi_gap/2 + 18, pi_y+2, pi_z+10])
        color([0.9,0.9,0.9,0.78]) pi_cassette("R");

    translate([(body_w-ugreen_strap_w)/2, ugreen_y+18, ugreen_strap_mount_z+22])
        color([0.9,0.9,0.9,0.78]) ugreen_straps();

    ghosts();
}

module all_print_parts() {
    base_duct();
    translate([body_w+20,0,0]) lid_mac_saddle();
    translate([body_w*2+40,0,0]) front_fan_cassette();
    translate([0,body_d+25,0]) pi_cassette("L");
    translate([50,body_d+25,0]) pi_cassette("R");
    translate([105,body_d+25,0]) ugreen_straps();
}

if (EXPORT_PART == "assembly") assembly();
else if (EXPORT_PART == "assembly_exploded") assembly_exploded();
else if (EXPORT_PART == "base_duct") base_duct();
else if (EXPORT_PART == "front_fan_cassette") front_fan_cassette();
else if (EXPORT_PART == "lid_mac_saddle") lid_mac_saddle();
else if (EXPORT_PART == "pi_cassette_left") pi_cassette("L");
else if (EXPORT_PART == "pi_cassette_right") pi_cassette("R");
else if (EXPORT_PART == "ugreen_straps") ugreen_straps();
else if (EXPORT_PART == "all_print_parts") all_print_parts();
else assembly();
