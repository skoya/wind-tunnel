/* Surface Pro 9 heatsink + Noctua NF-A20 stand - v2

Fixes from v1:
1. Fan gets a real intake plenum: tray is lifted 14mm off the desk on printed feet.
2. Parts have explicit attachment points:
   - fan tray front/rear halves overlap and bolt/zip-tie together;
   - left/right rails bolt/zip-tie to tray outriggers;
   - front lip and rear keeper bolt/zip-tie to the fan tray via vertical risers.
3. Heatsink remains the only top contact surface. No plastic between Surface and aluminium.

Dimensions supplied:
- Heatsink: 300 x 140 x 20 mm
- Fan: 200 x 200 x 30 mm
*/

PART = "assembly";
$fn = 72;

// Hardware
heatsink_w = 300; heatsink_d = 140; heatsink_h = 20;
fan_w = 200; fan_d = 200; fan_h = 30;
fan_opening = 184;
fan_mount_d = 4.6;
fan_mount_patterns = [154, 170];

// Surface preview only
surface_w = 287; surface_d = 209; surface_t = 9.3;

// Printed structure
rail_w = 13;
clearance = 1.0;
base_margin = 8;
fan_tray_w = fan_w + 2*base_margin;   // 216mm
fan_tray_d = fan_d + 2*base_margin;   // 216mm
tray_t = 5;
intake_gap = 14;                       // desk -> underside of fan tray
air_gap = 6;                           // fan top -> heatsink underside

stand_w = heatsink_w + 2*rail_w + 2*clearance; // 328mm assembled width
stand_d = fan_tray_d;
tray_x = (stand_w - fan_tray_w)/2;
heatsink_x = (stand_w - heatsink_w)/2;
heatsink_y = (stand_d - heatsink_d)/2;
fan_x = (stand_w - fan_w)/2;
fan_y = (stand_d - fan_d)/2;

tray_z = intake_gap;
fan_bottom_z = tray_z + tray_t;
fan_top_z = fan_bottom_z + fan_h;
heatsink_bottom_z = fan_top_z + air_gap;
contact_z = heatsink_bottom_z + heatsink_h;

module rb(size=[10,10,10], r=2) {
  hull() for (x=[r,size[0]-r]) for (y=[r,size[1]-r]) translate([x,y,0]) cylinder(h=size[2], r=r);
}
module hole(h=20,d=3.4){ cylinder(h=h,d=d); }

module heatsink_reference(){ color([0.72,0.73,0.70,0.55]) translate([heatsink_x,heatsink_y,heatsink_bottom_z]) cube([heatsink_w,heatsink_d,heatsink_h]); }
module fan_reference(){ color([0.45,0.30,0.16,0.38]) translate([fan_x,fan_y,fan_bottom_z]) cube([fan_w,fan_d,fan_h]); }
module surface_reference(){ color([0.03,0.04,0.05,0.35]) translate([(stand_w-surface_w)/2, heatsink_y-(surface_d-heatsink_d)/2, contact_z]) cube([surface_w,surface_d,surface_t]); }

// ---------------- Fan tray halves ----------------
module fan_tray_half(front=true){
  half_d = fan_tray_d/2;
  y0 = front ? 0 : half_d;
  difference(){
    union(){
      // raised tray plate
      translate([0,0,tray_z]) rb([fan_tray_w,half_d,tray_t],4);

      // four low feet per half leave underside open for fan intake
      for (x=[8,fan_tray_w-28]) for (y=[8,half_d-28]) translate([x,y,0]) rb([20,20,intake_gap],4);

      // fan screw pads
      for (spacing=fan_mount_patterns) for (sx=[-spacing/2,spacing/2]) for (sy=[-spacing/2,spacing/2]){
        yy = fan_tray_d/2 + sy - y0;
        if (yy>=6 && yy<=half_d-6) translate([fan_tray_w/2+sx,yy,tray_z+tray_t]) cylinder(h=4,d=13);
      }

      // front/rear half overlap tabs
      if(front){
        translate([18,half_d-8,tray_z]) rb([44,18,tray_t+2],3);
        translate([fan_tray_w-62,half_d-8,tray_z]) rb([44,18,tray_t+2],3);
      } else {
        translate([72,-10,tray_z]) rb([44,18,tray_t+2],3);
        translate([fan_tray_w-116,-10,tray_z]) rb([44,18,tray_t+2],3);
      }

      // small pads where rails/lip/keeper screw into the tray
      for (x=[10,fan_tray_w-10]) for (gy=[32,fan_tray_d-32]){
        yy = gy-y0;
        if (yy>=8 && yy<=half_d-8) translate([x-8,yy-8,tray_z]) rb([16,16,tray_t+2],3);
      }
      for (x=[50,fan_tray_w-50]) for (gy=[14,fan_tray_d-14]){
        yy = gy-y0;
        if (yy>=8 && yy<=half_d-8) translate([x-8,yy-8,tray_z]) rb([16,16,tray_t+2],3);
      }
    }

    // main underside/through airflow opening
    translate([fan_tray_w/2,fan_tray_d/2-y0,tray_z-1]) cylinder(h=tray_t+10,d=fan_opening);

    // fan mount holes
    for (spacing=fan_mount_patterns) for (sx=[-spacing/2,spacing/2]) for (sy=[-spacing/2,spacing/2]){
      yy = fan_tray_d/2 + sy - y0;
      if (yy>=-2 && yy<=half_d+2) translate([fan_tray_w/2+sx,yy,tray_z-1]) hole(tray_t+12,fan_mount_d);
    }

    // half join holes
    if(front) for(x=[40,fan_tray_w-40]) translate([x,half_d+1,tray_z-1]) hole(tray_t+10,3.4);
    else for(x=[94,fan_tray_w-94]) translate([x,-1,tray_z-1]) hole(tray_t+10,3.4);

    // rail/lip/keeper attachment holes
    for (x=[10,fan_tray_w-10]) for (gy=[32,fan_tray_d-32]){
      yy=gy-y0; if(yy>=-2 && yy<=half_d+2) translate([x,yy,tray_z-1]) hole(tray_t+12,3.4);
    }
    for (x=[50,fan_tray_w-50]) for (gy=[14,fan_tray_d-14]){
      yy=gy-y0; if(yy>=-2 && yy<=half_d+2) translate([x,yy,tray_z-1]) hole(tray_t+12,3.4);
    }
  }
}
module fan_tray_front(){ fan_tray_half(true); }
module fan_tray_rear(){ fan_tray_half(false); }
module fan_tray_assembled(){ translate([tray_x,0,0]) fan_tray_front(); translate([tray_x,fan_tray_d/2,0]) fan_tray_rear(); }

