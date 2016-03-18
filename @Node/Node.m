classdef Node < handle
    
   properties (SetAccess = private)
      x = NaN ; 
      y = NaN ;
      
      activity = 0 ;
   end
   
   properties (Hidden)
      coreHandle = false ;
   end
  
  
   methods
      function obj = Node(x,y)
           if nargin < 2 
               error('Node should have at leat two coordinates') ;
           end
           
           obj.x = x ;
           obj.y = y ;
           
           
       end
       
      function  draw(obj,haxes,level)
         if obj.coreHandle
             disp('already drawn')
         else
             obj.coreHandle = scatter(obj.x,obj.y,'fill','CData',obj.activity);
         end
      end
   end
   
   
end