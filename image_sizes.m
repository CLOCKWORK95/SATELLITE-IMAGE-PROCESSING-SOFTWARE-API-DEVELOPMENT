function [ width, height, area ] = image_sizes(image, sensor)
%IMAGE_SIZES Summary of this function goes here
%   Detailed explanation goes here

LANDSAT_TM = 0;
SPOT_PANCHROMATIC = 1;

dim = size( image );
rows = dim(1);  cols = dim(2);  pixels = ( rows * cols );

if sensor == LANDSAT_TM
    resolution_cell = 0.030;
end

if sensor == SPOT_PANCHROMATIC
    resolution_cell = 0.010;
end

w = cols * resolution_cell;
h = rows * resolution_cell;
a = pixels * ( resolution_cell^2 );

width = w;
height = h;
area = a;

end

