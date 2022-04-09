case = 4;
resolution = 30;
centered = true;
  poly=[
//round upside out 0
    [
    each(roundPoint2D(pt=[0,10],rad=10, res = resolution,left = true,a0 = -90, a1 = 90, center = centered)), 
    [-10,0],
    [10,0],
    ],
//round upside in 1
    [
    each(roundPoint2D(pt=[0,10],rad=5, res = resolution,left = false,a0 = 90, a1 = 270, center = centered)), 
    [-10,0],
    [10,0],
    ],
//round left out 2
    [
    each(roundPoint2D(pt=[-10,00],rad=5, res = resolution,left = false,a0 = 180, a1 = 360, center = centered)), 
    [0,0],
    ],
//round left in 3
    [
    each(roundPoint2D(pt=[-10,02],rad=5, res = resolution,left = false,a0 = 0, a1 = 180, center = centered)), 
    [0,-10],
    [0,10],
    ],
//round right out 4
    [
    each(roundPoint2D(pt=[10,00],rad=5, res = resolution,left = false,a0 = 0, a1 = 180, center = centered)), 
    [0,0],
    ],
    ];
echo("printing ",poly[case]);
    color("red")
    polygon(poly[case]);

    point = poly[case][resolution];
    a1 = 90;
    a0 = -90;
    rad = 10;
    halw = (a0+a1)/2;
  //zentrum = [point[0]+rad*sin(halw), point[1]+rad*cos(halw)];
  //echo("zentrum = ",zentrum,sin(a1),sin(a0));
/**
  * round up for start point pt, around rad = radius turn right or left, starting from angle lalpha0 = a0 to alpha1
  * default turn direction is clockwise, starting at vertical up (90°)
  */
function roundPoint2D(pt,rad, res = 3,left = false,a0 = 0, a1 = 180, center = false, min=[-1000,-1000]) =
  [
  let (dw = a1-a0,halw = (a0+a1)/2, qx = (pt[0]<0)?-1:1, qy = (pt[0]<0)?-1:1,step = (a1 - a0)/(res-1),zentrum = (center)?[pt[0]-rad*sin(halw), pt[1]-rad*cos(halw)]:pt)
  for(w = [((left)? a1:a0):((left)? -1:1)*step:((left)? a0:a1)])
  if(len(min) == 2 &&(zentrum[0]+rad*sin(w) >min[0] && zentrum[1]+rad*cos(w)>min[1]))[zentrum[0]+rad*sin(w), zentrum[1]+rad*cos(w)]
  ];
