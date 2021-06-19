function [image1,image2] = registration( im1, im2, LIMITS )
%   REGISTRATION
%   This function is used to register two images, having a common
%   intersection. The two images must be already geo-referenced, and the
%   corner values have to be specified in input variable LIMITS.
%   This function returns a subset manually retailed from registered
%   images (function getrect).

dims1 = size( im1( :, :, 1 ) );
dims2 = size( im2( :, :, 1 ) );

% Landsat TM ground resolution cell (pixel size at Earth's surface (m) )
GROUND_RES_CELL = 30;

% Image 1 borders ( from USGS projected references (m) )
UP1 = LIMITS( 1, 1 );
LEFT1 = LIMITS( 1, 2 );
RIGHT1 = LIMITS( 1, 3 );
LOW1 = LIMITS( 1, 4 );

% Image 2 borders ( from USGS projected references (m) )
UP2 = LIMITS( 2, 1 );
LEFT2 = LIMITS( 2, 2 );
RIGHT2 = LIMITS( 2, 3 );
LOW2 = LIMITS( 2, 4 );


% Cut off the extra borders ( non overlapping ones )
if UP1 > UP2
    shift = UP1 - UP2;
    npixels = shift/GROUND_RES_CELL; 
    im1 = im1( npixels + 1 : dims1(1), :, : );
else
    shift = UP2 - UP1;
    npixels = shift/GROUND_RES_CELL;
    im2 = im2( npixels + 1 : dims2(1), :, : );
end

dims1 = size( im1( :, :, 1 ) );
dims2 = size( im2( :, :, 1 ) );

if LEFT1 < LEFT2
    shift = LEFT2 - LEFT1;
    npixels = shift/GROUND_RES_CELL;
    im1 = im1( :, npixels + 1 : dims1(2), : );
else
    shift = LEFT1 - LEFT2;
    npixels = shift/GROUND_RES_CELL;
    im2 = im2( :, npixels + 1 : dims2(2), : );
end

dims1 = size( im1( :, :, 1 ) );
dims2 = size( im2( :, :, 1 ) );

if RIGHT1 > RIGHT2
    shift = RIGHT1 - RIGHT2;
    npixels = shift/GROUND_RES_CELL;
    im1 = im1( :, 1 : dims1(2) - npixels , : );
else
    shift = RIGHT2 - RIGHT1;
    npixels = shift/GROUND_RES_CELL;
    im2 = im2( :, 1 : dims2(2) - npixels , : );
end

dims1 = size( im1( :, :, 1 ) );
dims2 = size( im2( :, :, 1 ) );

if LOW1 < LOW2
    shift = LOW2 - LOW1;
    npixels = shift/GROUND_RES_CELL;
    im1 = im1( 1 : dims1(1) - npixels , :, : );
else
    shift = LOW1 - LOW2;
    npixels = shift/GROUND_RES_CELL;
    im2 = im2( 1 : dims2(1) - npixels , :, : );
end

% Consistency check
dims1 = size(im1(:,:,1));
dims2 = size(im2(:,:,1));

if dims1(1)== dims2(1) && dims1(2) == dims2(2)
    disp(' The two images has been successfully registered. Please, select the area of interest.');
else
    disp(' Something went wrong...');
    return
end

% Select a subset from reference image.
warning ('off','all');
visual = im1( :, :, 4);
f1 = figure('Name', 'Select a subset drawing a rectangle on the image.');
imshow(visual);
try
    V = getrect( f1 );
    SUBSET_1 = im1( V(2):V(2)+V(4), V(1):V(1)+V(3), :);
    SUBSET_2 = im2( V(2):V(2)+V(4), V(1):V(1)+V(3), :);   
    close(f1);
catch ERR
    disp(' Pay attention drawing a rectangle inside the actual image!');
    close(f1);
    return
end
warning ('on','all');
    
image1 = SUBSET_1;
image2 = SUBSET_2;

end

