function VBA_DCMgrapher_resizenodes(f,~)

  % # get position of the figure (pos = [x, y, width, height]) 
    pos = get(gca, 'Position'); 
    fig_size = min(pos(3:4));
    % # get the scattergroup object 

    h_act = getappdata(f,'nodes_act');
    h_bnd1 = getappdata(f,'nodes_bnd1');
    h_bnd2 = getappdata(f,'nodes_bnd2');
    h_self = getappdata(f,'nodes_self');
    
    % # resize the marker
    relativesize = (fig_size/5.5);
    
    set(h_bnd1,'SizeData', (1.00*relativesize)^2); 
    set(h_self,'SizeData', (0.98*relativesize)^2); 
    set(h_bnd2,'SizeData', (0.84*relativesize)^2); 
    set(h_act ,'SizeData', (0.82*relativesize)^2); 
    
end