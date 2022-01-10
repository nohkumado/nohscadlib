fillet(r=3, h=2, center = true, offs=5);
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

module fillet2D(r, h, center = true) 
{
  translate([disp, disp, 0])

    difference() {
      square([r + 0.01, r + 0.01], center = true);

      translate([r/2, r/2, 0])
        circle(r = r, $fn=100);

    }
}
