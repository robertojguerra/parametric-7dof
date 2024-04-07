//6 DOF robot generator

//General parameters
$fn=24;
del=1; //small delta
hole=5; //hole diameter in mm
nut_d=10; //corner to corner nut diameter
nut_h=2; //nut thickness
thick=5; //part thickness

//Base params
base_width=50;

//Shoulder params
riser_offset=-10;
riser_space=5;
riser_diam=40;

//Arm params
arm_width=30;
arm_length=30;

//Forearm params
forearm_width=24;
forearm_length=20;

//Hand params
hand_width=20;
hand_length=30;

//Rotations
shoulder_yaw=360*$t; //Shoulder left to right rotation
arm_pitch=180*$t; //arm up down rotation
elbow_roll=90*$t;
forearm_pitch=90*$t;
wrist_roll=90*$t;
hand_pitch=90*$t;
finger_pitch=90*$t;


//Creating the robot arm
base(base_width,thick,1);

//Tests
//bracket(20,20,5,20,20,5);
//bracket(30,10,5,20,30,5);
//make_tombstone(30,10,5);
//make_tombstone(20,30,5);
//arm(30,100,1);

//Base
module base(base_w,base_h,child=0){
    difference(){
        translate([-base_w/2,-base_w/2,0]) cube([base_w,base_w,base_h]);{
            make_hole(hole,base_h);
            cylinder(nut_h,nut_d/2,nut_d/2,$fn=6);
            for(phi=[45,135,225,315])
                rotate([0,0,phi])
                translate([base_w/2*1.2,0,0])
                make_hole(hole,base_h);
        }
    }
    if(child){
        translate([0,0,thick])
        rotate([0,0,shoulder_yaw])
        shoulder(base_width,thick,riser_offset,riser_space,riser_diam,1);
    }
}

//Shoulder
module shoulder(base_w,base_h,riser_offset,riser_space,riser_diam,child=0)
{
    difference(){
        union(){
            cylinder(base_h,base_w/2,base_w/2);
            translate([0,0,base_h])
            rotate([90,0,0])
            translate([-riser_diam/2,0,-base_h/2+riser_offset]){
                cube([riser_diam,riser_diam/2+riser_space,base_h]);
                translate([riser_diam/2,riser_diam/2+riser_space,0])
                cylinder(base_h,riser_diam/2,riser_diam/2);
            }
        }
        union(){
            make_hole(hole,base_h);
            translate([0,0,base_h+riser_space+riser_diam/2]){
                rotate([90,0,0])
                make_hole(hole,riser_offset+base_h/2);
                rotate([-90,0,0])
                make_hole(hole,-riser_offset+base_h/2);
            }
        }
    }
    if(child){
        translate([0,-riser_offset-thick/2,thick+riser_space+riser_diam/2])
        rotate([90,0,0])
        rotate([0,0,arm_pitch])
        arm(arm_width,arm_length,1);
    }
}

module arm(width,length,child=0){
    bracket(width,length,thick,width,width/2,thick);
    if(child){
        translate([length+thick,0,width/2])
        rotate([0,90,0])
        rotate([0,0,elbow_roll])
        //cylinder(10,0,5);
        elbow(width,length,1);
    }
}

module elbow(width,length,child=0){
    bracket(width,width/2-thick,thick,width,length,thick);
    if(child){
        translate([width/2-thick,0,length])
        rotate([0,-90,0])
        rotate([0,0,forearm_pitch]) color("blue")
        //cylinder(10,0,5);
        forearm(forearm_width,forearm_length,1);
    }
}

module forearm(width,length,child=0){
    bracket(width,length,thick,width,width/2,thick);
    if(child){
        translate([length+thick,0,width/2])
        rotate([0,90,0])
        rotate([0,0,wrist_roll])
        //cylinder(10,0,5);
        wrist(width,length,1);
    }
}

module wrist(width,length,child=0){
    bracket(width,width/2-thick,thick,width,length,thick);
    if(child){
        translate([width/2-thick,0,length])
        rotate([0,-90,0]){
            //cylinder(10,0,5);
            rotate([0,0,hand_pitch])
            hand(hand_width,hand_length);
            translate([0,0,thick*2])
            rotate([180,0,0])
            rotate([0,0,finger_pitch])
            hand(hand_width,hand_length);
        }
    }
}

module hand(width,length){
    finger_start=width/2;
    finger_gap=(length-finger_start)/2;
    finger_tip=length-finger_start-finger_gap;
    difference(){
        make_tombstone(width,length,thick);
        union(){
            translate([  finger_start              ,-width/2-1    ,-1])
            cube([       finger_gap                ,width*0.75+1  ,thick+2]);
            translate([  finger_start+finger_gap-1 ,-width/2-1    ,-1])
            cube([       finger_tip+2              ,width/2+1     ,thick+2]);
        }
    }
}
module make_hole(w,h){
    translate([0,0,-del])
    cylinder(h+2*del,w/2,w/2);
}

module bracket(base_w,base_l,base_t,riser_w,riser_l,riser_t){
    make_tombstone(base_w,base_l+riser_t,base_t);
    translate([base_l,0,riser_l])
    rotate([0,90,0])
    make_tombstone(riser_w,riser_l,riser_t);
}

module make_tombstone(w,l,t){
    difference(){
        union(){
            cylinder(t,d=w);
            translate([0,-w/2,0])
            cube([l,w,t]);
        }
        union(){
            make_hole(hole,thick);
            translate([l,-w/2-1,-1]) cube([w-l,w+2,t+2]);
        }
    }
}