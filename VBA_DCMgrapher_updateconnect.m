function VBA_DCMgrapher_updateconnect(f,firstorder,secondorder)

    h_connects1 = getappdata(f,'connects1');
    connects1_idx = getappdata(f,'connects1_idx');
    h_connects2 = getappdata(f,'connects2');
    connects2_idx = getappdata(f,'connects2_idx');


    for i=1:numel(connects1_idx)
        set(h_connects1(i), 'CData', firstorder(connects1_idx(i))*[1 1] );
    end
    
    if ~isempty(secondorder)
    secondorder = [secondorder{:}];
      for i=1:numel(connects2_idx)
        set(h_connects2(i), 'CData', secondorder(connects2_idx(i))*[1 1] );
      end
    end

          connects_ep = getappdata(f,'connects_ep');
          
 cdata = [firstorder(connects1_idx) ;  secondorder(connects2_idx)];
 set(connects_ep,'CData',cdata);
end