function VBA_DCMgrapher_drawconnects(f,node_matx_1,node_matx_2)


nodes = getappdata(f,'nodes');
node_names = fieldnames(nodes);

n = size(node_matx_1);

eps = [];
%% first order
cpt = 1;
h1=[];
for i=1:n
    for j=setdiff(1:n,i)
        if node_matx_1(j,i) && i~=j
            [h1(cpt),eps(end+1,:)]=draw_single_connect(f,nodes.(node_names{i}),nodes.(node_names{j}));
            cpt=cpt+1;
        end
    end
end

% second order
cpt = 1;
h2=[];
for k=1:n
    for i=1:n
        for j=1:n;%setdiff(1:n,i)
            if node_matx_2{k}(j,i) 
                if i~=j
                    [h2(cpt),eps(end+1,:)]=draw_single_connect(f,nodes.(node_names{k}),nodes.(node_names{i}),nodes.(node_names{j}));
                else
                    [h2(cpt),eps(end+1,:)]=draw_single_connect(f,nodes.(node_names{k}),nodes.(node_names{i}));
                end
                cpt=cpt+1;
            end
        end
    end
end

% endpoints
c = zeros(size(eps,1),1);
h_ep   = scatter(eps(:,1),eps(:,2),1,c,'fill');

setappdata(f,'connects1',h1);
setappdata(f,'connects1_idx',find(node_matx_1));
setappdata(f,'connects2',h2);
setappdata(f,'connects2_idx',find([node_matx_2{:}]));
setappdata(f,'connects_ep',h_ep);


end

function [h,ep]=draw_single_connect(f,node1,node2,node3)

pos = get(f, 'Position');
fig_size = min(pos(3:4));
% # resize the marker
offset_factor = fig_size/100;


switch nargin
    case 3
        c_start = node1;
        c_end = node2;
        vector = c_end-c_start;
        thet = atan2(vector(2),vector(1));
        thet = thet-(pi/2);
        offset = offset_factor*[cos(thet), sin(thet)];
        
        x_connect = [c_start(1) c_end(1)] + offset(1);
        y_connect = [c_start(2) c_end(2)] + offset(2);
        
        vector2 = [x_connect(2) y_connect(2)] - [x_connect(1) y_connect(1)];
        vector2 = vector2/norm(vector2);
         
    case 4
        c_start = node2;
        c_end = node3;
        vector = c_end-c_start;
        thet = atan2(vector(2),vector(1));
        thet = thet-(pi/2);
        offset = offset_factor*[cos(thet), sin(thet)];
        x_connect_temp = [c_start(1) c_end(1)] + offset(1);
        y_connect_temp = [c_start(2) c_end(2)] + offset(2);
        
        c_start = node1;
        x_connect = [c_start(1) mean(x_connect_temp)];
        y_connect = [c_start(2) mean(y_connect_temp)];
        
        vector2 = [0 0];

        
end


ep = [x_connect(2), y_connect(2)] - (fig_size/16)*vector2;

h=patch(x_connect,y_connect,[0 0],'FaceColor','none','LineWidth',1,'EdgeColor','flat');%'CDataMapping','scaled',,'LineWidth',w);%,'LineSmoothing','on'

end