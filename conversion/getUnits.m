function [units] = getUnits(scr)
% Compute a few useful units based on your screen settings 
% MN, September 2021

units.ScrDiag_px   =   sqrt(scr.scr_sizeX^2 + scr.scr_sizeY^2); % screen diagonal in pixel
units.ScrDiag_cm   =   sqrt((scr.disp_sizeX/10)^2) + ((scr.disp_sizeY/10)^2); % screen diagonal in cm
units.pxPcm        =   units.ScrDiag_px/units.ScrDiag_cm; % pixel per cm
units.pxPdeg       =   (scr.dist*tand(1))*units.pxPcm; % pixel per degree
fprintf('pixel per degree %i', units.pxPdeg);

% add your favorite units here
end