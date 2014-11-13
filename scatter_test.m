function scatter_test


% # attach the callback to figure 
f = figure('ResizeFcn', @setmarkersize,'PaperPositionMode','auto');
hold on
x=randn(1,5);
y=randn(1,5);

h = scatter(x,y,'fill');
h2 = scatter(x,y,'fill','MarkerFaceColor',[.2 .2 .2]);
h3 = scatter(x,y,'fill');

setappdata(f,'nodes_h',h);
setappdata(f,'nodes_h2',h2);
setappdata(f,'nodes_h3',h3);

setmarkersize(f)
end


function [ ] = setmarkersize(src,~)

    % # get position of the figure (pos = [x, y, width, height]) 
    pos = get(src, 'Position'); 
    fig_size = min(pos(3:4));
    % # get the scattergroup object 
%     h = get(get(src,'children'),'children'); 
    h = getappdata(src,'nodes_h');
    h2 = getappdata(src,'nodes_h2');
    h3 = getappdata(src,'nodes_h3');
    % # resize the marker
    relativesize = (fig_size/10);
    set(h,'SizeData',  (1.0*relativesize)^2); 
    set(h2,'SizeData', (0.85*relativesize)^2); 
    set(h3,'SizeData', (0.7*relativesize)^2); 
end


