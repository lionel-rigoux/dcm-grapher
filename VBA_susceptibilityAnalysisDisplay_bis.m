function h=VBA_susceptibilityAnalysisDisplay_bis(results,norm,nodes,mov)


nResps = numel(results.contributions_w);

idxTheta = results.theta.idx;

cpt = 1;
% h=figure('Position',[50,50, 200*n_u, 200*nResps]);


for iObs = 1:nResps
    if nargin < 2 || isempty(norm) || strcmp(norm,'none')
        betas_obs = results.contributions_w{iObs};
        betas_obs=betas_obs/(2*mean(betas_obs(:)));
    elseif strcmp(norm,'output')
        betas_obs = results.contributions_normoutput{iObs};
    elseif strcmp(norm,'param')
        betas_obs = results.contributions_normparam{iObs};   
    else
        error('norm should be {''none'',''output'',''param''}');
    end
    n_u = size(betas_obs,2);%results.out.dim.u;

    cmax = max(betas_obs(:));
    if strcmp(norm,'param')
        cmax=1.5*cmax;
    end
    for iu = 1:n_u 
        
        betas = betas_obs(:,iu);
                
%         f=subplot(nResps,n_u,cpt);
%         f=subplot('Position',[(iu-1)/n_u (nResps-iObs)/nResps 1/n_u 1/nResps]);
        f=figure('Position',[100+1500*(iu-1)/n_u 100+1200*(nResps-iObs)/nResps 400 400]);
        if nargin == 1 
        %% simple bar graph
        bar(betas,'FaceColor',[53 91 135.5]/255); 
        hold on;

        ylabel(sprintf('response %d',iObs));
        xlabel('connection')
        set(gca,'XTickLabel',{results.theta.lbl{:}});
        title(sprintf('kernel u_%d',iu));
        
        else
        %% DCM display
        theta = zeros(1,results.out.dim.n_theta);
        theta(idxTheta) = betas;
        theta(theta<0) = 0;
%         theta = theta/max(theta);
        
        [A,B,C,D,dim] = VBA_dcmMatrices(results.out,theta);
        A = A - diag(diag(A));
        fo = A;
        nn = A~=0;
        for i=1:numel(B)
            fo = fo + B{i};
            nn = nn + B{i}~=0;
        end   
        fo = fo ./ nn;
        so = D;

        connect = [fo so{:}];

        fo = connect(:,1:dim.n);
        so = mat2cell(connect(:,(dim.n+1):end),dim.n,dim.n*ones(1,dim.n));
       
        VBA_DCMgrapher_init(nodes,mov.structure.first_order,mov.structure.second_order) ;

        VBA_DCMgrapher_updateconnect(f,fo,so);
        VBA_DCMgrapher_updatenodes(f,-.05*ones(dim.n,1),-.05*ones(dim.n,1));
        set(gca,'CLim',[-.01 .15])
        
        
        
        if strcmp(norm,'param')
            colormap([.99*[1 1 1]; cbrewer('seq','YlOrRd',100).^.7]);
        elseif strcmp(norm,'output')
            cm = [.95*[1 1 1]; (cbrewer('seq','YlGnBu',100)).^1];
            colormap(cm);
        else
            colormap(flipud(colormap('bone')));
        end

        
        end

        cpt = cpt +1;
    end
end

%% pretty colorbar
% hc = colorbar();
% set(hc,'Location','East');
% set(hc,'Ytick',[])
% pPlot = get(gca,'Position');
% set(hc,'Position',[pPlot(1)+.99*pPlot(3) .3*pPlot(4) .02*pPlot(3) .4*pPlot(4)])

end

    
function  colors=get_colors(betas)
    
    cmap = colormap('jet');
    range = linspace(min(betas),max(betas),size(cmap,1)) ;
    colors = interp1(range,cmap,betas);
    
 
end
 

