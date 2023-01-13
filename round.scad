case = 4;
resolution = 30;
centered = true;
UPOUT = 0; UPIN = 1; LEOUT = 2; LEIN = 3; REOUT = 4; REIN = 5; DOOUT = 6; DOIN = 7;
//   poly=[
// //round upside out 0
//     [
//     each(roundPoint2D(pt=[0,10],rad=10, res = resolution,left = true,a0 = -90, a1 = 90, center = centered)), 
//     [-10,0],
//     [10,0],
//     ],
// //round upside in 1
//     [
//     each(roundPoint2D(pt=[0,10],rad=5, res = resolution,left = false,a0 = 90, a1 = 270, center = centered)), 
//     [-10,0],
//     [10,0],
//     ],
// //round left out 2
//     [
//     each(roundPoint2D(pt=[-10,00],rad=5, res = resolution,left = false,a0 = 180, a1 = 360, center = centered)), 
//     [0,0],
//     ],
// //round left in 3
//     [
//     each(roundPoint2D(pt=[-10,02],rad=5, res = resolution,left = false,a0 = 0, a1 = 180, center = centered)), 
//     [0,-10],
//     [0,10],
//     ],
// //round right out 4
//     [
//     each(roundPoint2D(pt=[10,00],rad=5, res = resolution,left = false,a0 = -90, a1 = 180, center = centered)), 
//     [0,0],
//     ],
//     ];
//Test cases
//echo("printing ",poly[case]);
//    color("red")
//    polygon(poly[case]);


//example on how to use the iner tangent angle to connect 2 circles
cll = innerTangente(c1 = [0,0], r1=10, c2=[30,0], r2=5);
circleround = [
  //[0,0],
  //each(roundPoint2D(pt=[20,20],rad=10, res = 160,left = false,a0 = 0, a1 = 90, center = true)), 
  each(roundPoint2D(pt=[-20,20],rad=10, res = 160,left = false,a0 = -90-cll[3], a1 = 90-cll[3], center = true)), 
  each(roundPoint2D(pt=[30,-5],rad=5, res = 160,left = false,a0 = 90-cll[3], a1 = 270-cll[3], center = false)), 
  //[-10,0],
  //[10,0],
  ];
  color("red")
  polygon(circleround);
  translate([0,0,-1])square(40, center = true);




  echo("w: ", normWinkel(w=490));

  echo("höhensatz: ^: 1", hs_euklid(mode = "hp", h=70.12, p= 1.1));
  k1=  [0,0,10];
  k2=  [-30,-10,5];
  ot = outerTangente(c1 = [k1[0],k1[1]], r1=k1[2], c2=[k2[0],k2[1]], r2=k2[2]);
  echo("Äussere Tangent: :k1", ot);
  cube([100,1,5], center = true);  //xachse
  cube([1,100,5], center = true);  //yachse
  translate([k1[0],k1[1],0]) circle(r=k1[2]);
  translate([k2[0],k2[1],0]) circle(r=k2[2]);
  translate([k1[0],k1[1],0]) rotate([0,0,ot[3]])cube([ot[0],1,5], center = false);


  //point = poly[case][resolution];
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
    //let (dw = a1-a0,halw = (a0+a1)/2, qx = (pt[0]<0)?-1:1, qy = (pt[0]<0)?-1:1,step = (a1 - a0)/(res-1),zentrum = (center)?[pt[0]-rad*sin(halw), pt[1]-rad*cos(halw)]:pt)
let (
    dw = a1-a0,
    normDiff = (left==false)? (normWinkel(a1)-normWinkel(a0)):(normWinkel(a0)-normWinkel(a1)),
    normDw = (normDiff<0)? 360+normDiff:normDiff,
    halw = (a0+a1)/2, 
    qx = (pt[0]<0)?-1:1, 
    qy = (pt[0]<0)?-1:1,
    step = (a1 - a0)/(res-1),
    rg = rad/sin(45),
    effr = (normDw <=90)? rg: rad,
    zentrum = (center)?[pt[0]-effr*sin(halw), pt[1]-effr*cos(halw)]:pt,
    //echo("nomDW",normDw,"nD", normDiff,effr,zentrum, a0,a1,left)
  )
for(w = [((left)? a1:a0):((left)? -1:1)*step:((left)? a0:a1)])
  if(len(min) == 2 &&(zentrum[0]+rad*sin(w) >min[0] && zentrum[1]+rad*cos(w)>min[1]))[zentrum[0]+rad*sin(w), zentrum[1]+rad*cos(w)]
  ];

  /** 
    https://math.stackexchange.com/questions/719758/inner-tangent-between-two-circles-formula
    compute the outer tangent of 2 circles, so as to be able to know how to smooth out 2 concurrent curves
    c1 need ot be the bigger pone
    M1M2 distance of the centers
    delta the angle of the radius of circle 1to the tangent
    alpha 
    */
function outerTangente(c1 = [0,0], r1=10, c2=[20,20], r2=5) =
  let(
      M1M2= sqrt((c2[0]-c1[0])^2+(c2[1]-c1[1])^2), //distance between the circles, the hypotenuse
      phi =  acos((r1-r2)/M1M2), //angle between hypotenuse and inner circle in big circle radius
      beta =  atan((r1-r2)/M1M2), //angle between hypotenuse and tangent at small circle radius
      //theta = asin(c2[0]-c1[0]/M1M2), //angle between hypo and y axis,
      dx = c2[0]-c1[0], //delta x for quadrant computing,
      dy = c2[1]-c1[1], //delta y for quadrant computing,
      theta = atan(abs(c2[0]-c1[0])/abs(c2[1]-c1[1])), //angle between hypo and y axis,
      //thetap = acos(c2[1]-c1[1]/M1M2), //angle between hypo and y axis,
      alpha = (dx >=0  && dy  >= 0 )? 90-theta //first quadrant
             :(dx <0  && dy  >= 0 )?90+ theta //2. quadrant
             :(dx <0  && dy  < 0 )?270- theta //3. quadrant
             :270+theta                          //4. quadrant  
     )
  [
    M1M2, phi, beta,alpha
  ];
  /** 
    compute the inner tangent of 2 circles, so as to be able to know how to smooth out 2 concurrent curves
    M1M2 distance of the centers
    delta the angle of the radius of circle 1to the tangent
    alpha 
    */
function innerTangente(c1 = [0,0], r1=10, c2=[20,20], r2=5) =
  let(
      M1M2= sqrt((c2[0]-c1[0])^2+(c2[1]-c1[1])^2),
      delta = atan((c2[1]-c1[1])/(c2[0]-c1[0])),
      alpha = asin((r1+r2)/M1M2)
     )
  [
    M1M2, delta, alpha, 90-alpha
  ];

  /**
    convert the angle to somewhat usable
    */
function normWinkel(w=0)=
  let(topositiv = (w<0)? 360+(w%360): w%360) topositiv;

 /** 
   Höhensatz von  Euklid
   Halbsehne h = geometrisches mittel zwischen den Radiusabschnitten p und q = sqr(pq)
   h= halbe Sehne
   p radius zum Kreis
   q radius zum Zentrum
   r = p+q, kreisradius
   mode ["radius"]
   */
function  hs_euklid(mode = "radius",h=-1, p = -1, q = -1, r = -1)=
(mode == "radius")? p+q
:(mode == "hp")? p+h^2/p
:sqrt(p*q); //default return h
