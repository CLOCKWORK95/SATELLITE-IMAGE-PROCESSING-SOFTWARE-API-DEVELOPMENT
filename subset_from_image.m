function subset_from_image( origin_image, subset_name )
%   SUBSET_FROM_IMAGE 
%   

% Select a subset from reference image.
warning ('off','all');
visual = origin_image( :, :, 4);
f1 = figure('Name', 'Select a subset drawing a rectangle on the image.');
imshow(visual);
try
    V = getrect( f1 );
    image = origin_image( V(2):V(2)+V(4), V(1):V(1)+V(3), :);  
    close(f1);
catch ERR
    disp(' Pay attention drawing a rectangle inside the actual image!');
    close(f1);
    return
end
warning ('on','all');


t = Tiff( subset_name ,'w' );

img = image( :, :, 1 );
tags.ImageLength   = size( img, 1 );
tags.ImageWidth    = size( img, 2 );
tags.Photometric   = Tiff.Photometric.MinIsBlack;
tags.BitsPerSample = 8;
tags.SampleFormat  = Tiff.SampleFormat.UInt;
%tags.StripOffsets = 0;
tags.RowsPerStrip  = 16;  
tags.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
tags.SamplesPerPixel = 7;
unspec               = Tiff.ExtraSamples.Unspecified;
tags.ExtraSamples    = [ unspec, unspec, unspec, unspec, unspec ];
t.setTag( tags );
disp(t);
t.write( image );
t.close();

end

