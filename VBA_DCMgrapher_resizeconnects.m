function VBA_DCMgrapher_resizeconnects(f,~)

  % # get position of the figure (pos = [x, y, width, height]) 
    pos = get(gca, 'Position'); 
    fig_size = min(pos(3:4));
    % # get the scattergroup object 

    h = [getappdata(f,'connects1') getappdata(f,'connects2')];
    
    for i=1:numel(h)
        set(h(i),'LineWidth',fig_size/60);
    end
    

        h_end = getappdata(f,'connects_ep');
        relativesize = (fig_size/26);
        set(h_end,'SizeData', relativesize^2); 


end