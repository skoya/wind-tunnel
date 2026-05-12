/* Surface Pro 9 heatsink + Noctua NF-A20 stand - v4 lightweight shroud

v4 objective: keep v3's smoother/hidden-fan look but cut plastic volume.
Changes:
- thinner tray/shroud sections;
- open ribbed side rails instead of solid skirts;
- lighter front/rear fascias with large hidden cut-outs;
- thin removable dust grille;
- same direct aluminium contact surface.
*/

PART="assembly";
$fn=72;

heatsink_w=300; heatsink_d=140; heatsink_h=20;
fan_w=200; fan_d=200; fan_h=30; fan_opening=184;
fan_mount_d=4.6; fan_mount_patterns=[154,170];
surface_w=287; surface_d=209; surface_t=9.3;

rail_w=11; clearance=1;
base_margin=8;
fan_tray_w=fan_w+2*base_margin; //216
fan_tray_d=fan_d+2*base_margin; //216
tray_t=3.2;
intake_gap=16;
air_gap=7;
rib=5;

stand_w=heatsink_w+2*rail_w+2*clearance;
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

body="#20252b"; body2="#303741"; accent="#b66a2c"; metal=[0.72,0.73,0.70,0.60];

module rb(s=[10,10,10],r=3){ hull() for(x=[r,s[0]-r]) for(y=[r,s[1]-r]) translate([x,y,0]) cylinder(h=s[2],r=r); }
module hole(h=20,d=3.4){ cylinder(h=h,d=d); }
module slot(s=[8,30,20],r=3){ rb(s,r); }

module heatsink_reference(){ color(metal) translate([heatsink_x,heatsink_y,heatsink_bottom_z]) cube([heatsink_w,heatsink_d,heatsink_h]); }
module fan_reference(){ color([0.45,0.30,0.16,0.22]) translate([fan_x,fan_y,fan_bottom_z]) cube([fan_w,fan_d,fan_h]); }
module surface_reference(){ color([0.03,0.04,0.05,0.30]) translate([(stand_w-surface_w)/2,heatsink_y-(surface_d-heatsink_d)/2,contact_z]) cube([surface_w,surface_d,surface_t]); }

module fan_tray_half(front=true){
  half_d=fan_tray_d/2; y0=front?0:half_d;
  difference(){
    union(){
      // minimal ring-like half tray
      color(body) translate([0,0,tray_z]) rb([fan_tray_w,half_d,tray_t],7);
      // long skid feet, hollowed by cutouts below
      color(body) translate([10,8,0]) rb([fan_tray_w-20,14,intake_gap],7);
      color(body) translate([10,half_d-22,0]) rb([fan_tray_w-20,14,intake_gap],7);
      // screw pads only where needed
      for(spacing=fan_mount_patterns) for(sx=[-spacing/2,spacing/2]) for(sy=[-spacing/2,spacing/2]){
        yy=fan_tray_d/2+sy-y0; if(yy>=6&&yy<=half_d-6) translate([fan_tray_w/2+sx,yy,tray_z+tray_t]) cylinder(h=3,d=11);
      }
      // seam tabs
      if(front){ translate([24,half_d-7,tray_z]) rb([40,16,tray_t+1.8],4); translate([fan_tray_w-64,half_d-7,tray_z]) rb([40,16,tray_t+1.8],4); }
      else { translate([76,-9,tray_z]) rb([40,16,tray_t+1.8],4); translate([fan_tray_w-116,-9,tray_z]) rb([40,16,tray_t+1.8],4); }
      // attachment pads
      for(x=[10,fan_tray_w-10]) for(gy=[34,fan_tray_d-34]){ yy=gy-y0; if(yy>=8&&yy<=half_d-8) translate([x-7,yy-7,tray_z]) rb([14,14,tray_t+1.8],3); }
      for(x=[54,fan_tray_w-54]) for(gy=[16,fan_tray_d-16]){ yy=gy-y0; if(yy>=8&&yy<=half_d-8) translate([x-7,yy-7,tray_z]) rb([14,14,tray_t+1.8],3); }
    }
    // main fan opening
    translate([fan_tray_w/2,fan_tray_d/2-y0,tray_z-1]) cylinder(h=tray_t+9,d=fan_opening);
    // extra lightening: four corner scallops in tray plate, leaving perimeter/ribs
    for(x=[42,fan_tray_w-70]) for(yy=[24,half_d-48]) translate([x,yy,tray_z-1]) rb([28,24,tray_t+8],6);
    // holes
    for(spacing=fan_mount_patterns) for(sx=[-spacing/2,spacing/2]) for(sy=[-spacing/2,spacing/2]){ yy=fan_tray_d/2+sy-y0; if(yy>=-2&&yy<=half_d+2) translate([fan_tray_w/2+sx,yy,tray_z-1]) hole(tray_t+11,fan_mount_d); }
    if(front) for(x=[44,fan_tray_w-44]) translate([x,half_d+1,tray_z-1]) hole(tray_t+10,3.4);
    else for(x=[98,fan_tray_w-98]) translate([x,-1,tray_z-1]) hole(tray_t+10,3.4);
    for(x=[10,fan_tray_w-10]) for(gy=[34,fan_tray_d-34]){ yy=gy-y0; if(yy>=-2&&yy<=half_d+2) translate([x,yy,tray_z-1]) hole(tray_t+10,3.4); }
    for(x=[54,fan_tray_w-54]) for(gy=[16,fan_tray_d-16]){ yy=gy-y0; if(yy>=-2&&yy<=half_d+2) translate([x,yy,tray_z-1]) hole(tray_t+10,3.4); }
  }
}
module fan_tray_front(){ fan_tray_half(true); }
module fan_tray_rear(){ fan_tray_half(false); }
module fan_tray_assembled(){ translate([tray_x,0,0]) fan_tray_front(); translate([tray_x,fan_tray_d/2,0]) fan_tray_rear(); }

