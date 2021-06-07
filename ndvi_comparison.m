function ndvi_comparison( impath1, impath2, RS )
%   NDVI_COMPARISON 
%   This function can be used to compare on a same figure two NDVI maps,
%   which are generated from 2 images specified in input by their path.

try   
    img1 = imread( impath1 );
    img2 = imread( impath2 );    
catch ERR
    disp(" You probably typed uncorrect image path names...");
    return
end

NDVI_1 = ndvi_map( img1, RS, 1 );
NDVI_2 = ndvi_map( img2, RS, 1 );
palette = ndvi_palette( 0 );

figure( 'Name', 'NDVI comparison' );

subplot(1,2,1);
imshow(NDVI_1);
colormap( palette );
title( impath1 );

subplot(1,2,2);
imshow(NDVI_2);
colormap( palette );
title( impath2 );

end

