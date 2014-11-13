function VBA_DCMgrapher_drawnodes(f,self)

% set(0,'CurrentFigure',f)
hold on

    nodes = getappdata(f,'nodes');


% extract node position
node_names = fieldnames(nodes);
node_number = numel(node_names);

x=zeros(node_number,1);
y=zeros(node_number,1);
c=zeros(node_number,1);

for iNode = 1:node_number
    
    pos = nodes.(node_names{iNode});
    x(iNode)=pos(1);
    y(iNode)=pos(2);
%     z(iNode)=pos(3);
end

% plot nodes
bcolor = get(f,'Color');

if self
h_bnd1    = scatter(x,y,'fill','MarkerFaceColor',bcolor);
h_self   = scatter(x,y,1,c,'fill');
setappdata(f,'nodes_bnd1',h_bnd1);
setappdata(f,'nodes_self',h_self);

else
h_bnd2    = scatter(x,y,'fill','MarkerFaceColor',bcolor);
h_act    = scatter(x,y,1,c,'fill');
setappdata(f,'nodes_bnd2',h_bnd2);
setappdata(f,'nodes_act',h_act);
end



end