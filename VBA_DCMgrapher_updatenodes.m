function VBA_DCMgrapher_updatenodes(f,activity,selfactivity)

    h_act = getappdata(f,'nodes_act');
    h_self = getappdata(f,'nodes_self');
    
    % # color nodes 
    set(h_self,'CData',selfactivity(:)); 
    set(h_act,'CData', activity(:)); 

end