function SpotterUI()    
scr=get(0, 'ScreenSize');
pos=[scr(1:2)+scr(3:4).*0.01,scr(3:4).*0.95];
fig = figure( ...
        'Units', 'pixel', ...
        'Position', pos, ...
        'Name', 'Nucleus Spot Counter', ...
        'MenuBar', 'none', ...
        'Toolbar', 'none', ...
        'Color', get(0, 'defaultuicontrolbackgroundcolor'), ...
        'NumberTitle', 'off', ...
        'Resize', 'on', ...
        'Visible', 'off');
    
% save all gui object handles as guidata so they can be accessed later
handles = guidata(fig);
handles.f=fig;
% slice the display up into separate panels to organize the controls
height=0.6;
width=0.6;
    panelMessage= uipanel( ...
        'Parent', fig, ...
        'Units', 'normalized', ...
        'Position', [.01, 0.82, 0.45, 0.17], ...
        'Title', 'Message');
    
    panelImageStack = uipanel( ...
        'Parent', fig, ...
        'Units', 'normalized', ...
        'Position', [.01, 0.01, 0.55, 0.81], ...
        'Title', 'Image');
    
    panelMenu = uipanel( ...
        'Parent', fig, ...
        'Units', 'normalized', ...
        'Position', [.57, .49, .1, .50], ...
        'Title', 'Menu');
    
    panelNucleiList = uipanel( ...
        'Parent', fig, ...
        'Units', 'normalized', ...
        'Position', [.46, .82, .10, .17], ...
        'Title', 'Nuclei Selection');

    panelSettings = uipanel( ...
        'Parent', fig, ...
        'Units', 'normalized', ...
        'Position', [.57, .01, .1, .47], ...
        'Title', 'Settings');
    
    %panelMessage: message text
    handles.uiMessage = uicontrol(...
        'Parent', panelMessage, ...
        'Style', 'text', ...
        'Units', 'normalized', ...
        'Position', [.01, .01, .9, .9], ...
        'FontSize',16,...
        'String', 'Load an image stack or start calibration');
    
    % panelImageStack: axes for Image Stack
    handles.imStack = axes( ...
        'Parent', panelImageStack, ...
        'Units', 'normalized', ...
        'OuterPosition', [.0, .0, 1.0, 1.0], ...
        'Position', [.01, .01, .99, .98], ...
        'HandleVisibility', 'callback', ...
        'NextPlot', 'replacechildren');
    axis(handles.imStack,'off','image','ij','square');
   
    
    %panelSettings: buttons for settings and calibration
    %shift calibration for cy5
    handles.pathCalibs = cell(3, 1);
    uicontrol( ...
        'Parent', panelSettings, ...
        'Style','text', ...
        'Units', 'normalized', ...
        'Position', [.02, .92, .96, .06], ...
        'String', 'cy5 shift calibration', ...
        'HorizontalAlignment', 'left');
    handles.pathCalib{1} = uicontrol( ...
        'Parent', panelSettings, ...
        'Style', 'edit', ...
        'Units', 'normalized', ...
        'Position', [.02, .86, .96, .06], ...
        'String', '', ...
        'Callback', '', ...
        'BusyAction', 'cancel');
    c1.name='cy5_';
    c1.val=1;
    handles.calibCy5 = uicontrol( ...
        'Parent', panelSettings, ...
        'Style', 'pushbutton', ...
        'Units', 'normalized', ...
        'Position', [.02, .76, .49, .1], ...
        'String', 'New', ...
        'Callback', @newCalibration_Callback, ...
        'UserData',c1, ...
        'BusyAction', 'cancel');
    
    handles.loadCalibCy5 = uicontrol( ...
        'Parent', panelSettings, ...
        'Style', 'pushbutton', ...
        'Units', 'normalized', ...
        'Position', [.51, .76, .47, .1], ...
        'String', 'Load', ...
        'UserData',c1, ...
        'Callback', @loadCalibration_Callback, ...
        'BusyAction', 'cancel');
    
    %shift calibration for a594
    uicontrol( ...
        'Parent', panelSettings, ...
        'Style','text', ...
        'Units', 'normalized', ...
        'Position', [.02, .66, .96, .06], ...
        'String', 'a594 shift calibration', ...
        'HorizontalAlignment', 'left');
    handles.pathCalib{2} = uicontrol( ...
        'Parent', panelSettings, ...
        'Style', 'edit', ...
        'Units', 'normalized', ...
        'Position', [.02, .60, .96, .06], ...
        'String', '', ...
        'Callback', '', ...
        'BusyAction', 'cancel');
    c2.name='a594_';
    c2.val=2;
    handles.calibA594=uicontrol( ...
        'Parent', panelSettings, ...
        'Style', 'pushbutton', ...
        'Units', 'normalized', ...
        'Position', [.02, .50, .49, .1], ...
        'String', 'New', ...
        'Callback', @newCalibration_Callback, ...
        'UserData',c2,...
        'BusyAction', 'cancel');
    handles.loadCalibA594 = uicontrol( ...
        'Parent', panelSettings, ...
        'Style', 'pushbutton', ...
        'Units', 'normalized', ...
        'Position', [.51, .50, .47, .1], ...
        'String', 'Load', ...
        'UserData',c2, ...
        'Callback', @loadCalibration_Callback, ...
        'BusyAction', 'cancel');
    
    %shift calibration for tmr
    uicontrol( ...
        'Parent', panelSettings, ...
        'Style','text', ...
        'Units', 'normalized', ...
        'Position', [.02, .40, .96, .06], ...
        'String', 'tmr shift calibration', ...
        'HorizontalAlignment', 'left');
    handles.pathCalib{3} = uicontrol( ...
        'Parent', panelSettings, ...
        'Style', 'edit', ...
        'Units', 'normalized', ...
        'Position', [.02, .34, .96, .06], ...
        'String', '', ...
        'Callback', '', ...
        'BusyAction', 'cancel');
    c3.name='tmr_';
    c3.val=3;
    handles.calibTmr=uicontrol( ...
        'Parent', panelSettings, ...
        'Style', 'pushbutton', ...
        'Units', 'normalized', ...
        'Position', [.02, .24, .49, .1], ...
        'String', 'New', ...
        'Callback', @newCalibration_Callback, ...
        'UserData',c3,...
        'BusyAction', 'cancel');
    handles.loadCalibTmr = uicontrol( ...
        'Parent', panelSettings, ...
        'Style', 'pushbutton', ...
        'Units', 'normalized', ...
        'Position', [.51, .24, .47, .1], ...
        'String', 'Load', ...
        'UserData',c3, ...
        'Callback', @loadCalibration_Callback, ...
        'BusyAction', 'cancel');
    
    % panelMenu: buttons for all accessible actions
    uicontrol( ...
        'Parent', panelMenu, ...
        'Style', 'pushbutton', ...
        'Units', 'normalized', ...
        'Position', [.05, .85, .9, .1], ...
        'String', 'Open Stack Set', ...
        'Callback', @open_imStack_Callback, ...
        'BusyAction', 'cancel');
    
    handles.zProject = uicontrol( ...
        'Parent', panelMenu, ...
        'Style', 'pushbutton', ...
        'Units', 'normalized', ...
        'Position', [.05, .75, .9, .1], ...
        'String', 'Z-projection (max)', ...
        'Callback', @project_imStack_Callback, ...
        'BusyAction', 'cancel');
    
    handles.autoSegment = uicontrol( ...
        'Parent', panelMenu, ...
        'Style', 'pushbutton', ...
        'Units', 'normalized', ...
        'Position', [.05, .65, .9, .1], ...
        'String', 'Auto Segment', ...
        'Callback', @autoSegment_Callback, ...
        'BusyAction', 'cancel');
    
    handles.ChannelList = uicontrol( ...
        'Parent', panelMenu, ...
        'Style', 'listbox', ...
        'String', '', ...
        'Units','normalized',...
        'Position', [.05, .25, .9, .2], ...
        'Callback', '', ...
        'BusyAction', 'cancel', ...
        'HorizontalAlignment','center',...
        'FontName','courier',...
        'Max', 2, 'Min', 0); % this allows multiple selections
    
    handles.uiCount = uicontrol( ...
        'Parent', panelMenu, ...
        'Style', 'pushbutton', ...
        'Units', 'normalized', ...
        'Position', [.05, .15, .9, .1], ...
        'String', 'Count Dots', ...
        'Callback', '', ...
        'BusyAction', 'cancel');
    
    handles.uiSave = uicontrol( ...
        'Parent', panelMenu, ...
        'Style', 'pushbutton', ...
        'Units', 'normalized', ...
        'Position', [.05, .05, .9, .1], ...
        'String', 'Save Counts', ...
        'Callback', @saveCounts_Callback, ...
        'BusyAction', 'cancel');
    
    % panelNucleiList: listbox showing the available channels
    handles.NucleiList = uicontrol( ...
        'Parent', panelNucleiList, ...
        'Style', 'listbox', ...
        'String', '', ...
        'Units','normalized',...
        'Position', [.05, .201, .9, .8], ...
        'Callback', @rmNucleiList_Callback, ...
        'BusyAction', 'cancel', ...
        'HorizontalAlignment','right',...
        'Max', 2, 'Min', 0); % this allows multiple selections
    handles.rmNuclei = uicontrol( ...
        'Parent', panelNucleiList, ...
        'Style', 'pushbutton', ...
        'String', 'Remove Nuclei', ...
        'Units','normalized',...
        'Position', [.05, .01, .9 .2], ...
        'Callback', @rmNuclei_Callback, ...
        'BusyAction', 'cancel'); % this allows multiple selections
   
    
    % setting visibility to "on" only now speeds up the window creation
    set(fig, 'Visible', 'on');
    %store the hanldes in guidata
    guidata(fig, handles);
    % use guidata only for handles related to the actual user interface
    % use appdata to store the actual data
    UserData=get(fig,'UserData');
    %TODO initialize values
