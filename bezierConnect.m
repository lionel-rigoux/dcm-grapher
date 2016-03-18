function bezierConnect(points)
%
set(gca,'Units','Points');
p=get(gca,'Position');
width = min(p(3:4));
radius = width/10;

xL = xlim;
yL = ylim;

width = min([xL(2)-xL(1), yL(2)-yL(1)]);


center = [0 0 0];

EXCENTRICITY = .2;

n_points = size(points,1);
dim_points = size(points,2);

if dim_points == 2
    center(3)=0;
    points(:,3) = 0;
end


switch n_points
    
    
    case 1
        bary = points;
        direction = (bary-center)/norm((bary-center));
        middle = bary + .3*width*direction;
  
        
        inter = ([cos(pi/2) -sin(pi/2) 0; sin(pi/2) cos(pi/2) 0; 0 0 1]*([bary;middle] - repmat(mean([bary;middle]),2,1))' + repmat(mean([bary;middle]),2,1)')';
        
        [x,y,z] = bezier([points(1,:); inter(1,:);  middle; inter(2,:); points(1,:)]);

        
    case 2
    bary = mean([min(points) ; max(points)]); 
    rotation = cross(points(1,:)-center,points(2,:)-center);
    middle = bary + sign(rotation(3))* EXCENTRICITY*(bary-center) ;

    [x,y,z] = bezier([points(1,:); middle;points(2,:)]);
end
% 
% if nargin == 3
%     
% ps = [p1;p2];
% center2 = mean([min(ps) ; max(ps)]);
% center = CENTER_RATIO*center + (1-CENTER_RATIO)*center2;
% 
%     % TODO: mirror center wrt node axis depending on direction
%     c=cross([p1-center 0],[p2-center 0]);
%     if c(3)>0
%        point = .5*(p1 + p2);
%        symmetry = point - center ; 
%        center = point + symmetry;
%     end
%     
%     q = bezier([p1' center' p2']);
%     x=q(1,:)';
%     y=q(2,:)';
%     
% elseif nargin == 4
%     
%     ps = [p1;p2;p3];
% center2 = mean([min(ps) ; max(ps)]);
% center = CENTER_RATIO*center + (1-CENTER_RATIO)*center2;
%         
%     [x1, y1] = bezier(p1,center,p2,p3);
%     [x2, y2] = bezier(p2,center,p3);
%     
%     w =exp(-.8*(0:.03:1))';% 1-(0:.03:1)'; %
%     
%     x2 = x2.*w + (1-w).*x1;
%     y2 = y2.*w + (1-w).*y1;
%     
% %     x1 = x1.*w + (1-w).*x2;
% %     y1 = y1.*w + (1-w).*y2;
%     
%     x = [x1; flipud(x2)];
%     y=[y1; flipud(y2)];
%     
% end
% x = [x;nan];
% y=[y;nan];
hold on
if dim_points == 2
    plot(x,y,'LineWidth',4);
    scatter(points(:,1),points(:,2),radius^2,'fill');
else
    
plot3(x,y,z,'LineWidth',5,'LineSmoothing','on');
r=.08;
for i=1:n_points
    [xp,yp,zp] = sphere();
    surf(r*xp + points(i,1), r*yp + points(i,2), r*zp + points(i,3),'FaceColor',[.5 .5 .5],'EdgeColor','none','FaceLighting','phong') ;
    zlim([-.1 1.1]);
end

end
xlim([-1 2]);
ylim([-1 2]);
box on