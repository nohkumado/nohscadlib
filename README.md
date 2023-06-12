# nohscadlib

some common and recurrent functions i need with my openscad project


- fillet.scad : to add or create round corners or progressive junctions
- round.scad: when working with polygons add a configurable number of intermediary points to round up a corner:
    + function roundPoint2D draws a round polygon around a point
    + function outerTangente compute the outer tangents of 2 circles
    + function innerTangente compute inner tangent of 2 circles
    + function normWinkel modulo the angle
    + function  hs\_euklid compute the euklidian height 
    + function grade\_kreis\_schnitt to compute the crossings of a line and a circle
- support.scad: add manually supports, when printing without support but still at some points some are needed
    + module picot draw a diamond shape
    + module  picot\_cube draw a raster of pico
- sweep.scad: create from a vector of cuts a solid by adding planes around the cuts
