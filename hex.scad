height = 200;
width = 200;
holes = 10;
spacing =3;
angle = 10;
wall_thickness = 30;
point_up = true;


hexwand(width = width,  h=height, num_holes=holes, angle=angle, w= wall_thickness, spacing = spacing, point_up = point_up );

module hexwand(width = 10, h=10, w=2, num_holes= 5, angle=0, spacing = 1, point_up=false, center= false)
{
  ver_sh = (num_holes >0)?h:h-2*w;
  ver_sp = h+3*w;
  d_ver = 2*w*tan(30);

  wand_poly_points = [
    [0,0,0], [0,width,0], [w,width,0], [w,0,0], //Grund fläche 0 1 2 3

    [ver_sh*sin(angle),-ver_sh*sin(angle),ver_sh], //Start verjüngung 4
    [ver_sh*sin(angle),width+ver_sh*sin(angle),ver_sh],  // 5
    [w+ver_sh*sin(angle),width+ver_sh*sin(angle),ver_sh], /// 6
    [w+ver_sh*sin(angle),-ver_sh*sin(angle),ver_sh], //Ende verjüngung 7 

    if(num_holes <=0)[h*sin(angle),-h*sin(angle),h], //wandhöhe 8
    if(num_holes <=0)[h*sin(angle),width+h*sin(angle),h],  // 9
    if(num_holes <=0)[w+h*sin(angle),width+h*sin(angle),h],  // 12
    if(num_holes <=0)[w+h*sin(angle),-h*sin(angle),h], //wandhöhe 13
    if(num_holes <=0)[w+h*sin(angle)+d_ver,width+h*sin(angle),h],  //10
    if(num_holes <=0)[w+h*sin(angle)+d_ver,-h*sin(angle),h], //11

    if(num_holes <=0)[w+ver_sp*sin(angle),-ver_sp*sin(angle),ver_sp], 
    if(num_holes <=0)[w+ver_sp*sin(angle),width+ver_sp*sin(angle),ver_sp], 
    if(num_holes <=0)[2*w+ver_sp*sin(angle),width+ver_sp*sin(angle),ver_sp], 
    if(num_holes <=0)[2*w+ver_sp*sin(angle),-ver_sp*sin(angle),ver_sp], //Start verjüngung 
    ];

  wand_poly_faces = [
    [0,3,2,1], //Grundfläche
    [0,1,5,4], //front
    [1,2,6,5],  //Seite rechts
    [2,3,7,6], //hinten
    [3,0,4,7],  //Seite links
		//-------------  wandhöhe
    if(num_holes <=0) [4,5,9,8], //front
				 //[5,6,10,9],  //Seite rechts komplett
    if(num_holes <=0)[5,6,12,10],  //Seite rechts
    if(num_holes <=0)[5,10,9],  //Seite rechts
    if(num_holes <=0)[6,7,13,12], //hinten
    if(num_holes <=0)//[7,4,8,11],  //Seite links komplett
      if(num_holes <=0)[7,4,11,13],  //Seite links
    if(num_holes <=0)[4,8,11],  //Seite links dreieck
    (num_holes <=0)?[8,9,10,11]:[4,5,6,7], //Abschluss Wandhöhe
					   //[8,9,10,11], //Abschluss Wandhöhe
					   //-------------  Überlaufhöhe
    if(num_holes <=0)[11,10,15,14], //front
    if(num_holes <=0)[10,12,16,15],  //Seite rechts
    if(num_holes <=0)[12,13,17,16], //hinten
    if(num_holes <=0)[11,14,17,13],  //Seite links
    if(num_holes <=0)[14,15,16,17], //Abschluss Überlaufhöhe
    ];
  difference()
  {
    translate([0,center?-0.5*width:0,0])
      polyhedron(points=wand_poly_points, faces=wand_poly_faces);
    if(num_holes >0)
   {
     rotate([0,angle,0])
       rotate([90,0,90])
       linear_extrude(height = 3*w, center = true)
       hexagon_pattern(width = width, height = h, num_cols = num_holes, spacing = spacing, point_up = point_up);
   }
 }

}

  function hexagon_points(radius = 1, point_up = true, z= -1, pos = [0,1,2], xoff = 0, yoff=0, center = [true,true,true], half = 0)= 
  let(
      angles = [ for (i = [0:5]) (i * 60 + (point_up ? 30 : 0)) ], 
      xoff=xoff+(center[0]?0:point_up?(half==1? 0:radius*cos(30)):radius),  
      yoff = yoff+ (center[1]?0:point_up?radius:(half==1?0:radius*cos(30))) )
  [
  for (w = angles)
  let(
      rawx=radius * cos(w),rawy=radius * sin(w), 
      x = point_up? (half == -1?(rawx <=0?rawx:0) : half == 1?(rawx >=0?rawx:0):rawx):rawx ,
      y = point_up? rawy : (half == -1?(rawy <=0?rawy:0) : half == 1?(rawy >=0?rawy:0):rawy),
      result = [x+xoff, y+yoff, if(z>=0) z]
     ) 
  [
    pos[0]== 0?result.x:pos[0]== 1?result.y:result.z,
    pos[1]== 0?result.x:pos[1]== 1?result.y:result.z,
    if(z >=0) pos[2]== 0?result.x:pos[2]== 1?result.y:result.z,
  ]
  ];



  module hexagon(radius = 1, point_up = true, center = [true,true,true], xoff = 0, yoff=0, half=0) {
    angles = [
      for (i = [0:5]) (i * 60 + (point_up ? 30 : 0))
    ];
    points = hexagon_points(radius = radius, point_up = point_up, center = center, xoff=xoff, yoff=yoff, half=half);
    polygon(points = points);
  }


