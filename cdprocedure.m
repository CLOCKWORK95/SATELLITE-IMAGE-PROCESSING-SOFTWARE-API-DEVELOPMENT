function cdprocedure( impath1 ,impath2, jsonhead1, jsonhead2 )
%   CDPROCEDURE (change detection)
%   This function is used to initialize the change detection procedure, by
%   specifing the two images' paths and the relative json files to find the
%   georeferentiations of images' corners. This function calls two other
%   ones, the registration function and the change detection function, and
%   displays the final result.

disp(' Please, wait... this procedure could take a while...');

% Retrieve corner geo-references from json header files.

% Image 1 geo-references.

file94 = fopen( jsonhead1 );

line94 = fgetl( file94 );

fclose( file94 );

jsonfile94 = jsondecode( line94 );

UP = str2double(jsonfile94.LANDSAT_METADATA_FILE.PROJECTION_ATTRIBUTES.CORNER_UL_PROJECTION_Y_PRODUCT);

LEFT = str2double(jsonfile94.LANDSAT_METADATA_FILE.PROJECTION_ATTRIBUTES.CORNER_UL_PROJECTION_X_PRODUCT);

RIGHT = str2double(jsonfile94.LANDSAT_METADATA_FILE.PROJECTION_ATTRIBUTES.CORNER_UR_PROJECTION_X_PRODUCT);

LOW = str2double(jsonfile94.LANDSAT_METADATA_FILE.PROJECTION_ATTRIBUTES.CORNER_LR_PROJECTION_Y_PRODUCT);

LIMITS(1,:) = [ UP LEFT RIGHT LOW ];


% Image 2 geo-references.

file11 = fopen( jsonhead2 );

line11 = fgetl( file11 );

fclose( file11 );

jsonfile11 = jsondecode( line11 );

UP = str2double(jsonfile11.LANDSAT_METADATA_FILE.PROJECTION_ATTRIBUTES.CORNER_UL_PROJECTION_Y_PRODUCT);

LEFT = str2double(jsonfile11.LANDSAT_METADATA_FILE.PROJECTION_ATTRIBUTES.CORNER_UL_PROJECTION_X_PRODUCT);

RIGHT = str2double(jsonfile11.LANDSAT_METADATA_FILE.PROJECTION_ATTRIBUTES.CORNER_UR_PROJECTION_X_PRODUCT);

LOW = str2double(jsonfile11.LANDSAT_METADATA_FILE.PROJECTION_ATTRIBUTES.CORNER_LR_PROJECTION_Y_PRODUCT);

LIMITS(2,:) = [ UP LEFT RIGHT LOW ];


im1 = imread( impath1 );
im2 = imread( impath2 );

[ lef09, lef11 ] = registration( im1, im2, LIMITS );

change_detection( lef09, lef11, impath1 , impath2 );

end

