hohlzylinder(hoehe=50, untenr=5, obenr= 15,wd= 2,fn = 6, off=[[0,0], [0,0]]);


function kreisPkt(r, fn, n) = [r* cos(n*360/fn),r* sin(n*360/fn)];
function kreisListe(r, fn) = [for(n = [0:fn-1]) kreisPkt(r,fn,n)];
function ringListe(r, fn, wd) = [for(n = [0:fn]) kreisPkt(r,fn,n),for(n = [fn:-1:0]) kreisPkt(r-wd,fn,n)];



function kreisPkt3D(r, fn, n,z=0, xoff=0, yoff=0) = [r* cos(n*360/fn)+xoff,r* sin(n*360/fn)+yoff,z];
  
function ringListe3D(r, fn, wd,z, xoff=0, yoff=0) = [
  for(n = [0:fn-1]) kreisPkt3D(r,fn,n,z,xoff,yoff),
  for(n = [fn-1:-1:0]) let (thick = (is_list(wd)?(n < len(wd))?wd[n]:wd[len[wd]-1]:wd)) kreisPkt3D(r-thick,fn,n,z,xoff,yoff)];


function to2D(vals)=[
  for(p=vals) [p[0],p[1]]
];
module hohlzylinder(hoehe = 50, untenr = 20, obenr= -1,wd= 2, fn = 8, off=[[0,0], [0,0]])
{

  roben = (obenr >0)? obenr:untenr+wd;
  punkte = [
    each(ringListe3D(r=untenr, fn=fn, wd=wd, z=0, xoff=off[0][0], yoff=off[0][1])),
    each(ringListe3D(r=roben, fn=fn, wd=wd, z=hoehe, xoff=off[1][0], yoff=off[1][1]))
  ];
  flaechen = [

    for(n=[0:fn-1]) let(n1 = n+0+2*fn, n2= n+1+2*fn)[n,n1, (n2>= 3*fn)? n2-fn:n2,(n+1)%fn],//seiten
    for(n=[fn:2*fn-1]) let(n1 = (n+1>=2*fn)?n+1-fn: n+1, n2= 3*fn+n%fn+1, n3=n2-1)[(n3 <3*fn)?n3+fn-1:n3,(n2>= 4*fn)? n2-fn:n2,n1,n],//seiten
    for(n=[0:fn-1]) let(n2=2*fn-1-n, n3= n2+1, res= [n,(n+1)%fn,(n2>=2*fn)?n2-fn:n2,(n3>=2*fn)?n3-fn:n3])res,//stirnseiten
    for(n=[2*fn:3*fn-1]) let(n2=4*fn-1-n%fn, n3= n2+1, res= [(n3>=4*fn)?n3-fn:n3,n2,(n+1 >=3*fn)?n+1 -fn:n+1,n])res,//stirnseiten

    ];

  polyhedron(points=punkte, faces=flaechen);

}
