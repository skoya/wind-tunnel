/* Surface Pro 9 heatsink + Noctua NF-A20 stand - v3 aesthetic shroud

Goals:
- Less blocky: rounded rails, softened lips, curved-ish capsule shroud.
- Hide the fan in normal use.
- Keep fan serviceable for dust cleaning via a removable bottom grille.
- Preserve function: Surface touches exposed aluminium heatsink directly.

Hardware:
- Heatsink: 300 x 140 x 20 mm, flat face up.
- Fan: 200 x 200 x 30 mm underneath.
*/

PART = "assembly";
$fn = 96;

// Hardware
heatsink_w=300; heatsink_d=140; heatsink_h=20;
fan_w=200; fan_d=200; fan_h=30; fan_opening=184;
fan_mount_d=4.6; fan_mount_patterns=[154,170];

// Surface preview
surface_w=287; surface_d=209; surface_t=9.3;

// Geometry
rail_w=13; clearance=1;
base_margin=10;
fan_tray_w=fan_w+2*base_margin; // 220
fan_tray_d=fan_d+2*base_margin; // 220
tray_t=5;
intake_gap=16;
air_gap=7;
skin_t=3.2;

stand_w=heatsink_w+2*rail_w+2*clearance; // 328
stand_d=fan_tray_d;
tray_x=(stand_w-fan_tray_w)/2;
heatsink_x=(stand_w-heatsink_w)/2;
heatsink_y=(stand_d-heatsink_d)/2;
fan_x=(stand_w-fan_w)/2;
fan_y=(stand_d-fan_d)/2;
tray_z=intake_gap;
fan_bottom_z=tray_z+tray_t;
fan_top_z=fan_bottom_z+fan_h;
heatsink_bottom_z=fan_top_z+air_gap;
contact_z=heatsink_bottom_z+heatsink_h;

accent="#b66a2c";      // Noctua-ish warm accent for preview
body="#20252b";        // matte charcoal
body2="#303741";       // slightly lighter side pieces
metal=[0.72,0.73,0.70,0.60];

module rb(s=[10,10,10], r=3){ hull() for(x=[r,s[0]-r]) for(y=[r,s[1]-r]) translate([x,y,0]) cylinder(h=s[2],r=r); }
module cylhole(h=20,d=3.4){ cylinder(h=h,d=d); }

module slot_row(width=130, slot_w=7, slot_l=34, z=0){
  for(x=[-width/2:slot_w*2:width/2]) translate([x,-slot_l/2,z]) rb([slot_w,slot_l,20],slot_w/2);
}

module heatsink_reference(){ color(metal) translate([heatsink_x,heatsink_y,heatsink_bottom_z]) cube([heatsink_w,heatsink_d,heatsink_h]); }
module fan_reference(){ color([0.45,0.30,0.16,0.28]) translate([fan_x,fan_y,fan_bottom_z]) cube([fan_w,fan_d,fan_h]); }
module surface_reference(){ color([0.03,0.04,0.05,0.32]) translate([(stand_w-surface_w)/2,heatsink_y-(surface_d-heatsink_d)/2,contact_z]) cube([surface_w,surface_d,surface_t]); }

