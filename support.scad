module picot(h = 2, r = 1, res= .2, double=true)
{
  difference()
  {
    union()
    {
      cylinder(d1=r, d2=(double)?res:r,h=h/2, $fn=3);
      translate([0,0,-h/2-0.01]) cylinder(d1=res, d2=r,h=h/2, $fn=3);
    }
    union()
    {
      translate([0,0,4*res])
	cylinder(d1=r-4*res, d2=(double)?res:r-4*res,h=h/2-4*res, $fn=3);
      translate([0,0,-h/2-4*res-0.01]) cylinder(d1=res, d2=r-4*res,h=h/2-4*res, $fn=3);
    }
  }
}

module picot_cube(x = 10, y= 10,h = 2, r = 1, res= .2, sp=[5,4])
{
  color("blue")
    translate([0,.2,0]) cube([.8*x,.4,.8*y], center = true);
  for(dy=[-.4*y+r/4:y/sp[1]:.4*y-r/4])
  {
    for(dx=[-.4*x+r/2:x/sp[0]:0])
    {
      color("blue")
        translate([dx,h/2,dy])
        rotate([90,0,0])
        picot(h = h, r = r, res= res, double=false);
      color("blue")
        translate([x/2+dx,h/2,dy])
        rotate([90,0,0])
        picot(h = h, r = r, res= res, double=false);
    }
  }
}
