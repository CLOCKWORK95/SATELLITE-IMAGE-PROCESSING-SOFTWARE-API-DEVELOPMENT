function [ meanval, modeval, stdevval ] = image_statistics( image, band )
%IMAGE_STATISTICS Summary of this function goes here
%   Detailed explanation goes here

if band == 0
    img = image;
else
    img = image(:,:,band);
end

mean_DN = mean( img, 'all' );

mode_DN = mode( img, 'all' );

stdev_DN = std( double(img), 0, 'all');


meanval = mean_DN;
modeval = mode_DN;
stdevval = stdev_DN;

end

