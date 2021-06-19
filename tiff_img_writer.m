% By this sketch it is possible to merge more tiff images into a single
% one in the form [row, columns, bands]. 

for i = 1:1:7
    s = int2str(i);
    path = sprintf( 'L1lefkasTM1994/lefkas94B%s.TIF', s );
    image09( :, :, i ) = imread( path );
end

for i = 1:1:7
    s = int2str(i);
    path = sprintf( 'L1lefkasTM2011/lefkas11B%s.TIF', s );
    image11( :, :, i ) = imread( path );
end



t = Tiff('lefkas94.tif','w');

img = image09( :, :, 1 );
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
t.write( image09 );
t.close();



t = Tiff('lefkas11.tif','w');

img = image11( :, :, 1 );
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
t.write( image11 );
t.close();

