function h=grapher_drawNode(node,color)
    th = 0:pi/15:2*pi;
    r=40;
    xunit = r * cos(th) + node.pos(1);
    yunit = r * sin(th) + node.pos(2);
    zunit = eps*ones(1,numel(th));
    cs = repmat(color,1,numel(th));
    h=patch(xunit,yunit,zunit,cs,'FaceColor','flat','FaceVertexCData',cs','CDataMapping','scaled','EdgeColor',[.6 .6 .6],'LineWidth',3,'LineSmoothing','on');%,,'FaceVertexCData',weight,
    text(node.pos(1),node.pos(2),eps,node.lbl,...
    'HorizontalAlignment','center','Color',[.2 .2 .2],...
    'FontWeight','bold','FontSize',8,...
    'FontName','Verdana');
end