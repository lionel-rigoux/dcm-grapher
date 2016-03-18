

% m1 = fullfile(spm('Dir'),'canonical','iskull_2562.surf.gii');

m2 = fullfile(spm('Dir'),'canonical','cortex_8196.surf.gii');

% m1 = gifti(m1) ;
m2 = gifti(m2) ;


vertices = m2.vertices ;

vertices = vertices(1:3:end,:);
vertices(:,2) = 5*vertices(:,2);
% [~,idx] = sort(vertices(:,2));

% vertices = vertices(idx,:);



% close all
% figure
% hold on

%       plot3(vertices(:,1),vertices(:,2),vertices(:,3),'.','Color',.8*[1 1 1])
    
nVertex = size(vertices,1);
idxCurr = 1;
done = [1] ;

for i=1:nVertex-1
    
    vertex = vertices(idxCurr,:) ;
    
    dist = sum((vertices - repmat(vertex,nVertex,1)).^2,2) ;
    
    [~,idxNext] = sort(dist) ;
    idxNext = setdiff(idxNext,done,'stable') ;
    idxNext = idxNext(1) ;
    
    
    nextVertex = vertices(idxNext,:);
    
    % zhole brain
%     hold off

    
    hold on
%     plot3(vertices([idxCurr],1),vertices([idxCurr],2),vertices([idxCurr],3), '.','Color',.1*[1 1 1])
    
    plot3(vertices([idxCurr idxNext],1),vertices([idxCurr idxNext],2),vertices([idxCurr idxNext],3), ...
        'Color',[1 0 0]);
    
    done(end+1) = idxNext ;
    idxCurr = idxNext ;
    
    drawnow
    
end

% 
% 
% n=1500
% plot3(vertices(1:end,1),vertices(1:end,2),vertices(1:end,3))
% 
% X = vertices(:,1) ;
% Y = vertices(:,2) ;
% Z = vertices(:,3) ;
% 
% xx = -69.5 : 71 ;
% zz = -71.5 : 87 ;
% Vq = interp2(X,Y,Z,xx,zz) ;
% 
% plot3(xx,Vq,zz)
