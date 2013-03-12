function varargout=SpotterUI()    

%Search if the figure exists
gui_singleton=1;
h = findall(0,'tag',mfilename);

    if ((isempty(h) && gui_singleton) || ~gui_singleton)
    %Launch the figure if not created or multiple instances allowed
    scr=get(0, 'ScreenSize');
    pos=[scr(1:2)+scr(3:4).*0.01,scr(3:4).*0.95];
    fig = figure( ...
            'Units', 'pixel', ...
            'Position', pos, ...
            'Name', 'SpotterUI', ...
            'MenuBar', 'none', ...
            'Toolbar', 'none', ...
            'Color', get(0, 'defaultuicontrolbackgroundcolor'), ...
            'NumberTitle', 'off', ...
            'Resize', 'on', ...
            'Visible', 'off',...
            'handlevisibility','callback',...
            'HitTest','off',...
            'CloseRequestFcn',@gui_closereq,...
            'tag',mfilename,...
            'CreateFcn',@gui_OpeningFcn);

    % save all gui object handles as guidata so they can be accessed later
    handles = guidata(fig);
    handles.f=fig;
    
    % settings menu
        settings_menu = uimenu(fig,'Label','Settings');
        
    %the toolbar
        
        toolbarh = uitoolbar(fig);
        
        icon=utilities.get_icon('open_set.ico');
        uipushtool(toolbarh,'CData',icon,...
            'TooltipString','open stack set',...
            'ClickedCallback',@open_imStack_Callback,...
            'BusyAction', 'cancel');
        
        icon=utilities.get_icon('save_counts.ico');
        uipushtool(toolbarh,'CData',icon,...
            'TooltipString','save counts',...
            'ClickedCallback',@saveCounts_Callback,...
            'BusyAction', 'cancel');
 
        icon=utilities.get_icon('z_project.ico');
        uipushtool(toolbarh,'CData',icon,...
            'TooltipString','z-project',...
            'ClickedCallback',@project_imStack_Callback,...
            'BusyAction', 'cancel');
        
        icon=utilities.get_icon('auto_segment.ico');
        uipushtool(toolbarh,'CData',icon,...
            'TooltipString','auto segment',...
            'ClickedCallback',@autoSegment_Callback,...
            'BusyAction', 'cancel');
        
        icon=utilities.get_icon('count_dots2.ico');
        uipushtool(toolbarh,'CData',icon,...
            'TooltipString','count dots',...
            'ClickedCallback',@countDots_Callback);
        
        icon=utilities.get_icon('open_single.ico');
        uipushtool(toolbarh,'CData',icon,...
            'TooltipString','open single stack',...
            'ClickedCallback','');
        
        icon=utilities.get_icon('new_calib2.ico');
        uipushtool(toolbarh,'CData',icon,...
            'TooltipString','new calibration',...
            'ClickedCallback','');
        
        icon=utilities.get_icon('manual_segment.ico');
        uipushtool(toolbarh,'CData',icon,...
            'TooltipString','manual segment',...
            'ClickedCallback','');
                
        icon=utilities.get_icon('settings.ico');
        uipushtool(toolbarh,'CData',icon,...
            'TooltipString','settings',...
            'ClickedCallback','');
        
         icon=utilities.get_icon('pref2.ico');
        uipushtool(toolbarh,'CData',icon,...
            'TooltipString','settings',...
            'ClickedCallback','');
        
        icon=utilities.get_icon('stack_crop.ico');
        uipushtool(toolbarh,'CData',icon,...
            'TooltipString','crop stack',...
            'ClickedCallback','');
        

        
        set(toolbarh,'HandleVisibility','off')
        toolhandles = get(toolbarh,'Children');
        set(toolhandles,'HandleVisibility','off')
    % slice the display up into separate panels to organize the controls
        panelMessage= uipanel( ...
            'Parent', fig, ...
            'Units', 'normalized', ...
            'Position', [.22, 0.82, 0.4, 0.17], ...
            'Title', 'Message');

        panelImageStack = uipanel( ...
            'Parent', fig, ...
            'Units', 'normalized', ...
            'Position', [.12, 0.01, 0.5, 0.81], ...
            'Title', 'Image');

        panelNucleiList = uipanel( ...
            'Parent', fig, ...
            'Units', 'normalized', ...
            'Position', [.12, .82, .10, .17], ...
            'Title', 'Nuclei Selection');

        panelMenu = uipanel( ...
            'Parent', fig, ...
            'Units', 'normalized', ...
            'Position', [.01, .49, .1, .50], ...
            'Title', 'Menu');

        handles.panelSettings = uipanel( ...
            'Parent', fig, ...
            'Units', 'normalized', ...
            'Position', [.01, .01, .1, .47], ...
            'Title', 'Settings');

        panelThresholds = uipanel( ...
            'Parent', fig, ...
            'Units', 'normalized', ...
            'Position', [.63, .01, .36, .98], ...
            'Title', 'Thresholds');

        %panelMessage: message text
        handles.uiMessage = uicontrol(...
            'Parent', panelMessage, ...
            'Style', 'text', ...
            'Units', 'normalized', ...
            'Position', [.01, .01, .9, .9], ...
            'FontSize',16,...
            'String', 'Load an image stack or start calibration');

          % panelThresholds: axes for Threshold selection
        handles.ax = cell(4, 1);
        handles.ax{3} = axes( ...
            'Parent', panelThresholds, ...
            'Units', 'normalized', ...
            'Position', [.01, .01, .73, .4], ...
            'HandleVisibility', 'callback', ...
            'NextPlot', 'replacechildren', ...
            'FontSize', 8);

        handles.ax{2} = axes( ...
            'Parent', panelThresholds, ...
            'Units', 'normalized', ...
            'Position', [.06, .45, .92, .2], ...
            'HandleVisibility', 'callback', ...
            'NextPlot', 'replacechildren',...
            'FontSize', 8);
        handles.ax{4} = axes( ...
            'YAxisLocation','right',...
            'YColor','m',...
            'Parent', panelThresholds, ...
            'Units', 'normalized', ...
            'Position', [.06, .45, .92, .2], ...
            'HandleVisibility', 'callback', ...
            'NextPlot', 'replacechildren',...
            'FontSize', 8,'Xtick',[],'Color','none');

        handles.ax{1} = axes( ...
            'Parent', panelThresholds, ...
            'Units', 'normalized', ...
            'Position', [.06, .69, .92, .27], ...
            'HandleVisibility', 'callback', ...
            'NextPlot', 'replacechildren',...
            'FontSize', 8);

        handles.countNext = uicontrol( ...
            'Parent', panelThresholds, ...
            'Style', 'pushbutton', ...
            'Units', 'normalized', ...
            'Position', [.75, .3, .2, .1], ...
            'String', 'Next', ...
            'UserData',0,...
            'Callback', @countNext_Callback, ...
            'BusyAction', 'cancel');


        % panelImageStack: axes for Image Stack
        handles.imStack = axes( ...
            'Parent', panelImageStack, ...
            'Units', 'normalized', ...
            'OuterPosition', [.0, .0, 1.0, 1.0], ...
            'Position', [.01, .01, .99, .98], ...
            'HandleVisibility', 'callback', ...
            'NextPlot', 'replacechildren');
        axis(handles.imStack,'off','image','ij');


        % panelMenu: buttons for all accessible actions
