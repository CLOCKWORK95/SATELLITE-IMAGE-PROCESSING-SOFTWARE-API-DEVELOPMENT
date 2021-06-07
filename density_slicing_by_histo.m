function density_slicing_by_histo( image )
%DENSITY_SLICING_BY_HISTO Summary of this function goes here
%   Detailed explanation goes here

img = image( :, :, 4 );
pixels = size( img );   pixels = pixels( 1 ) * pixels( 2 );

% Histogram representation
figure( 'Name', 'Histogram' );
histogram( img );
xlim([0 255]);    
ylim([0 pixels/5]);
ylabel('#pixels');
xlabel('DN');

% Type number of slices to be associated to a color.
prompt = { ' Number of slices: ' };
dlgtitle = 'Density Slicing';
dims = [ 1 35 ];
definput = { '4' };
answer = inputdlg( prompt, dlgtitle, dims, definput );
answer = uint8( str2num( answer{1} ) );

% Set slices features.
for i = 1 : 1 : answer   
    prompt = { 'Surface type: ', 'Min DN value: ', 'Max DN value: ' };
    dlgtitle = 'Features of selected DN range';
    dims = [ 1 35 ];
    definput = { 'clear water' , '0', '255' };
    features{i} = inputdlg( prompt, dlgtitle, dims, definput );
    features{i}{4} = uisetcolor();
    features{i}{2} = str2num( features{i}{2} );
    features{i}{3} = str2num( features{i}{3} );
end


for i = 1 : 1 : 255 
    
    % Populate mymap matrix containing DN color mapping.
    mymap( i, : ) = [ 0.5 0.5 0.5 ];
    
    for j = 1 : 1 : answer
        
        upper = features{ j }{ 3 };
        lower = features{ j }{ 2 };
        
        if double(i) <= upper && double(i) >= lower 
            mymap( i, : ) = features{ j }{ 4 };
            continue
        end
        
    end         
    
end


% Apply colormap on the original image.
figure( 'Name', 'Density Slicing' );
imshow( img );
colormap( mymap );


end

