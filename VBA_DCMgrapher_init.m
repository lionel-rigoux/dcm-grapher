function f=VBA_DCMgrapher_init(nodes,node_matx_1,node_matx_2)

f=gcf; 
hold on

% coloring
colormap(my_dcm_colormap);
caxis([-1 1]);
set(gcf, 'color', [1 1 1])


% attach data
setappdata(f,'nodes',nodes);


% draw default

VBA_DCMgrapher_drawconnects(f,node_matx_1,node_matx_2)

VBA_DCMgrapher_drawnodes(f,true); 
VBA_DCMgrapher_drawnodes(f,false); 
VBA_DCMgrapher_resizenodes(f);
set(f,'ResizeFcn', @VBA_DCMgrapher_resize);

% axis
axis manual
axis off

xl = get(gca,'XLim');
yl = get(gca,'YLim');
ml = .5*max([(xl(2)-xl(1)) (yl(2)-yl(1))]);
set(gca,'XLim', mean(xl) + ml*[-1.3 1.3]);
set(gca,'YLim', mean(yl) + ml*[-1.3 1.3]);

set(gca,'Units','points')
set(f,'Units','points')


VBA_DCMgrapher_resize(f)


drawnow

end


function c=my_dcm_colormap()

REDS = [...
	156 031 032;
	217 033 038;
	232 039 037;
	238 083 035;
	246 140 050;
	252 195 057;
	252 239 075];

BLUES = [...
	063 088 158;
	063 101 162;
	072 141 193;
	091 187 225;
	136 204 225;
	156 218 230;
	173 223 230;
	208	236	238];	

BLUES = cbrewer('seq','Blues',50);
REDS = cbrewer('seq','Reds',50);

c = [flipud(BLUES) ; REDS ];
end