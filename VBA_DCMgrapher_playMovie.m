function VBA_DCMgrapher_playMovie(mov,nodes,filename)

% set(0,'DefaultFigureWindowStyle','undocked')
close all
% figure

saveVideo = (nargin == 3);
    
%% get structure

n_nodes = numel(nodes) ;

%% init mov

% hold on

fig=VBA_DCMgrapher_init(nodes,mov.structure.first_order,mov.structure.second_order) ;

set(fig,'Position',[560 300 376 376],...
    'name','DCM Player',...
    'MenuBar','none','NumberTitle','off',...
    'WindowStyle','normal','DockControls','off');
set(fig,'NextPlot','replacechildren')

colormap(flipud(cbrewer('div','RdBu',100)));

drawnow

% ui
n_t = length(mov.frame);

%GUI

sli=uicontrol('Style','slider',...
    'Min' ,1,'Max',n_t, ...
    'Position',[30,10,445,15], ...
    'Value', 1,...
    'SliderStep',[1/n_t 10/n_t], ...
    'BackgroundColor',[1 1 1],...
    'CallBack', @slider_Callback,...
    'BusyAction','queue');

but=uicontrol('Style','togglebutton',...
    'Position',[10,10,16,16],...
    'Value',0,...
    'Min',0,'Max',1,...
    'CallBack', @play,...
    'BackgroundColor',[.5 0 0]);

infos=uicontrol('Style','text',...
    'Position',[10,30,300,16],...
    'String','',...
    'HorizontalAlignment','left',...
    'BackgroundColor',[1 1 1]);

timer=uicontrol('Style','text',...
    'Position',[317,30,155,16],...
    'String','0 s (t=00000)',...
    'HorizontalAlignment','right',...
    'BackgroundColor',[1 1 1]);

setappdata(fig,'mov',mov);
setappdata(fig,'nodes',nodes);
setappdata(fig,'sli',sli);
setappdata(fig,'but',but);
setappdata(fig,'infos',infos);
setappdata(fig,'timer',timer);
setappdata(fig,'saveVideo',saveVideo);

set(fig, 'DeleteFcn', @onClose);

if saveVideo
    
    writerObj = VideoWriter([filename '.avi']);
    open(writerObj);
     setappdata(fig,'recorder',writerObj);

     set(fig,'NextPlot','replacechildren');
     set(sli,'Visible','off');
     set(but,'Visible','off');
     set(timer,'Visible','off');
     set(infos,'Visible','off');     
     remotePlay
     
end

% close gcf

end

function slider_Callback(hObject, eventdata, handles)
t=round(get(hObject,'Value'));
update_dcm(t)
update_gui(t)
end

function play(hObject, eventdata, handles)
mov = getappdata(gcf,'mov');
sli = getappdata(gcf,'sli');

but = getappdata(gcf,'but');
start = round(get(sli,'Value'));
set(but,'BackgroundColor',[0 .5 0]);

saveVideo=getappdata(gcf,'saveVideo');
if saveVideo
    writerObj = getappdata(gcf,'recorder');
end

for t=start:numel(mov.frame)
    
    try
        update_dcm(t);
        update_gui(t);
        drawnow;
        if saveVideo 
             writeVideo(writerObj,getframe);
        end
    if get(but,'Value')==0
        set(but,'BackgroundColor',[.5 0 0]);
        break
    end
    catch
        break
    end
    
    
end


end

function update_dcm(t)
mov = getappdata(gcf,'mov');
VBA_DCMgrapher_updatenodes(gcf,mov.frame(t).activity,mov.frame(t).self);
VBA_DCMgrapher_updateconnect(gcf,mov.frame(t).connectivity1,mov.frame(t).connectivity2);
end

function update_gui(t)
sli = getappdata(gcf,'sli');
infos = getappdata(gcf,'infos');
timer = getappdata(gcf,'timer');
mov = getappdata(gcf,'mov');

set(sli,'Value',t);
set(timer,'String',sprintf('%.0f s (t=%05d)',mov.frame(t).time,t));
set(infos,'String',sprintf('Inputs = |%s',sprintf(' %2.2f |',mov.frame(t).input)));
end

function remotePlay()
    but = getappdata(gcf,'but');
    set(but,'Value',1);
    play(but,[],[]);
end

function remoteStop()
    but = getappdata(gcf,'but');
    set(but,'Value',0);
end

function onClose(varargin)
    remoteStop()
    if getappdata(gcf,'saveVideo')
        writerObj = getappdata(gcf,'recorder');
        close(writerObj);
    end
end