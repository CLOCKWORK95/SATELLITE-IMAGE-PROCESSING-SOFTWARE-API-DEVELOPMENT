function [NDVI] = ndvi_map( image, RS, type )
%   NDVI_MAP 
%   Create NDVI map of a given image (Normalized Difference Vegetation 
%   Index). NDVI pixel values are obtained by computing: 
%   NDVI = NIR-RED/NIR+RED on calibrated reflectance values.

dim = size( image );    x = dim(1);     y = dim(2);

% Get sensor's parameters
GAINS = RS.gains; 
OFFSETS = RS.offsets;
I = RS.irradiance;

% Get the bands of interest: red and near infrared.
img_RED = image( :, :, 3 );
img_NIR = image( :, :, 4 );

% Calibration: obtaining pixel reflectance values into 2 new matrices.
reflectance_RED = double( pi * (GAINS(3) * ( double(img_RED)) + OFFSETS(3) )) / I(3);
reflectance_NIR = double( pi * (GAINS(4) * ( double(img_NIR)) + OFFSETS(4) )) / I(4);  


% Set all negative reflectance values to NaN.
reflectance_RED( reflectance_RED < 0 ) = nan;
reflectance_NIR( reflectance_NIR < 0 ) = nan;

% NDVI computation
for i = 1 : 1 : x
    for j = 1 : 1 : y      
        NDVI_MAP(i,j) = ( reflectance_NIR(i,j) - reflectance_RED(i,j) )/( reflectance_NIR(i,j) + reflectance_RED(i,j) );
    end
end

% NDVI Matrix : Linear Stretching [ -1 , 1 ]  --->  [ 0 , 255 ]
for i = 1 : 1 : x
    for j = 1 : 1 : y      
        NDVI_MAP(i,j) = 127.5 * ( NDVI_MAP(i,j) + 1 );
    end
end

if (type == 0)
    figure( 'Name', 'NDVI MAP' );
    imshow( uint8( NDVI_MAP ) );
    palette = ndvi_palette( 0 );
    colormap( palette );
    NDVI = uint8( NDVI_MAP );
else
    NDVI = uint8( NDVI_MAP );
end

end