%         uicontrol( ...
%             'Parent', panelMenu, ...
%             'Style', 'pushbutton', ...
%             'Units', 'normalized', ...
%             'Position', [.05, .85, .9, .1], ...
%             'String', 'Open Stack Set', ...
%             'Callback', @open_imStack_Callback, ...
%             'BusyAction', 'cancel');
% 
%         handles.zProject = uicontrol( ...
%             'Parent', panelMenu, ...
%             'Style', 'pushbutton', ...
%             'Units', 'normalized', ...
%             'Position', [.05, .75, .9, .1], ...
%             'String', 'Z-projection (max)', ...
%             'Callback', @project_imStack_Callback, ...
%             'BusyAction', 'cancel');
% 
%         handles.autoSegment = uicontrol( ...
%             'Parent', panelMenu, ...
%             'Style', 'pushbutton', ...
%             'Units', 'normalized', ...
%             'Position', [.05, .65, .9, .1], ...
%             'String', 'Auto Segment', ...
%             'Callback', @autoSegment_Callback, ...
%             'BusyAction', 'cancel');

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

%         handles.uiCount = uicontrol( ...
%             'Parent', panelMenu, ...
%             'Style', 'pushbutton', ...
%             'Units', 'normalized', ...
%             'Position', [.05, .15, .9, .1], ...
%             'String', 'Count Dots', ...
%             'Callback', @countDots_Callback, ...
%             'BusyAction', 'cancel');
% 
%         handles.uiSave = uicontrol( ...
%             'Parent', panelMenu, ...
%             'Style', 'pushbutton', ...
%             'Units', 'normalized', ...
%             'Position', [.05, .05, .9, .1], ...
%             'String', 'Save Counts', ...
%             'Callback', @saveCounts_Callback, ...
%             'BusyAction', 'cancel');

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

        %store the hanldes in guidata
        guidata(fig, handles);
        %initialize all
        %initialize();
        % setting visibility to "on" only now speeds up the window creation
        set(fig, 'Visible', 'on');
        % use guidata only for handles related to the actual user interface
        % use appdata to store internal data
        % use userdata to store the results data
        %TODO initialize values
        initialize(fig);
  
    else
        %Figure exists so bring Figure to the focus
        %and make sure to return the handles
        figure(h);
        handles=guidata(h);
        display([get(h,'Name') ' already launched...']);
    end
    if nargout
        [varargout{1:nargout}]=handles;
    end
