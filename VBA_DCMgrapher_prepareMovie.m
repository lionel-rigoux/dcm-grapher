function mov=VBA_DCMgrapher_prepareMovie(posterior,out)


try
    inF = out.options.inF{1};
catch
    inF = out.options.inF;
end
n_nodes = numel(inF.n5);

%% ________________________________________________________________________
%  load DCM matrices
A = inF.A;
B = inF.B;
C = inF.C;
D = inF.D;


first_order = A~= 0 ;
for i=1:numel(B)
    first_order = max(first_order,B{i}~= 0);
end
first_order = first_order - diag(diag(first_order));
for i=1:numel(D)
    second_order{i} = D{i}~= 0;
    second_order{i} = second_order{i} ;% - diag(diag(second_order{i}));
end

mov.structure.first_order = first_order ;
mov.structure.second_order = second_order  ;

%% ________________________________________________________________________
%  weighted matrices

A(A>0) = posterior.muTheta(inF.indA);
A = A - exp(posterior.muTheta(inF.indself))*eye(n_nodes) ; 

for i=1:numel(B)
    B{i}(B{i}>0) = posterior.muTheta(inF.indB{i});
end
C(C>0) = posterior.muTheta(inF.indC);
for i=1:numel(D)
    D{i}(D{i}>0) = posterior.muTheta(inF.indD{i});
end

quad = any(any([D{:}]));

%% ________________________________________________________________________
%  subsampling

n_t = size(out.y,2);

% find the a microtime < 100ms which divides the TR
timestep  = out.options.decim*inF.deltat;
spl = ceil(timestep/0.100) ; % resample at 10Hz
microt = timestep / spl;


% resample inputs
if out.options.microU == 0
    spl_u = spl;
else
    
    error('micro time not yet supported');
end
for iu = 1:size(out.u,1)
    u(iu,:) = reshape(repmat(out.u(iu,:),spl_u,1),1,spl_u*n_t);
end

% resample states
T = n_t*timestep;
timeline = 0:microt:T;
state_idx = inF.n5;
for i=1:numel(state_idx)
    states(i,:) = interp1(0:timestep:T,[posterior.muX0(state_idx(i)) out.suffStat.muX(state_idx(i),:)],timeline,'linear');
end
resp_idx = out.options.sources(2).out;
for i=1:numel(resp_idx)
    resps(i,:) = interp1(0:timestep:T,[out.suffStat.gx(resp_idx(i),1) out.suffStat.gx(resp_idx(i),:)],timeline,'linear');
end
% [states,obs,timeline] = VBA_microTime(posterior,out.u,out);


n_t = numel(timeline)-1;%size(u,2);


%% ________________________________________________________________________
%  storage 
max_con2 = 0;
for t=1:n_t
    
    mov.frame(t).time = timeline(t);%n_t*microt; timeline(t);
    %
    mov.frame(t).input = u(:,t);
    
    %
    mov.frame(t).activity  = states(:,t);
    mov.frame(t).resp  = resps(:,t);
    
    state_mat = repmat(states(:,t)',n_nodes,1);
    
    %
    connectivity1 = A .* state_mat ;
    for i=1:numel(B)
        connectivity1 = connectivity1 + u(i,t)*B{i}.*state_mat;
    end
            mov.frame(t).connectivity1 = connectivity1;

            
    self = diag(connectivity1);
    
    if quad
        for i=1:numel(D)
            connectivity2{i} = states(i,t)*D{i}.*state_mat;
            self = self + diag(connectivity2{i});
        end
        
        
        mov.frame(t).connectivity2 = connectivity2;
        max_con2 = max(max_con2,max(max(abs([connectivity2{:}]))));
        
    else
         mov.frame(t).connectivity2=[];
    end
    

    mov.frame(t).self = self;
end


%% ________________________________________________________________________
%  normalization

max_act = max(max(abs([mov.frame.activity]')));%10*std([mov.frame.activity]')'; % 
max_con = max(max(abs([mov.frame.connectivity1]')));%10*std(vec([mov.frame.connectivity1])); % 
if quad
%     max_con = max(max_con, max_con2);
end

for t=1:n_t
    mov.frame(t).activity = mov.frame(t).activity./max_act;
    mov.frame(t).connectivity1 = mov.frame(t).connectivity1 / max_con;
    mov.frame(t).self = mov.frame(t).self / max_con;
    if quad
        for i=1:n_nodes
            mov.frame(t).connectivity2{i} = mov.frame(t).connectivity2{i} / max_con2;
        end
    end
end


end

