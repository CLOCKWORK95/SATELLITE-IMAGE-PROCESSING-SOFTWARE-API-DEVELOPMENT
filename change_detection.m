function change_detection( img1, img2, name1, name2 )
%   CHANGE_DETECTION 
%   This function takes as input values two images. Images must possess at
%   least 5 bands, since the change detection is performed using bands
%   5,4,2 of Landsat TM Level 1 imagery. The two images must be already
%   registered, counting the same number of pixels.

[ rows, cols ] = size( img1(:,:,1) );

for k = 1 : 1 : 7
    for i = 1 : 1 : rows
        for j = 1 : 1 : cols
            CD( i, j, k ) = uint8( double(img1( i, j, k )) - double(img2( i, j, k )) + 127  );
        end
    end
end

CD_R = CD( :, :, 5 );
CD_G = CD( :, :, 4 );
CD_B = CD( :, :, 2 );

im1_R = img1( :, :, 5 );
im1_G = img1( :, :, 4 );
im1_B = img1( :, :, 2 );

im2_R = img2( :, :, 5 );
im2_G = img2( :, :, 4 );
im2_B = img2( :, :, 2 );

M = cat( 3, CD_R, CD_G, CD_B );
N = cat( 3, im1_R, im1_G, im1_B );
O = cat( 3, im2_R, im2_G, im2_B );

f = figure( 'Name', 'Change Detection' );
subplot( 1, 3, 1);
imshow( N );
title( name1 );

subplot( 1, 3, 2);
imshow( O );
title( name2 );

subplot( 1, 3, 3);
imshow( M );
t = sprintf(" Change Detection: %s - %s ", name1, name2);
title( t );

end

