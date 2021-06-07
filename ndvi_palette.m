function [color_palette] = ndvi_palette( id )
%   NDVI_PALETTE 
%   This function produces color palettes to be applied on greyscale NDVI
%   images, as a gradient-density slicing technique.

switch id
    
    case 0
        
        R = 0;    G = 0;      B = 30;       % BLUE   (water bodies)
        for i = 1 : 1 : 119
            B = B + 1.3;
            G = G + 0.8;
            palette( i, : ) = [ R/255 G/255 B/255 ]; 
        end
        
        R = 150;    G = 20;      B = 0;    % RED  (bare soil)
        for i = 120 : 1 : 141
            R = R + 1.2;
            G = G + 1;
            palette( i, : ) = [ R/255 G/255 B/255 ]; 
        end
        
        G = R - 50;      B = 0;            % BROWN (absence of vegetation)
        for i = 142 : 1 : 154
            R = R + 1.2;
            G = G + 1;
            palette( i, : ) = [ R/255 G/255 B/255 ]; 
        end
        
        R = 170;    G = R;      B = 0;      % YELLOW (weak vegetation)
        for i = 155 : 1 : 184
            R = R + 1;
            G = G + 1.5;
            palette( i, : ) = [ R/255 G/255 B/255 ]; 
        end
        
        R = 0;    G = 201;                  % GREEN  (healty vegetation)
        for i = 185 : 1 : 256           
            G = G - 1.8;
            palette( i, : ) = [ R/255 G/255 B/255 ];
        end
        
        
    otherwise
        return
end

color_palette = palette;
        
end

