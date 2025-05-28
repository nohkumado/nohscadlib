siz = [50,30,10];
d = 8;
hollow_border = 2;
//fillet(r=3, h=2, center = true, offs=5);
//fillet2D(r=3, h=2, center = true, offs=5);
rounded_cube(d=8, siz = [50,30,10], hollow_border=2 );
rounded_cube(d=8, siz = [40,20,5] );
//rounded_square(d=8, siz = [50,30,10], hollow_border=2 );
//rounded_square(d=8, siz = [40,20,5] );
//translate([0,0,10])
//    if(hollow_border != 0) rounded_cube(d=d, siz = [siz[0]-hollow_border,siz[1]-hollow_border,siz[2]-hollow_border]);
//rounded_cube(d=8, siz = [50,30,10] );
module fillet(r, h, center = true, offs=0) 
{
  disp = (center)?r/2:0;

  translate([disp, disp, 0])

    difference() 
    {
      translate([-offs/2,-offs/2,0])
      cube([r + 0.01+offs, r + 0.01+offs, h], center = true);

      translate([r/2, r/2, -0.01])
        cylinder(r = r, h = h + 2, center = true, $fn=100);

    }
}

module rounded_cube(d=20, siz = [1,1,1], hollow_border = 0)
{
  linear_extrude(height=siz[2])
rounded_square(d=d, siz = siz, hollow_border=hollow_border );
}

module rounded_square(d=20, siz = [1,1,1], hollow_border = 0)
{
  difference()
  {
    square([siz[0],siz[1]], center = true);
    union()
    {
    if(hollow_border != 0) rounded_square(d=d, siz = [siz[0]-hollow_border,siz[1]-hollow_border,siz[2]+hollow_border]);
      for(n=[0:3]) 
        translate([((n%3 == 0)? -1:1)*siz[0]/2,((n >1)? 1:-1)*siz[1]/2,0]) rotate([0,0,n*90])fillet2D(r=d/2, h=1.5*siz[2], center = true, offs=1);
    }
  }
}

module fillet2D(r, h, center = true, offs=0, fn=40) 
{
  disp = (center)?r/2:0;
  translate([disp, disp, 0])
    difference() {
      translate([-offs/2,-offs/2,0])
      square([r + 0.01+offs, r + 0.01+offs], center = true);

      translate([r/2, r/2, -0.01])
        circle(r = r, $fn=fn);
    }
}