end

function gui_OpeningFcn(hObject, eventdata)
% --- Executes just before imagem is made visible------------------
    if strcmp(get(hObject,'Visible'),'off')
       display('SpotterUI')
    end
end


function initialize(fig)
    
    dt=clock;
    dt=fix(dt);
    
    default.date=datestr(dt,'dd-mm-yyyy-HH-MM');
    default.dirpath=pwd;
    default.stack_range=[1,100];
    default.ref_channel='dapi_';
    default.segmentation_method='auto';
    default.thr_number=100;
    default.thr_window=5;
    default.thr_penalty=0.1;
    default.nuclei_size_range=[100 10000];
    default.segmentation_rangel=[100 10000];
    default.filter_size=[15 15 15];
    default.filter_sigma=[1.5 1.5 1.5];
    
    status.loaded=0;
    status.projected=0;
    status.enhanced=0;
    status.cropped=0;
    status.segmented=0;
    status.counted=0;
    status.changed=0;
    status.saved=0;
    
    DefaultData.index='000';
    DefaultData.dirpath=pwd;
    DefaultData.I=[];
    DefaultData.files=[];
    DefaultData.channels=[];
    DefaultData.tform=[];
    DefaultData.L=[];
    DefaultData.dt=default.date;
    DefaultData.I2=[];
    DefaultData.nuclei=[];
    DefaultData.BW=[];
    
    h=guidata(fig);
    
    set(h.uiMessage,'string','Load an image stack or start calibration')

 
     set(h.f,'WindowButtonUpFcn','');
     set(h.ax{1},'NextPlot','replaceChildren');
     set(h.ax{2},'NextPlot','replaceChildren');
     set(h.imStack,'NextPlot','replaceChildren');
     set(h.ax{3},'NextPlot','replaceChildren');
     set(h.ax{4},'NextPlot','replaceChildren');
     set(h.countNext,'UserData',0)
    
     delete(allchild(h.imStack)); 
     delete(allchild(h.ax{1})); 
     delete(allchild(h.ax{2})); 
     delete(allchild(h.ax{3})); 
     delete(allchild(h.ax{4})); 

    
    set(h.ChannelList,'String','','Value',[]);
    set(h.NucleiList,'String','','Value',[]);

    delete(get(h.panelSettings,'Children'));
        
    set(fig,'UserData',DefaultData);
    setappdata(fig,'settings',default);
    setappdata(fig,'status',status); 

end

