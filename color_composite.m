function color_composite(image, R, G, B, subplots)
%COLOR_COMPOSITE 
%   @params: string (image_path), int,int,int, string (subplots).
%   This function produces a color-composite from an image in format .tif.
%   Input variables are not all mandatory.
%   -color_composite('my_path') produces a standard RGB image by combining
%   bands B3|B2|B1 of a Landsat 4-5 Thematic Mapper sensor.
%   The integer parameters R,G,B can be used to specify the level of
%   imagery to assign to each color. The subplots parameter can be posed to
%   'multiple' to display all single bands plots on screen together with
%   their color-composite.

if ~exist('subplots','var')
     % 5th parameter does not exist, so default it to something
      subplots = 'single';
end
 
if ~exist('R','var')
     % 2nd parameter does not exist, so default it to something
      R = 3;
end

if ~exist('G','var')
     % 3rd parameter does not exist, so default it to something
      G = 2;
end

if ~exist('B','var')
     % 4th parameter does not exist, so default it to something
      B = 1;
end
 
% Landsat 4-5 Thematic Mapper Wavelengths.
wavelengths = {'0.45-0.52\mum' '0.52-0.60\mum' '0.63-0.69\mum' ...
    '0.76-0.90\mum' '1.55-1.75\mum' '10.4-12.5\mum' '2.08-2.35\mum'};

% Read image from file path and separate each band's data.
B1 = image(:,:,B);
B2 = image(:,:,G);
B3 = image(:,:,R);

% Generates RGB color composite.
M = cat(3, B3, B2, B1);

if ( strcmp(subplots,'multiple') )         % generate a complete plot
    
    figure('Name','Color Composite');
    
    subplot(2,2,1), imshow(B3)
    title([['Red: B' num2str(R)] wavelengths(R)]);
    
    subplot(2,2,2), imshow(B2)
    title([['Green: B' num2str(G)] wavelengths(G)]);
    
    subplot(2,2,3), imshow(B1)
    title([['Blue: B' num2str(B)] wavelengths(B)]);
    
    subplot(2,2,4), imshow(M)
    title(['Color composite' ' ']);
    
else                                       % display only the final result
    figure('Name','Color Composite');
    imshow(M)
    title(['Color composite: B' num2str(R) '|B' num2str(G) ...
        '|B' num2str(B)]);
end


end

