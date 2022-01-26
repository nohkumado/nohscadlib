//fillet(r=3, h=2, center = true, offs=5);
rounded_cube(d=8, siz = [50,30,10] );
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

module rounded_cube(d=20, siz = [1,1,1])
{
  difference()
  {
    cube(siz, center = true);
  for(n=[0:3]) 
    translate([((n%3 == 0)? -1:1)*siz[0]/2,((n >1)? 1:-1)*siz[1]/2,0]) rotate([0,0,n*90])fillet(r=d/2, h=1.5*siz[2], center = true, offs=1);
  }
}

module fillet2D(r, h, center = true) 
{
  translate([disp, disp, 0])

    difference() {
      square([r + 0.01, r + 0.01], center = true);

      translate([r/2, r/2, 0])
        circle(r = r, $fn=100);

    }
}