function gui_closereq(hObject,eventdata)
% User-defined close request function 
% to display a question dialog box 
   selection = questdlg(['Close ', get(hObject,'Name'),'?',', all unsaved information will be lost.'],...
      'Close Request Function',...
      'Yes','No','Yes'); 
   switch selection, 
      case 'Yes',
         delete(hObject)
      case 'No'
      return 
   end
end

%---------GUI callback functions-----------------------------------'
%open image stack
function open_imStack_Callback(hObject,eventdata) 
     h=guidata(hObject);
     st=getappdata(h.f,'status');
      if st.loaded
        % ask user to confirm for closing the software
        selection = questdlg('Open new stack set? all unsaved information will be lost.',...
            'Open...',...
            'Yes','No','Yes');
        if strcmp(selection,'No')
            % exit if canceled
            return;
        end
        
      end
      
         UserData=get(h.f,'UserData');
         [imname, impath, imfilter_index] = uigetfile('*.tif','Open an image file (.tif)',UserData.dirpath);
         initialize(h.f)
         if imfilter_index   
         file_index=imname((end-6):(end-4));        
            [files,channels]=utilities.all_channel_names(impath,file_index);
            set(h.ChannelList,'String',files); 


             info=imfinfo([impath 'dapi_' file_index '.tif']);   
             ims=parse_stack([impath 'dapi_' file_index '.tif'],1,numel(info));
             front=ims(:,:,1);
             imagesc(front,'Parent',h.imStack);axes(h.imStack);colormap gray;axis square;axis off;axis image

        h=setSettingsControls(h,channels);
        %store the hanldes in guidata
         guidata(h.f,h);
        %store UserData
         UserData.index=file_index;
         UserData.dirpath=impath;
         UserData.I=ims;
         UserData.files=files;
         UserData.channels=channels;
         UserData.tform=cell(numel(channels),1);
         UserData.L=cell(numel(channels),1);
         dt=clock;
         dt=fix(dt);
         UserData.dt=datestr(dt,'dd-mm-yyyy-HH-MM');
         set(h.f,'UserData',UserData);
         st.loaded=1;
         setappdata(h.f,'status',st)
         ui.message(h,['Loaded DAPI channel from selected stack set: ' file_index]);
         else
             return 
         end
end
%project image stack
function project_imStack_Callback(hObject,eventdata)
    h=guidata(hObject);
    UserData=get(h.f,'UserData');
    zim=zproject(UserData.I);
    imagesc(zim,'Parent',h.imStack);colormap gray;
    UserData.I2=zim;
    set(h.f,'Userdata',UserData);
    ui.message(h,'Z-projection using max()...done');
end
%segment nuclei
function autoSegment_Callback(hObject,eventdata)
    h=guidata(hObject);
    ui.message(h,'Performing segmentation, please wait...');
    UserData=get(h.f,'UserData');
    DL=segmentNuclei(UserData.I2);
    %filtler for area and background
    [nuclei BW]=filterSegmentation(DL,UserData.I2,h.imStack);
    UserData.nuclei=nuclei;
    UserData.BW=BW;
    set(h.f,'Userdata',UserData);
    nuclei_Labels={nuclei.Label};
    set(h.NucleiList,'String',nuclei_Labels,'Value',[1]);
    ui.message(h,'Segmentation ... done, select wrong segmented nuclei -> to be removed');
end
%remove segmented nuclei
function rmNuclei_Callback(hObject,eventdata)
    h=guidata(hObject);
    set(h.NucleiList,'String','');
    cla(h.imStack);
    UserData=get(h.f,'UserData');
    selection=get(h.NucleiList,'Value');
    ui.message(h,['Removing the folowing nuclei: ' num2str(selection) 'please wait ...']);
    [nuclei BW]=filterSegmentation(UserData.BW,UserData.I2,h.imStack,selection);
    UserData.nuclei=nuclei;
    UserData.BW=BW;
    set(h.f,'Userdata',UserData);
    nuclei_Labels={nuclei.Label};
    set(h.NucleiList,'String',nuclei_Labels,'Value',[1]);
    ui.message(h,['Nuclei removed, ' num2str(numel(nuclei)) 'nuclei re-labeled']);