// ---------------- Rails ----------------
module side_rail(left=true){
  x = left ? heatsink_x-rail_w-clearance : heatsink_x+heatsink_w+clearance;
  tab_x = left ? x : tray_x+fan_tray_w-22;
  tab_w = left ? tray_x+22-x : x+rail_w-(tray_x+fan_tray_w-22);
  hole_x = left ? tray_x+10 : tray_x+fan_tray_w-10;
  difference(){
    union(){
      // vertical rail locates the heatsink edge
      translate([x,heatsink_y-8,0]) rb([rail_w,heatsink_d+16,heatsink_bottom_z+heatsink_h-3],3);

      // underside shelf supports aluminium edge only; top face stays clear
      translate([left ? heatsink_x-2 : heatsink_x+heatsink_w-4, heatsink_y-2, heatsink_bottom_z-3]) cube([6,heatsink_d+4,5]);

      // outrigger tabs attach rails to fan tray, making the assembly one piece
      for (gy=[32,fan_tray_d-32]) translate([tab_x,gy-11,0]) rb([tab_w,22,tray_z+tray_t],3);
    }

    // rail lightening/air windows
    translate([x-1,heatsink_y+18,fan_top_z-4]) cube([rail_w+2,34,24]);
    translate([x-1,heatsink_y+88,fan_top_z-4]) cube([rail_w+2,34,24]);

    // tray attachment holes, vertical M3/zip-tie clearance
    for (gy=[32,fan_tray_d-32]) translate([hole_x,gy,-1]) hole(tray_z+tray_t+4,3.4);
  }
}

module support_posts(){
  post_h = heatsink_bottom_z - (tray_z+tray_t);
  for (x=[heatsink_x+18,heatsink_x+heatsink_w-30]) for (y=[heatsink_y+12,heatsink_y+heatsink_d-24])
    translate([x,y,tray_z+tray_t]) rb([12,12,post_h],3);
}

// ---------------- Front/rear keepers ----------------
module front_lip(){
  lip_w=216; lip_x=(stand_w-lip_w)/2;
  difference(){
    union(){
      // two risers bolt to fan tray; upper catch stops the Surface sliding
      for (x=[lip_x+50,lip_x+lip_w-50]) translate([x-7,6,0]) rb([14,16,contact_z+10],3);
      translate([lip_x,heatsink_y-10,contact_z-3]) rb([lip_w,10,15],3);
      translate([lip_x+28,heatsink_y-18,contact_z-3]) rb([lip_w-56,12,8],3);
    }
    translate([lip_x+70,heatsink_y-20,contact_z-5]) cube([76,24,22]);
    for (x=[lip_x+50,lip_x+lip_w-50]) translate([x,14,-1]) hole(tray_z+tray_t+4,3.4);
  }
}

module rear_keeper(){
  k_w=216; k_x=(stand_w-k_w)/2;
  difference(){
    union(){
      for (x=[k_x+50,k_x+k_w-50]) translate([x-7,stand_d-22,0]) rb([14,16,heatsink_bottom_z+16],3);
      translate([k_x,heatsink_y+heatsink_d+2,heatsink_bottom_z+2]) rb([k_w,9,12],3);
    }
    for (x=[k_x+50,k_x+k_w-50]) translate([x,stand_d-14,-1]) hole(tray_z+tray_t+4,3.4);
  }
}

module printable_frame(){
  color("#22272e") fan_tray_assembled();
  color("#30343b") side_rail(true);
  color("#30343b") side_rail(false);
  color("#30343b") support_posts();
  color("#30343b") front_lip();
  color("#30343b") rear_keeper();
}
module assembly(){ printable_frame(); heatsink_reference(); fan_reference(); surface_reference(); }

if(PART=="assembly") assembly();
else if(PART=="printable_frame") printable_frame();
else if(PART=="left_rail") side_rail(true);
else if(PART=="right_rail") side_rail(false);
else if(PART=="fan_tray_front") fan_tray_front();
else if(PART=="fan_tray_rear") fan_tray_rear();
else if(PART=="front_lip") front_lip();
else if(PART=="rear_keeper") rear_keeper();
else if(PART=="heatsink_reference") heatsink_reference();
else if(PART=="fan_reference") fan_reference();
else surface_reference();
