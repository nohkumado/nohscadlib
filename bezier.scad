//example: drawBezier(starp = [0,0], endp = [50,0], start_angle = 30, end_angle = -10, start_weight = 20,    end_weight = 30, debug = true );
// Berechnet einen Punkt auf einer kubischen Bezier-Kurve
  function bezier_point(p0, p1, p2, p3, t) =
let (u = 1 - t)
  [ u*u*u*p0[0] + 3*u*u*t*p1[0] + 3*u*t*t*p2[0] + t*t*t*p3[0],
  u*u*u*p0[1] + 3*u*u*t*p1[1] + 3*u*t*t*p2[1] + t*t*t*p3[1] ];

// Wandelt 4 Punkte in eine Punktliste um (z. B. für polygon oder polyline)
function bezier_curve(p0, p1, p2, p3, steps=30) =
[ for (i = [0:steps]) bezier_point(p0, p1, p2, p3, i/steps) ];
//converts start point angle and rad to a 2D cartesian point, dir is true
//forward, false backward
function polar2point(origin = [0,0], angle = 10, length = 10, dir= true)= [origin[0] + ((dir)?1:-1)*length*cos(angle), origin[1] + ((dir)?1:-1)*length*sin(angle)];

//beware open curve!!
function bezier(
    starp = [0,0],
    endp = [50,30],
    start_angle = 30,     // Startwinkel in Grad
    end_angle = 200,    // Endwinkel in Grad
    start_weight = 20,         // Tangentenlänge am Start
    end_weight = 30,// Tangentenlänge am Ende
    fn = 30 //smoothness
    ) =
let(
    p1 = polar2point(starp,start_angle,start_weight),
    p2 = polar2point(endp,end_angle,end_weight, dir= false)
   ) bezier_curve(starp, p1, p2, endp, fn);

module drawBezier(
    starp = [0,0],
    endp = [50,30],
    start_angle = 30,     // Startwinkel in Grad
    end_angle = 200,    // Endwinkel in Grad
    start_weight = 20,         // Tangentenlänge am Start
    end_weight = 30,// Tangentenlänge am Ende
    fn = 30, //smoothness
    debug = false
    )
{ 
  echo("Endpoint = ",endp);

  p1 = polar2point(starp,start_angle,start_weight);
  p2 = polar2point(endp,end_angle,end_weight, dir= false);

  points = bezier(starp = starp, endp = endp, start_angle = start_angle, end_angle = end_angle, start_weight = start_weight,    end_weight = end_weight, fn=fn );

  if(debug)
  {
    color("red") translate([starp[0],starp[1],0])circle(2, $fa = .3, $fs=.3);
    color("blue") translate([endp[0],endp[1],0])circle(2, $fa = .3, $fs=.3);
    color("magenta") translate([p1[0],p1[1],0])circle(2, $fa = .3, $fs=.3);
    color("green") translate([p2[0],p2[1],0])circle(2, $fa = .3, $fs=.3);
    color("gray") polyline([starp,p1,p2,endp]);
  }
  //close first the bezier curve
  polygon(concat(points, [starp]));
}

module polyline(pts) {
  hull() { translate([pts[0][0],pts[0][1],0]) circle(d=0.6); translate([pts[1][0],pts[1][1],0]) circle(d=0.6); }
  hull() { 
    translate([pts[2][0],pts[2][1],0]) circle(d=0.6); 
    translate([pts[3][0],pts[3][1],0]) circle(d=0.6); 
  }
}
function reverse(list) = [for (i = [len(list)-1:-1:0]) list[i]];

