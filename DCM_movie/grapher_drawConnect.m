function h=grapher_drawConnect(node_A,node_B,weight)
    vector = node_B.pos-node_A.pos;
    
    % move a bit to avoid feedback overlap
    thet = atan2(vector(2),vector(1));
    thet = thet-(pi/2);
    offset = 10*[cos(thet), sin(thet)];
    
    
    
    xs = [node_A.pos(1) node_B.pos(1)] + offset(1);
    ys = [node_A.pos(2) node_B.pos(2)] + offset(2);
    zs = -2*eps*[1 1];
    
    cs = [weight weight];
    h=patch(xs,ys,zs,weight,'FaceColor','flat','FaceVertexCData',cs','CDataMapping','scaled','EdgeColor','flat','LineWidth',3,'LineSmoothing','on');

    
    vector2 = [xs(2) ys(2)] - [xs(1) ys(1)];
    vector2 = vector2/norm(vector2);
    
    th = 0:pi/30:2*pi;
    r=8;
    xunit = r * cos(th) + xs(2) - 45*vector2(1);
    yunit = r * sin(th) + ys(2) - 45*vector2(2);
    zunit = -eps*ones(1,numel(th));
    cs = repmat(weight,1,numel(th));
    h2=patch(xunit,yunit,zunit,cs,'FaceColor','flat','FaceVertexCData',cs','CDataMapping','scaled','EdgeColor','flat','LineWidth',.01,'LineSmoothing','on');%,,'FaceVertexCData',weight,


end