// ---------------- Hidden fan tray and bottom dust grille ----------------
module fan_tray_half(front=true){
  half_d=fan_tray_d/2; y0=front?0:half_d;
  difference(){
    union(){
      color(body) translate([0,0,tray_z]) rb([fan_tray_w,half_d,tray_t],8);
      // soft feet leave intake gap below. They look like skid rails, not random cubes.
      color(body) translate([10,8,0]) rb([fan_tray_w-20,18,intake_gap],8);
      color(body) translate([10,half_d-26,0]) rb([fan_tray_w-20,18,intake_gap],8);
      // fan screw pads hidden under shroud
      for(spacing=fan_mount_patterns) for(sx=[-spacing/2,spacing/2]) for(sy=[-spacing/2,spacing/2]){
        yy=fan_tray_d/2+sy-y0;
        if(yy>=6 && yy<=half_d-6) translate([fan_tray_w/2+sx,yy,tray_z+tray_t]) cylinder(h=4,d=13);
      }
      // centre seam tabs
      if(front){
        translate([22,half_d-8,tray_z]) rb([46,18,tray_t+2],5);
        translate([fan_tray_w-68,half_d-8,tray_z]) rb([46,18,tray_t+2],5);
      } else {
        translate([76,-10,tray_z]) rb([46,18,tray_t+2],5);
        translate([fan_tray_w-122,-10,tray_z]) rb([46,18,tray_t+2],5);
      }
      // attachment pads for rails/lip/keeper
      for(x=[10,fan_tray_w-10]) for(gy=[34,fan_tray_d-34]){ yy=gy-y0; if(yy>=8&&yy<=half_d-8) translate([x-8,yy-8,tray_z]) rb([16,16,tray_t+2],4); }
      for(x=[54,fan_tray_w-54]) for(gy=[16,fan_tray_d-16]){ yy=gy-y0; if(yy>=8&&yy<=half_d-8) translate([x-8,yy-8,tray_z]) rb([16,16,tray_t+2],4); }
    }
    translate([fan_tray_w/2,fan_tray_d/2-y0,tray_z-1]) cylinder(h=tray_t+12,d=fan_opening);
    for(spacing=fan_mount_patterns) for(sx=[-spacing/2,spacing/2]) for(sy=[-spacing/2,spacing/2]){ yy=fan_tray_d/2+sy-y0; if(yy>=-2&&yy<=half_d+2) translate([fan_tray_w/2+sx,yy,tray_z-1]) cylhole(tray_t+13,fan_mount_d); }
    if(front) for(x=[44,fan_tray_w-44]) translate([x,half_d+1,tray_z-1]) cylhole(tray_t+11,3.4);
    else for(x=[98,fan_tray_w-98]) translate([x,-1,tray_z-1]) cylhole(tray_t+11,3.4);
    for(x=[10,fan_tray_w-10]) for(gy=[34,fan_tray_d-34]){ yy=gy-y0; if(yy>=-2&&yy<=half_d+2) translate([x,yy,tray_z-1]) cylhole(tray_t+12,3.4); }
    for(x=[54,fan_tray_w-54]) for(gy=[16,fan_tray_d-16]){ yy=gy-y0; if(yy>=-2&&yy<=half_d+2) translate([x,yy,tray_z-1]) cylhole(tray_t+12,3.4); }
  }
}
module fan_tray_front(){ fan_tray_half(true); }
module fan_tray_rear(){ fan_tray_half(false); }
module fan_tray_assembled(){ translate([tray_x,0,0]) fan_tray_front(); translate([tray_x,fan_tray_d/2,0]) fan_tray_rear(); }

module bottom_dust_grille(){
  // Removable underside grille: hides fan from below but can be unscrewed for cleaning.
  // Print separately. Mount with four M3 screws or zip ties to tray underside.
  difference(){
    union(){
      color(accent) rb([fan_tray_w-28,fan_tray_d-28,3],10);
      // small pull tab/front notch detail
      color(accent) translate([(fan_tray_w-28)/2-22,-8,0]) rb([44,12,3],5);
    }
    translate([(fan_tray_w-28)/2,(fan_tray_d-28)/2,-1]) cylinder(h=5,d=168);
    // intake slats - enough open area, but visually closed
    translate([(fan_tray_w-28)/2,(fan_tray_d-28)/2,-1]) rotate([0,0,0]) slot_row(145,7,150,0);
    // screw holes
    for(x=[18,fan_tray_w-46]) for(y=[18,fan_tray_d-46]) translate([x,y,-1]) cylhole(5,3.4);
  }
}

