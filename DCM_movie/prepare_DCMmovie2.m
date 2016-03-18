function movie=prepare_DCMmovie2(posterior,out)



%% loop
% get timeseries
[XS,dfdx,n_t]=simulate_micro_u(out,posterior);

nodes_idx = out.options.inF.n5;
n_nodes = numel(nodes_idx);
inF = out.options.inF;

parfor t=1:n_t
   
movie(t).activity  = XS(nodes_idx,t);
connectivity = dfdx{t} / inF.deltat;
connectivity = connectivity(nodes_idx,nodes_idx);

for i=1:n_nodes
    connectivity(i,:) = connectivity(i,:) .* XS(nodes_idx,t)';
end
movie(t).connectivity = connectivity -  diag(diag(connectivity));

movie(t).pattern = get_pattern(out);

end

  % normalization
  max_act = max(max(abs([movie.activity])));
  max_con = max(max(abs([movie.connectivity])));
  
  parfor t=1:n_t
      movie(t).activity = movie(t).activity ./ max_act;
      movie(t).connectivity = movie(t).connectivity ./ max_con;
  end
      

end

function [XS,dfdx,n_t]=simulate_micro_u(out,posterior)

    n_t = out.dim.n_t*out.options.decim;
    Theta = posterior.muTheta;
    if out.options.microU
    	US = out.u;
    else
        for iu=1:out.dim.u
            US(iu,:) = vec(repmat(out.u(iu,:),out.options.decim,1))' ;
        end
    end  
    
    inF = out.options.inF;
    
    X0 = posterior.muX0;
    XS = zeros(numel(X0),n_t);
    XS(:,1) = feval(out.options.f_fname,X0,Theta,US(:,1),inF);
    
    for t=1:n_t
        [XS(:,t+1),dfdx{t},~] = feval(out.options.f_fname,XS(:,t),Theta,US(:,t),inF);
    end
    
end

function [pattern]=get_pattern(out)
    inF = out.options.inF;
    n_x = numel(inF.n5);
    n_u = out.dim.u;
    
    pattern = inF.A > 0;
    
    for i=1:n_u
        pattern = pattern | (inF.B{i}>0);
    end
    for i=1:n_x
        pattern = pattern | (inF.D{i}>0);
    end
    
end