classdef remote_sensor  % REMOTE SENSOR 
   
   properties
      % Mission Properties
      id                % mission identifier
      mission           % mission name
      bands             % bands array
      wavelengths       % wavelengths array
      % Calibration Parameters
      gains             % gain per band
      offsets           % offset per band
      irradiance        % irradiance per band
   end
   
   methods
      
      function obj = remote_sensor( id )         % Constructor
        obj.id = id;        
        switch  id       
            case 0
                obj.mission = 'Landsat Thematic Mapper';
                obj.bands = [ 1 2 3 4 5 6 7 ];
                obj.wavelengths = [ 0.485 0.56 0.66 0.83 1.65 11.45 2.215 ];
                obj.gains = [ 0.6713 1.322 1.043 0.876 0.12 1.0 0.065 ];
                obj.offsets = [ -2.19 -4.16 -2.21 -2.39 -0.49 0.0 -0.22 ];
                obj.irradiance = [ 1983 1795 1539 1028 225.7 1.0 83.49 ];               
            case 1
                obj.mission = 'Spot Panchromatic';
                obj.bands = 1;
                obj.gains = 1.0;
                obj.offsets = 0.0;
                obj.irradiance = 1.0;                
            otherwise              
                ME = MException('Exception in class remote_sensor: Not valid input in constructor ');
                throw(ME);
       end
      end
      
      function obj = set_mission( obj, mission_name )
         obj.mission = mission_name;
      end
      
   end
end