end
%select segmented nuclei to remove
function rmNucleiList_Callback(hObject,eventdata)
    h=guidata(hObject);
    selection=get(gcbo,'Value'); 
    ui.message(h,['Selected nuclei to be removed: ' num2str(selection)]);    
end
%count dots for selected channels
function countDots_Callback(hObject, eventdata)
    h=guidata(hObject);
    UserData=get(h.f,'UserData');
    UserData.threshold_num=100;
    selection=get(h.ChannelList,'Value');
    UserData=thresholdDots(UserData,h,selection);
%     [UData adots]=countDots(UserData,h,selection,);
%     UserData.UData=UData;
%     UserData.dots=adots;
    set(h.f,'Userdata',UserData);
    
end
%save User Data
function saveCounts_Callback(hObject,eventdata)
    h=guidata(hObject);
    UserData=get(h.f,'UserData');
    ui.message(h,'Wait, calculating DAPI intensity...');
    UserData=setDapiIntensity(UserData);
    dt=clock;
    dt=fix(dt);
    dt=datestr(dt,'ddmmyyyy');
    [svName,svPath,FilterIndex] = uiputfile('*.mat','Save your calibration',...
        [UserData.dirpath 'Counts_' UserData.index '_' dt]);
    if FilterIndex
        %TODO calculate dpi intensity?
        UserData.I=UserData.I2;
        svFullPath=fullfile(svPath, svName);
        save(svFullPath,'-mat','UserData')
    else
        return
    end
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
        tform=calibrateShift(dapi_b_file,ch_b_file);
        [svName,svPath,FilterIndex] = uiputfile('*.mat','Save your calibration',[impath c.name 'calib']);
        
        if FilterIndex
            svFullPath=fullfile(svPath, svName);
            UserData.tform{c.val}=tform;
            set(h.f,'Userdata',UserData);
            save(svFullPath,'-mat','tform')
            set(h.pathCalib{c.val},'String',svName)
            
        else
            %TODO set values to empty
            return
        end
        
    else
        %TODO set values to empty
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
        %TODO set values to empty
        return
    end
end

function countNext_Callback(hObject,eventdata)
    set(gcbo,'UserData',1)
end




%---------Utilities---------------------------------------
%generate controls for the available channels
    function h = setSettingsControls(h,channels)     
    chs=numel(channels);
     for ch = 1:chs
        %panelSettings: buttons for settings and calibration
        %shift calibration for cy5
        h.pathCalibs = cell(chs, 1);
        h.calib = cell(chs, 1);
        h.loadCalib = cell(chs, 1);
        ypos=.92-.21*(ch-1);
        uicontrol( ...
            'Parent', h.panelSettings, ...
            'Style','text', ...
            'Units', 'normalized', ...
            'Position', [.02, ypos, .96, .06], ...
            'String', [channels{ch} 'shift calibration'], ...
            'HorizontalAlignment', 'left');
        h.pathCalib{ch} = uicontrol( ...
            'Parent', h.panelSettings, ...
            'Style', 'edit', ...
            'Units', 'normalized', ...
            'Position', [.02, ypos-.05, .96, .06], ...
            'String', '', ...
            'Callback', '', ...
            'BusyAction', 'cancel');
        cn.name=channels{ch};
        cn.val=ch;
        h.calib{ch} = uicontrol( ...
            'Parent', h.panelSettings, ...
            'Style', 'pushbutton', ...
            'Units', 'normalized', ...
            'Position', [.02, ypos-.15, .49, .1], ...
            'String', 'New', ...
            'Callback', @newCalibration_Callback, ...
            'UserData',cn, ...
            'BusyAction', 'cancel');

        h.loadCalib{ch} = uicontrol( ...
            'Parent', h.panelSettings, ...
            'Style', 'pushbutton', ...
            'Units', 'normalized', ...
            'Position', [.51, ypos-.15, .47, .1], ...
            'String', 'Load', ...
            'UserData',cn, ...
            'Callback', @loadCalibration_Callback, ...
            'BusyAction', 'cancel');
     end
    end








