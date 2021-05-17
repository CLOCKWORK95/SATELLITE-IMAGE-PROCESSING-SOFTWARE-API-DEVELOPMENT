function [ wmask_area ] = water_mask( image, band, sensor )
%   WATER_MASK 
%   This function allows to create a water mask on an image subset, chosen
%   manually from a panel by calling the matlab function getrect.
%   The algorithm is based on the water's spectral signature at NIR range.
%   Since water's reflectance is much lower than bare soil/vegetation ones,
%   it is enough to filter all pixels having a NIR reflectance <= 10%.

warning ('off','all');

LANDSAT_TM = 0;
SPOT_PANCHROMATIC = 1;

if sensor == LANDSAT_TM
    resolution_cell = 0.030;
    if band == 6
        resolution_cell = 0.120;
    end
end

if sensor == SPOT_PANCHROMATIC
    resolution_cell = 0.010;
    band = 1;
end

image = image( :, :, band);
f1 = figure('Name', 'Select a subset drawing a rectangle on the image.');
imshow(image);

try
    V = getrect( f1 );
    NIR_CROP = image(V(2):V(2)+V(4),V(1):V(1)+V(3));
    close(f1);
catch ERR
    disp(' Pay attention drawing a rectangle inside the actual image!');
    close(f1);
    return
end


switch band
    
    case 4      % NIR BAND ( water reflectance <= 10% )
        
        dim = size(NIR_CROP); rows = dim(1); cols = dim(2); 
        pixels = 0;
        
        for i = 1 : 1 : rows
            for j = 1 : 1 : cols             
                if NIR_CROP(i,j) <= ceil( 255 * 0.1 )
                    NIR_CROP(i,j) = 0;
                    pixels = pixels + 1;
                else
                    NIR_CROP(i,j) = 255;
                end
            end 
        end
        
        
    otherwise
        dim = size(NIR_CROP); rows = dim(1); cols = dim(2); 
        pixels = 0;
        
        for i = 1 : 1 : rows
            for j = 1 : 1 : cols             
                if NIR_CROP(i,j) <= transitionDN
                    NIR_CROP(i,j) = 0;
                    pixels = pixels + 1;
                else
                    NIR_CROP(i,j) = 255;
                end
            end 
        end
        
end


% Calculate water mask's area and show mask's image in figure.
mask_area = pixels * resolution_cell^2;
figure('Name', 'Water Mask');
imshow( NIR_CROP );
title( [ 'WATER MASK ( mask area = '  num2str(mask_area)  ' km^2)' ] );

warning ('on','all');

wmask_area = mask_area;

end

