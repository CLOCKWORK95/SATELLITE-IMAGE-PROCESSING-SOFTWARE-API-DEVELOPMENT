function uncalibrated_radiances( img_collection, names, colors )
%   UNCALIBRATED RADIANCES 
%   This function plots uncalibrated radiance "curves" (for all available
%   bands of the remote sensor) of user's selected terrain crops on an
%   image. The function makes use of errorbar plot to specify errors range 
%   around the mean DN value, given by stdev computed value on crops' 
%   pixels.

% Cell Array ( rows : image - cols : band stats )
stats = img_collection.stats;

% Number of collected images
counter = img_collection.counter; 

% Wavelengths array
wavelengths = img_collection.RS.wavelengths;
if img_collection.RS.id == 0
    wavelengths = sort(wavelengths);
    wavelengths = wavelengths( 1 : ( length( wavelengths ) - 1 ) );
end

% Populating uncalibrated radiances matrix. 
% Each row contains mean radiances for a single crop, at each wavelength.
for i = 1 : 1 : counter
    for j = 1 : 1 : length(wavelengths)
        uncalibrated_rad(i,j) = stats{ i, j }( 1 );      
    end
end

% Populating std deviations matrix. 
% Each row contains stdevs for a single crop, at each wavelength.
for i = 1 : 1 : counter
    for j = 1 : 1 : length( wavelengths )
        stdev(i,j) = stats{ i, j }( 2 );             
    end
end


% Plotting uncalibrated radiance's plots.
f = figure( 'Name', 'Uncalibrated Radiance vs Wavelength' );
for i = 1 : 1 : counter
    errorbar( wavelengths( 1, : ), uncalibrated_rad( i, : ), -stdev( i, : ),stdev( i, : ), 'Color', colors{i}, 'DisplayName', names{i}{1});    
    hold on;    
end
legend;
xlabel('Wavelength [ μm ]');
xticks([ 0.485 0.56 0.66 0.83 1.65 2.215 ]);
ylabel('Uncalibrated Radiance [ DN ]');
title(' Uncalibrated Radiance [DNs] vs Wavelength [\mum]');
grid on

end

