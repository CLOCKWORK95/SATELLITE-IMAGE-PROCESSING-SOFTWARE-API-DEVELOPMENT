function [ c, c_names, c_colors ] = collect_crops( image, sensor, rectangles )
%	COLLECT_CROPS Summary of this function goes here
%   Detailed explanation goes here

warning ('off','all');

% Drawing rectangles and collect all crop images in a data structure.

dimensions = size( image ); 
bands = dimensions( 3 );

f = figure('Name', 'Select crops by drawing rectangles on the image.');
RGB = cat( 3, image(:,:,4), image(:,:,2), image(:,:,1) );
imshow( RGB );

for i = 1 : 1 : rectangles
    
    V{i} = getrect( f );
    % Chosing custom crop's names.
    prompt = { 'Crop''s Name: ' };
    dlgtitle = 'Features of selected Crop';
    dims = [ 1 35 ];
    definput = { 'clear water' };
    names{i} = inputdlg( prompt, dlgtitle, dims, definput );
    % Create custom color palette : one color for each crop's plot.
    palette{i} = uisetcolor();
    
    for j = 1 : 1 : bands
        
        img = image( :, :, j );
        crop = img( V{i}(2):V{i}(2)+V{i}(4),V{i}(1):V{i}(1)+V{i}(3) );
        CROPS{i}( :, :, j ) = crop;
        
    end
    
end

crops = image_collection( CROPS{1}, sensor );
for i = 2 : 1 : rectangles
    crops.append( CROPS{i} );
end
    

c = crops;
c_names = names;
c_colors = palette;

close(f);

warning ('on','all');

end