module hexagon_pattern(width = 10, height = 10, num_cols = 5, spacing = 1, point_up = false) 
{
  radius = point_up? (width-(num_cols+1)*spacing)/(2*num_cols*cos(30)):   (width-(num_cols+1)*spacing)/(2+(num_cols-1)*(1+sin(30)));
  hexr = radius*cos(30);
  //assert(point_up?(2*hexr+spacing)*num_cols < width:(2*radius+spacing)*num_cols < width);

  num_rows = point_up? (height+spacing) / (3 * radius/2 + spacing)
    :2*floor((height / (2 * radius * cos(30) + spacing))/2)+1;

  hexgrid_width = let( pairs = floor(num_cols/2), impairs = num_cols - 2*pairs, hexcount = 2*pairs+1*impairs)
    point_up?  num_cols*(2*hexr+spacing)-spacing
    :
    pairs*(3*radius+2*spacing)+ impairs*radius+spacing ;

  xoff = point_up?((width-hexgrid_width)/2): (width-hexgrid_width)/2;

  for (row = [0:num_rows - 1]) {
    let (oddrow = row % 2 == 1)
      for (col = [0:point_up?(oddrow? num_cols:num_cols - 1): num_cols - 1]) {
	oddcol = col % 2 == 1;
	yoff = point_up? 0
	  :(oddcol?radius * cos(30):0 );
	xpos = point_up? 
	  oddrow?col *( 2*hexr + spacing)-( hexr)
	  :col *(2*hexr + spacing)
	  :oddcol?col *( radius+radius*sin(30) + 1*spacing):col/2 *(3*radius+2*spacing);
	x = point_up?
	  (oddrow? xpos+xoff-spacing/2:xpos+xoff)
	  :xpos+xoff;
	y = point_up?row * (radius*3/2+spacing )+yoff:row * (2 * hexr+spacing )+ yoff;

	difference()
	{
	  translate([point_up?((oddrow && col == 0)?(hexr+x):x):x, y, 0])
	    color(oddrow?"red":oddcol?"blue":"yellow")
	    hexagon(radius= radius, point_up = point_up, center = [false,false,true], half=point_up?((oddrow && col == 0)?1:(oddrow && col == num_cols )?-1:0): (y+2*radius>height)?-1:0  );
	  union()
	  {
	    if(x<0)translate( [-radius+spacing,y-1,0]) square([radius,2*radius+2]);
	    if(x+hexr>width-spacing)translate( [width-spacing,y-1,0]) square([10*radius,2*radius+2]);
	  }
	}
      }
  }
}

