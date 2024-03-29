//sweep example
flaechen =
[
  [
    [-2,-2,-20],
    [2,-2,-20],
    [2,2,-20],
    [-2,2,-20],
  ],
  [
    [-10,-10,-10],
    [10,-10,-10],
    [10,10,-10],
    [-10,10,-10],
  ],
  [
    [-5,-5,0],
    [5,-5,0],
    [5,5,0],
    [-5,5,0],
  ],
  [
    [-10,-10,10],
    [10,-10,10],
    [10,10,10],
    [-10,10,10],
  ],
  [
    [-1,-1,20],
    [1,-1,20],
    [1,1,20],
    [-1,1,20],
  ],
  ];
//echo(to2D(flaechen[1]));
//echo("flatten ",flatten(flaechen));
//echo("len",len(flaechen));
///echo("flaechen",flaechen(flaechen));
//color("green") translate([0,0,-10])polygon(to2D(flaechen[0]));
//color("green") translate([0,0,10])polygon(to2D(flaechen[1]));
//polyhedron(flatten(flaechen),flaechen(flaechen));

difference()
{
  sweep(flaechen,true);
  translate([25,0,0]) rotate([45,0,0]) cube([50,50,50], center = true);
}


//start of lib
//determine max values in array
function max3D(arr, pos=0, res)= 
  let( 
      res=is_undef(res)? [0,0,0]:res
     ) 
  pos == len(arr)-1? res: 
  pos ==0? max3D(arr=arr,pos=pos+1,res): 
let(
    x=res[0]>arr[pos][0]?res[0]:arr[pos][0],
    y=res[1]>arr[pos][1]?res[1]:arr[pos][1],
    z=res[2]>arr[pos][2]?res[2]:arr[pos][2]
   )
  max3D(arr=arr,pos=pos+1,[x,y,z]);
//determine min values in array
function min3D(arr, pos=0, res)= 
  let( 
      res=is_undef(res)? [100000,100000,100000]:res
     ) 
  pos == len(arr)-1? res: 
  pos ==0? min3D(arr=arr,pos=pos+1,res): 
let(
    x=res[0]<arr[pos][0]?res[0]:arr[pos][0],
    y=res[1]<arr[pos][1]?res[1]:arr[pos][1],
    z=res[2]<arr[pos][2]?res[2]:arr[pos][2]
   )
  min3D(arr=arr,pos=pos+1,[x,y,z]);
//remove the z component
function to2D(vector) = [for(line = vector) [line[0],line[1]]];
//up all elements one step
function flatten(vector) = [for(line = vector) each(line)];
function flaechen(vector, closed = true) = 
let(breite = len(vector[0]), laenge = len(vector)-1) 
  [
if(closed)[ for( l = [0: breite-1]) l, ],
  for(i = [0: len(vector)-2]) 
for(n = [0: breite-1]) 
  [
    i*breite+n,
    i*breite+n+breite,
    (n+1 < breite)? i*breite+n+breite+1:i*breite+1+n, 
    (n+1 < breite)? i*breite+n+1:i*breite+1+n-breite
    //i*breite+n,
    //(i+1)*breite+n,
    //(n+1 < breite)? (i+1)*breite+1+n:i*breite+1+n, 
    //(n+1 < breite)?(i*breite)+1+n:(i*breite)+1+n-breite
    ],
    if(closed)[ for( l = [laenge*breite+breite-1: -1:laenge*breite]) l, ],
    ];
//circle function
function f(w,r) =  [r*sin(w), r*cos(w)];
function circleFunc(w,r) =  [r*cos(w), r*sin(w)];
//absoulte difference
function absdiff(p1,p2) =  p1>p2? abs(p1 - p2): abs(p2 - p1);
function applyFunc( rad=5, prec=.01, sw=0, ew=90,step = 3, prec=.01, list ) =
let( list = is_undef(list) ? [f(sw,r=rad)] : list,
    fi=f(sw,rad),
    pointdiff = absdiff(fi[1],list[len(list)-1][1])
   )
  //echo("sw = ",sw ,ew," diff:",pointdiff,prec,fi)
  (sw >= ew )? let(fi=f(ew,rad))[for(i=[0:len(list)-2]) if(absdiff(fi[1],list[i][1])> prec)list[i], fi] : 

  pointdiff >prec?
  applyFunc( rad=rad, prec=prec, sw=sw+step,ew=ew,step=step, list=[ each list, fi ] ):
  applyFunc( rad=rad, prec=prec, sw=sw+step,ew=ew,step=step, list=list );

function xaufrunden(toround, r, fn, sw, ew, prec=.1)= 
  let(
      fi=f(w=sw, r=r),
      zoff=fi[1] == 0? f(w=ew, r=r)[1]:fi[1],
      //xoff=toround[0]-(fi[0] == 0? f(w=ew, r=r)[0]:fi[0]),
      xoff=f(w=ew, r=r)[0] != 0?f(w=ew, r=r)[0]: f(w=sw, r=r)[0] ,
      //zoff = (len(toround) == 3)? (toround[2]<0)? vzoff: vzoff :-vzoff, 
      step = (ew-sw)/fn,
      pos= applyFunc( rad=r, sw=sw, ew=ew,step = step, prec=prec)
  )
  //echo("to round: ",toround, len(toround), " zoff:",zoff, " x",xoff)
  [for(apos = pos) len(toround) == 1?[toround[0]-apos[0]]:
  len(toround) == 2?[toround[0]-apos[0],apos[1]+toround[1]-zoff]:
  [apos[0]+toround[0]-xoff ,toround[1],toround[2]+apos[1]-zoff]
  ] ;
function invertDirection(vector)=[for (n=[len(vector)-1:-1:0])vector[n]];

module sweep(slices, closed = false)
{
  polyhedron(flatten(slices),flaechen(slices, closed));
}

