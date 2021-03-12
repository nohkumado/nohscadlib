module fillet(r, h, center = true) 
{
  disp = (center)?r/2:0;

  translate([disp, disp, 0])

    difference() 
    {
      cube([r + 0.01, r + 0.01, h], center = true);

      translate([r/2, r/2, 0])
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