end
% --- Executes just before imagem is made visible------------------
%TODO

%---------GUI callback functions-----------------------------------'
%open image stack
function open_imStack_Callback(hObject,eventdata)
     h=guidata(hObject);
     UserData=get(h.f,'UserData');
     [imname, impath, imfilter_index] = uigetfile('*.tif','Open an image file (.tif)');
  

        file_index=imname((end-6):(end-4));        
        [files,channels]=all_channel_names(impath,file_index);
        set(h.ChannelList,'String',files); 
     if imfilter_index
         
         ims=parse_stack([impath 'dapi_' file_index '.tif'],1,40);
         front=ims(:,:,1);
         imagesc(front,'Parent',h.imStack);colormap gray;axis square;axis off;axis image
     end
     UserData.index=file_index;
     UserData.dirpath=impath;
     UserData.I=ims;
     UserData.files=files;
     UserData.channels=channels;
     set(h.f,'UserData',UserData);
     message(h,['Loaded DAPI channel from selected stack set: ' file_index]);
end
%project image stack
function project_imStack_Callback(hObject,eventdata)
    h=guidata(hObject);
    UserData=get(h.f,'UserData');
    zim=zproject(UserData.I);
    imagesc(zim,'Parent',h.imStack);colormap gray;
    UserData.I2=zim;
    set(h.f,'Userdata',UserData);
    message(h,'Z-projection using max()...done');
