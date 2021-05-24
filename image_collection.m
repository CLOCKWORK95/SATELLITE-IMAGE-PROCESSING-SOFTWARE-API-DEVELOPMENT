classdef image_collection < handle               % IMAGE COLLECTION 
    
    properties
        counter     % number of images in this data structure
        images      % cell array of images (BSQ)
        stats       % cell array of images' statistics (mean, stdev)
        RS          % remote sensor code (0 for Landsat, 1 for Spot)    
        
    end
    
    methods
        
        function obj = image_collection( new_image, sensor )
            %IMG_LINKED_LIST Construct an instance of this class
            %   Detailed explanation goes here
            obj.RS = remote_sensor( sensor );
            obj.counter = 1;
            obj.images{ 1 } = new_image;
            obj.update_stats( new_image );        
        end
        
        function obj = append( obj, next_image )
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            obj.counter = obj.counter + 1;
            obj.images{ length(obj.images) + 1 } = next_image;
            obj.update_stats( next_image );           
        end
        
        function ret = pop( obj )
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
           ret = obj.images{ length(obj.images) };
           obj.images{ length(obj.images) } = [];
        end
        
        function obj = update_stats( obj, image )
            dimensions = size( image );            
            bands = dimensions(3);
            b = 0;
            if bands == 7
                bands == 6;
                b = 1;
            end
            for j = 1 : 1 : bands
                
                if b == 1 && j == 6
                    [ mean, mode, stdev ] = image_statistics( image, j + 1 );
                    temp = [ mean, stdev ];
                    obj.stats{ obj.counter, j } = temp;
                    
                else
                    [ mean, mode, stdev ] = image_statistics( image, j );
                    temp = [ mean, stdev ];
                    obj.stats{ obj.counter, j } = temp;
                end
                
            end
        end
        
    end
end

