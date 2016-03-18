function movie_vid=play_DCMmovie(movie,pos,labels)

% set(0,'DefaultFigureWindowStyle','undocked')
% close all
% figure
%% get structure
 
n_nodes = numel(movie(1).activity) ;

for i=1:n_nodes
    nodes(i).id = i;
    if ~isempty(pos)
        nodes(i).pos = pos(i,:);
    else
        thet = (2*pi) * i/n_nodes ;
        nodes(i).pos = 300*[cos(thet) sin(thet)] ;
    end
    if ~isempty(labels)
        nodes(i).lbl = labels{i};
    else
        nodes(i).lbl = num2str(i) ;
    end
end


%% init movie


%% loop
% get timeseries
colormap(flipud(cbrewer('div','RdBu',100)));

for t=1:numel(movie)

clf
caxis([-1 1]);


for i=1:n_nodes
    for j=1:n_nodes
        if movie(t).pattern(j,i)
        draw_connect(nodes(i),nodes(j),movie(t).connectivity(j,i));
        hold on
        end
    end
end

% freezeColors
% 
% colormap(flipud(cbrewer('div','RdBu',11)));
% caxis([-.2 .2]);

for i=1:n_nodes
    draw_node(nodes(i),movie(t).activity(i));  
     hold on
end


xlim([-250 250])
ylim([-200 200])
set(gca,'box','off','xcolor','w','ycolor','w')
set(gcf, 'color', [1 1 1])
drawnow
% pause()
movie_vid(t)=getframe;

% unfreezeColors
end

% for h=hs
%     ax = get(h,'CurrentAxes');
%     caxis(ax,[-w_lim w_lim]);
% end
    

end

function draw_node(node,color)
    th = 0:pi/50:2*pi;
    r=30;
    xunit = r * cos(th) + node.pos(1);
    yunit = r * sin(th) + node.pos(2);
    cs = repmat(color,1,numel(xunit));
    patch(xunit,yunit,cs,'FaceColor','flat','FaceVertexCData',cs','CDataMapping','scaled','EdgeColor',[.4 .4 .4],'LineWidth',2);%,,'FaceVertexCData',weight,

% 	plot(xunit, yunit,'Linewidth',3,'LineColor',[.1 .1 .1]);
    text(node.pos(1),node.pos(2),node.lbl,'HorizontalAlignment','center','Color',[0 0 0],'FontWeight','bold','FontSize',8);
end    

function draw_connect(node_A,node_B,weight)
    vector = node_B.pos-node_A.pos;
        % move a bit to avoid feedback overlap

    thet = atan2(vector(2),vector(1));
    thet = thet-(pi/2);
    offset = 5*[cos(thet), sin(thet)];
    
    xs = [node_A.pos(1) node_B.pos(1)] + offset(1);
    ys = [node_A.pos(2) node_B.pos(2)] + offset(2);
    
    zs = [0 0];
    cs = [weight weight];
    patch(xs,ys,weight,'FaceColor','flat','FaceVertexCData',cs','CDataMapping','scaled','EdgeColor','flat','LineWidth',3);%,,'FaceVertexCData',weight,
end

function conditions=get_conditions(u)
    splitted=mat2cell(u,size(u,1),ones(1,size(u,2)));
    conditions_str = cellfun(@(c) mat2str(c'), splitted,'UniformOutput',false);
    conditions_str = unique(conditions_str);
    conditions = cellfun(@(c) eval(c)', conditions_str,'UniformOutput',false);
end


