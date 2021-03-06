% -------------------------------------------------------------------------
% Author :                  Gianmarco Bencivenni - 0285847
% Association :             University of Rome Tor Vergata
% Faculty :                 Master's Computer and Information Engeneering
% Course :                  Geoinformazione
% Program Name :            mainapp.m
% Programming language :    Matlab (R2020b)
% Date :                    May-June 2021
% -------------------------------------------------------------------------
% Software application description:
% This script makes use of different functions to visualize some
% features of sample BSQ images taken from Landsat 4-5 Thematic Mapper and
% Spot panchromatic sensors. 
% This application implements (with some extras):
% EXERCISE 1
% EXERCISE 2
% EXERCISE 3
% EXERCISE 4
% EXERCISE 5
% EXERCISE 6 (CHANGE DETECTION)
% -------------------------------------------------------------------------

LANDSAT_TM = 0;
SPOT_PANCHROMATIC = 1;
sensor = 0;
image_path = 'subtm91.tif';
image = imread( image_path );

COLLECTION = 0;
names = 0;
colors = 0;


while 1
    
    clc, close all;
    
    disp('IMAGE PROCESSING - GEOINFORMAZIONE');
    disp(' This program implements some image processing techniques.');
    disp(' Operations below can be performed by typing their code.');
    disp(' Use the operation 1 to chose the image. It will be possible');
    disp(' at any time to repeat operation 1, to change target image.');
    disp('  OPERATIONS:');
    temp = sprintf(' (1)  SELECT IMAGE BY PATH [ current : %s ]', image_path);
    disp( temp );
    disp(' (2)  VISUALIZE IMAGE BANDS ');
    disp(' (3)  COLOR COMPOSITES');
    disp(' (4)  HISTOGRAM EQUALIZATION (BY BAND)');
    disp(' (5)  LINEAR STRETCHING (BY BAND)');
    disp(' (6)  TCC LINEAR STRETCHING');
    disp(' (7)  FCC LINEAR STRETCHING');
    disp(' (8)  WATER MASK FROM SUBSET');
    disp(' (9)  MANUAL WATER MASK FROM LINE DN PROFILE');
    disp(' (10) THRESHOLD LINEAR STRETCHING (BY BAND)');
    disp(' (11) UNCALIBRATED RADIANCE VS WAVELENGTH');
    disp(' (12) SPECTRAL REFLECTANCE VS WAVELENGTH');
    disp(' (13) DENSITY SLICING ( set colormap through operation 11 or 12 )');
    disp(' (14) DENSITY SLICING BY NIR DN HISTOGRAM');
    disp(' (15) NDVI MAP');
    disp(' (16) NDVI MAPS COMPARISON');
    disp(' (17) CHANGE DETECTION');
    disp(' (18) SUBSET FROM TIFF IMAGE ');
    
    operation = input( ' Insert the operation code (0 to exit): ' );
    
    try
        
        switch operation

            case 1               % SELECT IMAGE BY PATH

                % This is the image path of the sample file, which is supposed 
                % to be into the same directory of this file (as all the other 
                % called functions).

                image_path = input(' Please, insert image path: ');

                try
                    image = imread( image_path );
                catch ERR
                    disp(' Sorry, you have probably typed a wrong path...');
                    image_path = 'Romo.tif';
                    done = input(' Tap to proceed... ');
                    continue
                end

                s = input(' Insert sensor (type 0 for LANDSAT_TM, 1 for SPOT_PANCHROMATIC)');

                switch s
                    case 0
                        sensor = LANDSAT_TM;
                        done = input(' LANDSAT_TM image selected. tap to proceed... ');
                    case 1
                        sensor = SPOT_PANCHROMATIC;
                        done = input(' SPOT_PANCHROMATIC image selected. tap to proceed... ');
                    otherwise
                        done = input(' LANDSAT_TM image selected as default. tap to proceed... ');
                end


            case 2               % VISUALIZE IMAGE BANDS

                % Visualize a single/multiple band/s data in grey scale image.
                % The following function plots the histogram (PDF) of DNs 
                % frequencies next to the actual image.

                bands = input( '\n provide an array with the desired bands: ');

                if sensor == SPOT_PANCHROMATIC && bands ~= 1
                    disp(' SPOT PANCHROMATIC has only one band. it''ll be used for elaborations')
                    bands = 1;
                end

                try
                    image_bands( image, bands, sensor );
                catch ERR
                    disp(' Uncorrect input! To view multiple bands please use notation [ 1 2 ... n ]')
                end

                done = input(' Tap to proceed and close the current figure');


            case 3                % COLOR COMPOSITE

                if sensor == SPOT_PANCHROMATIC
                    disp(' Sorry, unable to perform color composites on PANCHROMATIC images.');
                    done = input(' Tap to proceed...');
                    continue
                end

                R = input(' Provide the R band number: ');
                G = input(' Provide the G band number: ');
                B = input(' Provide the B band number: ');

                % The following function can be used with further optional 
                % parameters, in order to obtain a true/false-color-composite  
                % resulting image by combining bands of user's choice.  
                % The results can be plotted in a complete way by passing the 
                % 5th parameter as 'multiple'.

                try
                    color_composite( image, R, G, B, 'multiple' );
                catch ERR
                    disp(' Sorry, you probably typed invalid input. Please, retry.');
                end

                done = input(' Tap to proceed and close the current figure');


            case 4               % HISTOGRAM EQUALIZATION

                % The following function performes the technique of histogram 
                % equalization, to enhance contrast of a not really readble  
                % image (in terms of visual effect). 

                band = input( ' Provide a specific band: ');

                if sensor == SPOT_PANCHROMATIC
                    disp(' SPOT PANCHROMATIC has only one band. it''ll be used for elaborations.')
                    disp(' Please wait... this procedure could take a bunch of seconds...')
                    band = 1;
                end

                try
                    histogram_equalization( image, band, sensor );
                catch ERR
                    disp(' Sorry, you probably typed invalid input. Please, retry.');
                end

                done = input(' Tap to proceed and close the current figure');


            case 5               % LINEAR STRETCHING

                % The function below performs the linear stretching procedure, 
                % to enhance contrast on input image at the given band.

                band = input( '\n provide a specific band: ');

                if sensor == SPOT_PANCHROMATIC
                    disp(' SPOT PANCHROMATIC has only one band. it''ll be used for elaborations.')
                    disp(' Please wait... this procedure could take a bunch of seconds...')
                    band = 1;
                end

                try
                    linear_stretching( image, band, 'yesplot', sensor );
                catch ERR
                    disp(' Sorry, you probably typed invalid input. Please, retry.');
                end

                done = input(' Tap to proceed and close the current figure');


            case 6               % TCC LINEAR STRETCHING

                % The following code block represents an application 
                % of the linear stretching on an TCC image.

                if sensor == SPOT_PANCHROMATIC
                    disp(' Sorry, unable to perform color composites on PANCHROMATIC images.');
                    done = input(' Tap to proceed...');
                    continue
                end

                disp(' Please wait... this procedure could take a bunch of seconds...')

                R_stretched = linear_stretching( image, 3, 'noplots', sensor);
                G_stretched = linear_stretching( image, 2, 'noplots', sensor );
                B_stretched = linear_stretching( image, 1, 'noplots', sensor );

                try
                    RGB = cat( 3, R_stretched, G_stretched, B_stretched );
                catch ERR
                    disp(' Sorry, you probably typed invalid input. Please, retry.');
                end

                figure( 'Name', 'TCC Stretched' );
                imshow( RGB );

                done = input(' Tap to proceed and close the current figure');


            case 7               % FCC LINEAR STRETCHING

                % The following code block represents an application 
                % of the linear stretching on an FCC image.

                if sensor == SPOT_PANCHROMATIC
                    disp(' Sorry, unable to perform color composites on PANCHROMATIC images.');
                    done = input(' Tap to proceed...');
                    continue
                end

                disp(' Please wait... this procedure could take a bunch of seconds...')

                R_stretched = linear_stretching( image, 4, 'noplots', sensor);
                G_stretched = linear_stretching( image, 2, 'noplots', sensor );
                B_stretched = linear_stretching( image, 1, 'noplots', sensor );

                try
                    FCC = cat( 3, R_stretched, G_stretched, B_stretched );
                catch ERR
                    disp(' Sorry, you probably typed invalid input. Please, retry.');
                end

                figure( 'Name', 'FCC Stretched' );
                imshow( FCC );

                done = input(' Tap to proceed and close the current figure');


            case 8                  % WATER MASK

                if sensor == SPOT_PANCHROMATIC
                    disp(' Sorry, unable to perform water masks with PANCHROMATIC images.');
                    done = input(' Tap to proceed...');
                    continue
                end

                try
                    water_mask( image, 4, sensor );
                catch ERR
                    disp(' Sorry, you probably typed invalid input. Please, retry.');
                end

                done = input(' Tap to proceed and close the current figure');


            case 9                  % MANUAL WATER MASK

                if sensor == SPOT_PANCHROMATIC
                    manual_water_mask( image, 1, sensor );               
                end

                if sensor == LANDSAT_TM                
                    band = input( '\n provide a specific band: ');
                    try
                        manual_water_mask( image, band, sensor ); 
                    catch ERR
                        disp(' Sorry, you may have typed a not valid band index');
                    end

                end

                done = input(' Tap to proceed and close the current figure');


            case 10             % THRESHOLD LINEAR STRETCHING

                % The function below performs the linear stretching procedure, 
                % to enhance contrast on input image at the given band.

                band = input( '\n provide a specific band: ');
                minDN = input(' Please, provide the MINIMUM DN value to perform histogram truncation: ');
                maxDN = input(' Please, provide the MAXIMUM DN value to perform histogram truncation: ');
                if sensor == SPOT_PANCHROMATIC
                    disp(' SPOT PANCHROMATIC has only one band. it''ll be used for elaborations.')
                    disp(' Please wait... this procedure could take a bunch of seconds...')
                    band = 1;
                end

                try
                    threshold_linear_stretching( image, band, 'yesplot', sensor, minDN, maxDN );
                catch ERR
                    disp(' Sorry, you probably typed invalid input. Please, retry.');
                end

                done = input(' Tap to proceed and close the current figure');
               
                
            case 11            % UNCALIBRATED RADIANCES

                % This procedure plots the uncalibrated radiance curves of 
                % every crop specified in variable COLLECTION. If crops are
                % already set up you can chose either to reuse the crop 
                % collection or set up another one.
                
                if sensor == SPOT_PANCHROMATIC
                    disp(' SPOT PANCHROMATIC images cannot be used for spectral signatures.')
                    done = input(' Tap to proceed...');
                    continue
                end
                
                var = 1;
                
                if COLLECTION ~= 0
                    var = input(' Do you want to use the latest crop collection? ( 0 for yes, 1 for no ): ');
                end
                
                if var == 0                   
                    uncalibrated_radiances( COLLECTION, names, colors );                 
                    done = input(' Tap to proceed and close the current figure');
                    continue
                end              
                
                try     
                    crops = input( ' Please, specify the number of crops: ' );
                    [ COLLECTION, names, colors ] = collect_crops( image, sensor, crops );
                catch ERR
                    disp(' Sorry, you probably typed invalid input. Please, retry.');
                end
                              
                uncalibrated_radiances( COLLECTION, names, colors );               

                done = input(' Tap to proceed and close the current figure');
 
              
                
            case 12            % SPECTRAL REFLECTANCE CURVES

                % This procedure plots the spectral signatures of every
                % crop specified in variable COLLECTION. If crops are
                % already set up you can chose either to reuse the crop 
                % collection or set up another one.
                
                if sensor == SPOT_PANCHROMATIC
                    disp(' SPOT PANCHROMATIC images cannot be used for spectral signatures.')
                    done = input(' Tap to proceed...');
                    continue
                end
                
                var = 1;
    
                if COLLECTION ~= 0
                    var = input(' Do you want to use the latest crop collection? ( 0 for yes, 1 for no ): ');
                end
                
                if var == 0                   
                    spectral_reflectance_curves( COLLECTION, names, colors );               
                    done = input(' Tap to proceed and close the current figure');
                    continue
                end
                
                try  
                    crops = input( ' Please, specify the number of crops: ' );
                    [ COLLECTION, names, colors ] = collect_crops( image, sensor, crops );
                catch ERR
                    disp(' Sorry, you probably typed invalid input. Please, retry.');
                end
                              
                spectral_reflectance_curves( COLLECTION, names, colors );               

                done = input(' Tap to proceed and close the current figure');
                
                
            case 13                 % DENSITY SLICING
                
                % This procedure is used to apply a color map on the
                % selected image. Before using this operation, it is
                % necessary to compute uncalibrated radiance curves for the
                % image, by typing operation 11 (or 12). Density slicing
                % will be performed with settings chosen for the latter
                % operations.
                
                if sensor == SPOT_PANCHROMATIC
                    disp(' SPOT PANCHROMATIC images cannot be used for spectral signatures.')
                    done = input(' Tap to proceed...');
                    continue
                end
                
                if COLLECTION ~= 0
                    msg = sprintf( ' Density Slicing will be performed on %s, band 4 (NIR)', image_path );
                    disp( msg );
                    disp( ' Color map refers to the latest spectral signatures computed.' );
                    disp( ' If you want to change colors and ranges, you should repeat operation 11 or 12.' );
                    disp( ' Tap to proceed.' );
                    density_slicing( image, COLLECTION, names, colors );
                
                else
                    disp( ' Sorry, you should chose your colors and settings through operation 11 or 12.' )
                end
                
                done = input(' Tap to proceed and close the current figure');
                
                
                
            case 14                 % DENSITY SLICING
                
                % This procedure is used to apply a color map on the
                % selected image. 
                
                if sensor == SPOT_PANCHROMATIC
                    disp(' SPOT PANCHROMATIC images cannot be used for spectral signatures.')
                    done = input(' Tap to proceed...');
                    continue
                end
                
                density_slicing_by_histo( image );
                
                done = input(' Tap to proceed and close the current figure');
          
                
                
            case 15                 % NDVI MAP
                
                % This procedure is used to generate an NDVI map on an 
                % input image 
                
                if sensor == SPOT_PANCHROMATIC
                    disp(' SPOT PANCHROMATIC images cannot be used.')
                    done = input(' Tap to proceed...');
                    continue
                end
                
                RS = remote_sensor( 0 );               
                ndvi_map( image , RS, 0 );
                
                done = input(' Tap to proceed and close the current figure');
                
                
            case 16                 % NDVI MAPS COMPARISON
                
                % This procedure is used to generate 2 NDVI map on  
                % input images, and compare them on the same figure. 
                
                if sensor == SPOT_PANCHROMATIC
                    disp(' SPOT PANCHROMATIC images cannot be used.')
                    done = input(' Tap to proceed...');
                    continue
                end
                
                impath1 = input(' Please, type the 1st image''s path: ');
                impath2 = input(' Please, type the 2nd image''s path: ');
                
                RS = remote_sensor( 0 );               
                ndvi_comparison( impath1 , impath2, RS );
                
                done = input(' Tap to proceed and close the current figure');
           
            case 17                % CHANGE DETECTION
                 
                b = input(' Type 1 to specify images'' paths and json header files  |  Type 0 to use default images (Lefkas1994, Lefkas 2011):  ');
                
                if b == 1
                    impath1 = input(' Please, type the 1st image''s path: ');
                    impath2 = input(' Please, type the 2nd image''s path: ');
                    jsonhead1 = input(' Please, type the 1st image''s json header''s path: ');
                    jsonhead2 = input(' Please, type the 2nd image''s json header''s path: ');                 
                    cdprocedure( impath1, impath2, jsonhead1, jsonhead2 );
                
                else
                    cdprocedure( 'lefkas94.tif', 'lefkas11.tif', 'L1lefkasTM1994/lefkas94_json.json', 'L1lefkasTM2011/lefkas11_json.json' );
                end
                              
                done = input(' Tap to proceed and close the current figure');

            case 18                % SUBSET FROM TIFF IMAGE
                 
                subsetname = input( ' Please, type the name of the subset you are going to create: ' );
                subset = sprintf( '%s.tif', subsetname );
                subset_from_image( image, subset );
                              
                done = input(' Tap to proceed and close the current figure');


            otherwise
                clear all; clc;
                return

        end
        
    catch ERR
        disp(ERR);
    end
    
end

