function [ wmask_area ] = manual_water_mask( image, band, sensor )
%   MANUAL_WATER_MASK 
%   This function allows to create a water mask on an image subset, chosen
%   manually from a panel by calling the matlab function getrect.
%   The algorithm uses a practical approach, based on manual selection from 
%   the crop image of the transtion DN value, to discriminate water filled
%   cells.

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

image = image( :, :, band );
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

% Chose a line of crop image to get the DN profile.
f2 = figure('Name', 'Find line index to get line''s DN profile');
imshow( NIR_CROP );
line = input(' Please, select a line index to get line''s profile: ');
profile = NIR_CROP( line, : );
dim = size( profile ); length = dim(2);
close(f2)

% Show line's DN profile to get the transition pixel DN value.
figname = [' Line ' num2str(line) ' : DN Profile' ];
f3 = figure('Name', figname );
px = 1:1:length;
plot( px, profile,'--gs',...
    'LineWidth',0.5,...
    'MarkerSize',3,...
    'MarkerEdgeColor','b',...
    'MarkerFaceColor',[0.5,0.5,0.5]);

ylim([0 255]);     % upper and lower limits to Yaxis values.
xlim([0 length]);  % upper and lower limits to Xaxis values.

xlabel('pixel ( Y coordinate )');
ylabel('DN');
yticks(0:10:255);

title( figname );
grid on

transitionDN = input( ' Please, type the value of transition DN to generate water mask: ' );

close(f3);


% Water mask generation.
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


% Calculate water mask's area and show mask's image in figure.
mask_area = pixels * resolution_cell^2;
figure('Name', 'Water Mask');
imshow( NIR_CROP );
title( [ 'WATER MASK ( mask area = '  num2str(mask_area)  ' km^2)' ] );

warning ('on','all');

wmask_area = mask_area;

end

