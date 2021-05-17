function [stretched_img] = linear_stretching(image, band, plots, sensor)
%  LINEAR_STRETCHING 
%  @params: image.tif, reference band integer index, string (plots). This
%  function performs the linear stretching procedure on an image's
%  reference band, specified in input. The function returns the stretched
%  image and (optional) plots the transformation histograms and relative
%  imagery.


if ~exist('plots','var')
     % 5th parameter does not exist, so default it to something
      plots = 'yesplot';
end

% Read image.tif from file path and get size values.
dim = size(image);
lines = dim(1);
columns = dim(2);
N = lines*columns;

M = 8;                      % number of bits per pixel
L = (2^M)-1;                % number of available DNs

% Find min and max values assumed by DNs in the sample image.
min_DN = double( min( image(:,:,band), [], 'all' ));
max_DN = double( max( image(:,:,band), [], 'all' ));

% Build the Lookup Table to perform the Linear Stretching.
LUT = zeros( 1, L+1 );
for x = 1:1:L+1    
    LUT(x) = (( x - min_DN )/( max_DN - min_DN )) * L ;    
end


% Rebuild the image by reading the corresponding new value on the LUT.
for i = 1:lines
    
    for j = 1:columns
        
        new_image(i,j) = uint8( LUT( image(i,j,band)+ 1 ) );
        
    end
    
end

if ( strcmp( plots,'yesplot' ) )
    
    % Landsat 4-5 Thematic Mapper Wavelengths.
    wavelengths = {'0.45-0.52\mum' '0.52-0.60\mum' '0.63-0.69\mum' ...
        '0.76-0.90\mum' '1.55-1.75\mum' '10.4-12.5\mum' '2.08-2.35\mum'};

    % width (km), height (km), area (km^2)
    [ width_1, height_1 ] = image_sizes( image, sensor );

    % mean (DN), std (DN), mode (DN)
    [ mean_1, mode_1, stdev_1] = image_statistics( image, band);
    [ mean_2, mode_2, stdev_2] = image_statistics( new_image, 0);


    % Plot the results in graphics.
    figure('Name','Linear Stretching');

    subplot(2,2,1), imshow(image(:,:,band))
    t = sprintf( 'B%d  %s', band );
    subt = sprintf( '%.2fkm x %.2fkm', width_1, height_1 );
    title( { t, subt } );
    
    subplot(2,2,2), h1=histogram(image(:,:,band), 'binwidth', 1);
    h1.FaceColor = [0.94 0.78 0.61];
    stats = sprintf( 'mean %.2f - stdev %.2f - mode %d', mean_1, stdev_1, mode_1 );
    title( { t, stats } );
    xlim([0 255]);    
    ylim([0 N/6])
    ylabel('#pixels');
    xlabel('DN');


    subplot(2,2,3), imshow(new_image)
    t = sprintf( 'LINEAR STRETCHING B%d  %s', band );
    subt = sprintf( '%.2fkm x %.2fkm', width_1, height_1 );
    title( { t, subt } );
    
    subplot(2,2,4), h2 = histogram(new_image, 'binwidth', 1);
    h2.FaceColor = [0.69 0.11 0.25];
    stats = sprintf( 'mean %.2f - stdev %.2f - mode %d', mean_2, stdev_2, mode_2 );
    title( { t, stats } );
    xlim([0 255]);    
    ylim([0 N/6])
    ylabel('#pixels');
    xlabel('DN');
end

stretched_img = new_image;

end

