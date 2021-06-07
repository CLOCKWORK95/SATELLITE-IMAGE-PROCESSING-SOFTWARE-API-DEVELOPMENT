function density_slicing( image, img_collection, names, colors )
%  DENSITY_SLICING
%  This algorithm builds the color matrix on the basis of uncalibrated
%  radiance mean values and standard deviations computed in band 4, for each 
%  surface previously selected. In this way, for each pixel of the original
%  image having DN value which falls into interval [mean-std, mean+std] a
%  precise color will be associated. Whenever a DN falls into two or more
%  intervals (in case of interceptions), the policy for chosing which color
%  will be assigned is based on the minimum distance from mean value.

% Chose band 4 (NIR) as reference image.
img = image( :, :, 4 );

% Get DN ranges for density slicing from band 4 statistics (mean +- stdev).
num_stats = size( img_collection.stats ); num_stats = num_stats( 1 );

for i = 1 : 1 : num_stats    
    stats{i} = img_collection.stats{ i , 4 };   
end

for j = 1 : 1 : num_stats    
    mean = stats{ j }( 1 );
    stdev = stats{ j }( 2 );
    ranges{ j } = [ (mean-stdev) (mean+stdev) ];
end


for i = 1 : 1 : 255 
    
    % Populate mymap matrix containing DN color mapping.
    mymap( i, : ) = [ 0.5 0.5 0.5 ];
    distance = 255;
    
    for j = 1 : 1 : num_stats
        
        upper = ranges{ j }( 2 );
        lower = ranges{ j }( 1 );
        middle = ( upper + lower ) / 2 ;
        d = abs( middle - double(i) );
        
        if double(i) <= upper && double(i) >= lower && d < distance
            mymap( i, : ) = colors{ j };
            distance = d;
            continue
        end
        
    end         
    
end

% Apply colormap on the original image.
figure( 'Name', 'Density Slicing' );
imshow(img);
colormap( mymap );


end