module bottom_dust_grille(){
  difference(){
    union(){ color(accent) rb([fan_tray_w-34,fan_tray_d-34,2.2],9); color(accent) translate([(fan_tray_w-34)/2-20,-7,0]) rb([40,10,2.2],5); }
    translate([(fan_tray_w-34)/2,(fan_tray_d-34)/2,-1]) cylinder(h=5,d=164);
    // radial-ish slats represented as parallel slots
    for(x=[26:14:fan_tray_w-60]) translate([x,20,-1]) rb([6,fan_tray_d-74,5],3);
    for(x=[18,fan_tray_w-52]) for(y=[18,fan_tray_d-52]) translate([x,y,-1]) hole(5,3.4);
  }
}

module side_shroud(left=true){
  x=left?heatsink_x-rail_w-clearance:heatsink_x+heatsink_w+clearance;
  tab_x=left?x:tray_x+fan_tray_w-22;
  tab_w=left?tray_x+22-x:x+rail_w-(tray_x+fan_tray_w-22);
  hole_x=left?tray_x+10:tray_x+fan_tray_w-10;
  difference(){
    union(){
      // top rail around heatsink
      color(body2) translate([x,heatsink_y-10,0]) rb([rail_w,heatsink_d+20,heatsink_bottom_z+heatsink_h-3],5);
      translate([left?heatsink_x-2:heatsink_x+heatsink_w-4,heatsink_y-2,heatsink_bottom_z-3]) cube([5,heatsink_d+4,4.5]);
      // lightweight lower side: three ribs, not a slab
      for(y=[18,stand_d/2-8,stand_d-34]) color(body) translate([x,y,0]) rb([rail_w,28,fan_top_z+2],6);
      // top/bottom stringers hide sightline to fan
      color(body) translate([x,16,fan_top_z-2]) rb([rail_w,stand_d-32,6],4);
      color(body) translate([x,16,0]) rb([rail_w,stand_d-32,6],4);
      for(gy=[34,fan_tray_d-34]) translate([tab_x,gy-10,0]) rb([tab_w,20,tray_z+tray_t],4);
    }
    // more open side slots/cutouts
    for(y=[46,78,110,142]) translate([x-1,y,16]) rb([rail_w+3,20,10],4);
    for(y=[34,fan_tray_d-34]) translate([hole_x,y,-1]) hole(tray_z+tray_t+4,3.4);
    translate([x-1,heatsink_y+24,fan_top_z+1]) cube([rail_w+2,28,18]);
    translate([x-1,heatsink_y+88,fan_top_z+1]) cube([rail_w+2,28,18]);
  }
}

module support_posts(){ post_h=heatsink_bottom_z-(tray_z+tray_t); for(x=[heatsink_x+18,heatsink_x+heatsink_w-30]) for(y=[heatsink_y+12,heatsink_y+heatsink_d-24]) translate([x,y,tray_z+tray_t]) rb([10,10,post_h],3); }

module front_lip(){
  lip_w=216; lip_x=(stand_w-lip_w)/2;
  difference(){
    union(){
      // lightweight fascia: perimeter + ribs rather than solid wall
      color(body) translate([lip_x,5,0]) rb([lip_w,24,fan_top_z+6],9);
      for(x=[lip_x+28:32:lip_x+lip_w-46]) color(body) translate([x,5,0]) rb([10,24,fan_top_z+9],5);
      color(accent) translate([lip_x+24,heatsink_y-15,contact_z-4]) rb([lip_w-48,13,9],6);
    }
    // hollow most of the fascia backside
    translate([lip_x+14,10,9]) rb([lip_w-28,18,fan_top_z-2],7);
    translate([lip_x+70,heatsink_y-20,contact_z-8]) cube([76,26,25]);
    for(x=[lip_x+54,lip_x+lip_w-54]) translate([x,16,-1]) hole(tray_z+tray_t+4,3.4);
  }
}

module rear_keeper(){
  k_w=216; k_x=(stand_w-k_w)/2;
  difference(){
    union(){
      color(body) translate([k_x,stand_d-29,0]) rb([k_w,24,fan_top_z+6],9);
      for(x=[k_x+28:32:k_x+k_w-46]) color(body) translate([x,stand_d-29,0]) rb([10,24,fan_top_z+9],5);
      color(body2) translate([k_x+8,heatsink_y+heatsink_d+2,heatsink_bottom_z+2]) rb([k_w-16,8,11],4);
    }
    translate([k_x+14,stand_d-28,9]) rb([k_w-28,18,fan_top_z-2],7);
    for(x=[k_x+54,k_x+k_w-54]) translate([x,stand_d-16,-1]) hole(tray_z+tray_t+4,3.4);
  }
}

module printable_frame(){ fan_tray_assembled(); side_shroud(true); side_shroud(false); support_posts(); front_lip(); rear_keeper(); translate([tray_x+17,17,1]) bottom_dust_grille(); }
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
