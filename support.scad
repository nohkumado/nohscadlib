module picot(h = 2, r = 1, res= .2)
{
  cylinder(d1=r, d2=res,h=h/2, $fn=3);
  translate([0,0,-h/2-0.01]) cylinder(d1=res, d2=r,h=h/2, $fn=3);
}