// ---------------- Outer shroud: hides fan from normal view ----------------
module side_shroud(left=true){
  x=left?heatsink_x-rail_w-clearance:heatsink_x+heatsink_w+clearance;
  tab_x=left?x:tray_x+fan_tray_w-24;
  tab_w=left?tray_x+24-x:x+rail_w-(tray_x+fan_tray_w-24);
  hole_x=left?tray_x+10:tray_x+fan_tray_w-10;
  difference(){
    union(){
      // main rail, rounded and taller, visually enclosing fan side
      color(body2) translate([x,heatsink_y-10,0]) rb([rail_w,heatsink_d+20,heatsink_bottom_z+heatsink_h-3],6);
      // inward support shelf for heatsink edge only
      translate([left?heatsink_x-2:heatsink_x+heatsink_w-4,heatsink_y-2,heatsink_bottom_z-3]) cube([6,heatsink_d+4,5]);
      // low continuous side skirt over fan tray, hiding fan edge
      color(body) translate([x,12,0]) rb([rail_w,stand_d-24,fan_top_z+3],7);
      // attachment outriggers
      for(gy=[34,fan_tray_d-34]) translate([tab_x,gy-11,0]) rb([tab_w,22,tray_z+tray_t],5);
    }
    // side intake/exhaust slots. The fan is hidden, but air can leave the shroud.
    for(y=[38,68,98,128,158]) translate([x-1,y,18]) rb([rail_w+3,18,7],3);
    for(y=[34,fan_tray_d-34]) translate([hole_x,y,-1]) cylhole(tray_z+tray_t+4,3.4);
    // cable relief windows higher up
    translate([x-1,heatsink_y+24,fan_top_z+1]) cube([rail_w+2,28,18]);
    translate([x-1,heatsink_y+88,fan_top_z+1]) cube([rail_w+2,28,18]);
  }
}

module support_posts(){
  post_h=heatsink_bottom_z-(tray_z+tray_t);
  for(x=[heatsink_x+18,heatsink_x+heatsink_w-30]) for(y=[heatsink_y+12,heatsink_y+heatsink_d-24]) translate([x,y,tray_z+tray_t]) rb([12,12,post_h],4);
}

module front_lip(){
  lip_w=220; lip_x=(stand_w-lip_w)/2;
  difference(){
    union(){
      // broad curved front fascia hides front fan edge
      color(body) translate([lip_x,4,0]) rb([lip_w,30,fan_top_z+8],10);
      // warm accent catch at top; small visual detail, also stops sliding
      color(accent) translate([lip_x+18,heatsink_y-15,contact_z-4]) rb([lip_w-36,14,10],6);
      color(body2) translate([lip_x+34,heatsink_y-8,contact_z-3]) rb([lip_w-68,8,14],4);
    }
    // keyboard/cable relief
    translate([lip_x+72,heatsink_y-20,contact_z-8]) cube([76,26,25]);
    // underside air slots in front fascia
    for(x=[lip_x+42:24:lip_x+lip_w-42]) translate([x,12,12]) rb([9,24,9],4);
    for(x=[lip_x+54,lip_x+lip_w-54]) translate([x,16,-1]) cylhole(tray_z+tray_t+4,3.4);
  }
}

module rear_keeper(){
  k_w=220; k_x=(stand_w-k_w)/2;
  difference(){
    union(){
      color(body) translate([k_x,stand_d-34,0]) rb([k_w,30,fan_top_z+8],10);
      color(body2) translate([k_x,heatsink_y+heatsink_d+2,heatsink_bottom_z+2]) rb([k_w,9,12],4);
    }
    for(x=[k_x+42:24:k_x+k_w-42]) translate([x,stand_d-28,12]) rb([9,24,9],4);
    for(x=[k_x+54,k_x+k_w-54]) translate([x,stand_d-16,-1]) cylhole(tray_z+tray_t+4,3.4);
  }
}

module printable_frame(){
  fan_tray_assembled();
  side_shroud(true); side_shroud(false);
  support_posts(); front_lip(); rear_keeper();
  // show grille in assembled preview at bottom; separate printable part too
  translate([tray_x+14,14,1]) bottom_dust_grille();
}

module assembly(){ printable_frame(); heatsink_reference(); fan_reference(); surface_reference(); }

if(PART=="assembly") assembly();
else if(PART=="printable_frame") printable_frame();
else if(PART=="left_rail") side_shroud(true);
else if(PART=="right_rail") side_shroud(false);
else if(PART=="fan_tray_front") fan_tray_front();
else if(PART=="fan_tray_rear") fan_tray_rear();
else if(PART=="front_lip") front_lip();
else if(PART=="rear_keeper") rear_keeper();
else if(PART=="bottom_dust_grille") bottom_dust_grille();
else if(PART=="heatsink_reference") heatsink_reference();
else if(PART=="fan_reference") fan_reference();
else surface_reference();