end
%segment nuclei
function autoSegment_Callback(hObject,eventdata)
    h=guidata(hObject);
    message(h,'Performing segmentation, please wait...');
    UserData=get(h.f,'UserData');
    DL=segmentNuclei(UserData.I2);
    %filtler for area and background
    [nuclei BW]=filterSegmentation(DL,UserData.I2,h.imStack);
    UserData.nuclei=nuclei;
    UserData.BW=BW;
    set(h.f,'Userdata',UserData);
    nuclei_Labels={nuclei.Label};
    set(h.NucleiList,'String',nuclei_Labels,'Value',[1]);
    message(h,'Segmentation ... done, select wrong segmented nuclei -> to be removed');
end
%remove segmented nuclei
function rmNuclei_Callback(hObject,eventdata)
    h=guidata(hObject);
    set(h.NucleiList,'String','');
    cla(h.imStack);
    UserData=get(h.f,'UserData');
    selection=get(h.NucleiList,'Value');
    message(h,['Removing the folowing nuclei: ' num2str(selection) 'please wait ...']);
    [nuclei BW]=filterSegmentation(UserData.BW,UserData.I2,h.imStack,selection);
    UserData.nuclei=nuclei;
    UserData.BW=BW;
    set(h.f,'Userdata',UserData);
    nuclei_Labels={nuclei.Label};
    set(h.NucleiList,'String',nuclei_Labels,'Value',[1]);
    message(h,['Nuclei removed, ' num2str(numel(nuclei)) 'nuclei re-labeled']);
