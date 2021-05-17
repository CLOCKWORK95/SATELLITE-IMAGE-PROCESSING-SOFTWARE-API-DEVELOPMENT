function histogram_equalization( image, band, sensor )
%   HISTOGRAM_EQUALIZATION 
%   @params: string (image_path), integer (band).
%   This function implements the histogram equalization procedure
%   for the given band of the .tif image specified by 'image_path'.
%   The results of the procedure are finally plotted on screen in both
%   forms of histograms and images.


% Read image.tif from file path and get size values.
dim = size(image);
lines = dim(1);
columns = dim(2);

N = dim(1)*dim(2);          % number of pixels

M = 8;                      % number of bits per pixel

L = (2^M)-1;                % number of available DNs

nsf = (L-1)/N;              % normalization and scale factor


% The next code block is used to populate the probability distribution 
% function vector.
pdf_origin = zeros(1,L+1);

for i = 1:lines
    
    for j = 1:columns
        
        pdf_origin( image(i,j,band) + 1 ) = pdf_origin( image(i,j,band)+ 1 ) + 1;
        
    end
    
end


% The next code block is used to populate the cumulative distribution 
% function vector.
cdf_origin = zeros(1,L+1);

for i = 1:1:L+1
    
    for sum_index = 1:i
    
        cdf_origin(i) = cdf_origin(i) + pdf_origin(sum_index);
    
    end
    
end


% Build the Lookup Table to perform the Histogram Equalization.
LUT = zeros(1, L+1);

for x = 1:L+1
    LUT(x) = cdf_origin(x) * nsf;
end

% Rebuild the image by reading the corresponding new value on the LUT.
for i = 1:lines
    
    for j = 1:columns
        
        new_image(i,j) = uint8( LUT( image(i,j,band) + 1 ) );
        
    end
    
end

% width (km), height (km), area (km^2)
[ width_1, height_1 ] = image_sizes( image, sensor );

% mean (DN), std (DN), mode (DN)
[ mean_1, mode_1, stdev_1] = image_statistics( image, band);
[ mean_2, mode_2, stdev_2] = image_statistics( new_image, 0);

% Landsat 4-5 Thematic Mapper Wavelengths.
wavelengths = {'0.45-0.52\mum' '0.52-0.60\mum' '0.63-0.69\mum' ...
    '0.76-0.90\mum' '1.55-1.75\mum' '10.4-12.5\mum' '2.08-2.35\mum'};

% Plot the results in graphics.
figure('Name','Histogram Equalization');

subplot(2,2,1), imshow(image(:,:,band))
t = sprintf( 'B%d  %s', band );
subt = sprintf( '%.2fkm x %.2fkm', width_1, height_1 );
title( { t, subt } );

subplot(2,2,2), h1 = histogram(image(:,:,band), 'binwidth', 1);
h1.FaceColor = [0.94 0.78 0.61];
stats = sprintf( 'mean %.2f - stdev %.2f - mode %d', mean_1, stdev_1, mode_1 );
title( { t, stats } );
xlim([0 255]);    
ylim([0 N/5])
ylabel('#pixels');
xlabel('DN');


subplot(2,2,3), imshow(new_image)
t = sprintf( 'HIST.EQUAL. B%d  %s', band );
subt = sprintf( '%.2fkm x %.2fkm', width_1, height_1 );
title( { t, subt } );

subplot(2,2,4), h2 = histogram(new_image, 'binwidth', 1);
h2.FaceColor = [0.69 0.11 0.25];
stats = sprintf( 'mean %.2f - stdev %.2f - mode %d', mean_2, stdev_2, mode_2 );
title( { t, stats } );
xlim([0 255]);    
ylim([0 N/5])
ylabel('#pixels');
xlabel('DN');



end

