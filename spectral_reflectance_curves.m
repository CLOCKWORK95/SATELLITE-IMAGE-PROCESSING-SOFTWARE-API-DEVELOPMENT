function spectral_reflectance_curves( img_collection, names, colors )
%   SPECTRAL REFLECTANCE CURVES 
%   This function plots spectral reflectance "curves" (for all available 
%   spectral bands of the remote sensor) of user's specified terrain
%   crops on the BSQ image. The function uses the mean DN value and stdev
%   of selected crops.

% Cell Array ( rows : image - cols : band stats )
stats = img_collection.stats;

% Number of collected images
counter = img_collection.counter; 

% Get Remote Sensor parameters to retrieve spectral reflectance values.
GAINS = img_collection.RS.gains; 
OFFSETS = img_collection.RS.offsets;
I = img_collection.RS.irradiance;
if img_collection.RS.id == 0
    GAINS(6) = GAINS(7);
    OFFSETS(6) = OFFSETS(7);
    I(6) = I(7);
end
    
    
% Wavelengths array
wavelengths = img_collection.RS.wavelengths;
if img_collection.RS.id == 0
    wavelengths = sort(wavelengths);
    wavelengths = wavelengths( 1 : ( length( wavelengths ) - 1 ) );
end

% Populating reflectances matrix. 
% Each row contains mean radiances for a single crop, at each wavelength.
DOS = [ 50 0 0 0 0 0 ];
for i = 1 : 1 : counter
    for j = 1 : 1 : length(wavelengths)        
        DN = stats{ i, j }( 1 );
        reflectances(i,j) = ( pi * ( GAINS(j)*( DN - DOS(j) ) + OFFSETS(j) ) ) / I(j);      
    end
end

% Populating std deviations matrix. 
% Each row contains stdevs for a single crop, at each wavelength.
for i = 1 : 1 : counter
    for j = 1 : 1 : length( wavelengths )
        STD = stats{ i, j }( 2 );
        stdev(i,j) = ( pi * ( GAINS(j)* STD ) ) / I(j);                  
    end
end


% Plotting uncalibrated radiance's plots.
f = figure( 'Name', 'Spectral Reflectance vs Wavelength' );
for i = 1 : 1 : counter
    errorbar( wavelengths( 1, : ), reflectances( i, : ), stdev( i, : ),  'Color', colors{i}, 'DisplayName', names{i}{1} );    
    hold on;    
end
legend;
xlabel('Wavelength [ μm ]');
xticks([ 0.485 0.56 0.66 0.83 1.65 2.215 ]);
ylim([0 1]);
ylabel('Spectral Reflectance');
title(' Spectral Reflectance vs Wavelength [\mum]');
grid on

end

