/**
  * round up for start point pt, around rad = radius turn right or left, starting from angle lalpha0 = a0 to alpha1
  */
function roundPoint2D(pt,rad, res = 3,left = false,a0 = 0, a1 = 180) =
  [
  let (dw = a1-a0, step = (a1 - a0)/(res-1))
  for(w = [((left)? a1:a0):((left)? -1:1)*step:((left)? a0:a1)])
  [pt[0]+rad*sin(w), pt[1]+rad*cos(w)]
  ];
