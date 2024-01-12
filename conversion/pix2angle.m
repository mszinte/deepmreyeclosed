function ang = pix2angle(scr,pix)
%angle = pix2angle(display,pix)
%
%converts monitor pixels into degrees of visual angle.
%
%Inputs:
%display.dist (distance from screen (cm))
%display.width (width of screen (cm))
%display.resolution (number of pixels of display in horizontal direction)

%
%ang (visual angle)
%
%Warning: assumes isotropic (square) pixels

%Written 11/1/07 gmb zre

%Calculate pixel size
pixSize = scr.disp_sizeX/scr.scr_sizeX;   %cm/pix

sz = pix*pixSize;  %cm (duh)

ang = 2*180*atan(sz/(2*scr.dist))/pi;


return

