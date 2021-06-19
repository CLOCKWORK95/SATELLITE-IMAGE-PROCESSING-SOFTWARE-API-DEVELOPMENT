function tiff_writer( bands_path ,subset_name )
%   TIFF_WRITER Summary of this function goes here
%   Detailed explanation goes here

for i = 1:1:7
    s = int2str(i);
    path = sprintf( '%sB%s.TIF', bands_path , s );
    image( :, :, i ) = imread( path );
end

t = Tiff( subset_name ,'w' );

img = image( :, :, 1 );
tags.ImageLength   = size( img, 1 );
tags.ImageWidth    = size( img, 2 );
tags.Photometric   = Tiff.Photometric.MinIsBlack;
tags.BitsPerSample = 8;
tags.SampleFormat  = Tiff.SampleFormat.UInt;
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