end
%select segmented nuclei to remove
function rmNucleiList_Callback(hObject,eventdata)
    h=guidata(hObject);
    selection=get(gcbo,'Value'); 
    message(h,['Selected nuclei to be removed: ' num2str(selection)]);    
end
%count dots for selected channels
function countDots_Callback(hObject, eventdata)
    h=guidata(hObject);
    selection=get(h.ChannelList,'Value');
end
%calibrate images for the shift
function newCalibration_Callback(hObject,eventdata)
    h=guidata(hObject);
    UserData=get(h.f,'UserData');
    c=get(gcbo,'UserData');
    [imname, impath, imfilter_index] = uigetfile([c.name '*.tif'],['Open an beads file (.tif) for channel ' c.name]);
    if imfilter_index
    file_index=imname((end-6):(end-4));
    ch_b_file=[impath imname];
    dapi_b_file=[impath 'dapi_' file_index '.tif'];
    [tform, dapip, chp]=calibrateShift(dapi_b_file,ch_b_file);
    [svName,svPath,FilterIndex] = uiputfile('*.mat','Save your calibration',[impath c.name 'calib']);
        if FilterIndex
            svFullPath=fullfile(svPath, svName);
            UserData.tform{c.val}=tform;
            set(h.f,'Userdata',UserData);
            save(svFullPath,'-mat','tform','dapip','chp')
            set(h.pathCalib{c.val},'String',svName)
        else 
            return
        end
    else 
        return
    end
end
%load previously calculated calibration
function loadCalibration_Callback(hObject,eventdata)
    h=guidata(hObject);
    UserData=get(h.f,'UserData');
    c=get(gcbo,'UserData');
    [mname, mpath, mfilter_index] = uigetfile('*.mat',['Open calibration file for channel ' c.name]);
    if mfilter_index
        mFullPath=fullfile(mpath, mname);
        load(mFullPath,'-mat','tform')
        UserData.tform{c.val}=tform;
        set(h.f,'Userdata',UserData);
        set(h.pathCalib{c.val},'String',mname)
    else
        return
    end
end
%save User Data
function saveCounts_Callback(hObject,eventdata)
    h=guidata(hObject);
    UserData=get(h.f,'UserData');
    [svName,svPath,FilterIndex] = uiputfile('*.mat','Save your calibration',[UserData.dirpath 'UserData' UserData.index]);
    if FilterIndex
        UserData.I=UserData.I2;
        svFullPath=fullfile(svPath, svName);
        save(svFullPath,'-mat','UserData')
    else
        return
    end
end

%---------Utilities---------------------------------------
function message(h,st)
set(h.uiMessage,'string',st)
end







