function image_bands( image, bands, sensor )
%IMAGE_BANDS 
%   @params: string (image_path), integer array (bands).
%   This function takes as argument an image in .tif format, and a list of
%   bands. As output, this procedure plots the images of single specified
%   bands in grey scale (0-255). Further, an histogram representation of
%   Probability Distribution Function of digital numbers (DN's) is reported
%   next to each band image.

% Landsat 4-5 Thematic Mapper Wavelengths.
wavelengths = {'0.45-0.52\mum' '0.52-0.60\mum' '0.63-0.69\mum' ...
    '0.76-0.90\mum' '1.55-1.75\mum' '10.4-12.5\mum' '2.08-2.35\mum'};

% Read image from file path and get dimensions.
img_size = size(image);
rows = img_size(1); cols = img_size(2); pixels = rows*cols;
n = size(bands);
n = n(2);

% width (km), height (km), area (km^2)
[ width, height ] = image_sizes( image, sensor );

i = 1;
figure('Name', 'Band Viewer - Grey Scale');
for band = bands
    
    % mean (DN), std (DN), mode (DN)
    [ mean_, mode_, stdev_] = image_statistics( image, band);
    
    subplot(n,2,i), imshow(image(:,:,band))
    t = sprintf( 'B%d  %s', band );
    subt = sprintf( '%.2fkm x %.2fkm', width, height );
    title( { t, subt } );
    
    stats = sprintf( 'mean %.2f - stdev %.2f - mode %d', mean_, stdev_, mode_ );
    subplot(n,2,i+1), histogram(image(:,:,band));
    title( { t, stats } );
    
    xlim([0 255]);    
    ylim([0 pixels/5]);
    ylabel('#pixels');
    xlabel('DN');
    i = i + 2;
    
end


end

