function varargout = scale_intensities(axis_handle,mask)
%
% ------------------------------------------------------------------------------
% Copyright ©2012, The University of Texas Southwestern Medical Center 
% Authors:
% Satwik Rajaram and Benjamin Pavie for the Altschuler and Wu Lab
% For latest updates, check: < http://www.PhenoRipper.org >.
%
% All rights reserved.
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, version 3 of the License.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details:
% < http://www.gnu.org/licenses/ >.
%
% ------------------------------------------------------------------------------
%%



myhandles=getappdata(0,'myhandles');

number_of_markers=size(myhandles.img,3);
min_intensity=0;
max_intensity=2^myhandles.bit_depth;

% color_scale=zeros(number_of_markers,2);
% color_scale(:,1)=min_intensity;
% color_scale(:,2)=max_intensity;
color_scale=myhandles.marker_scales;
color_order=myhandles.color_order;
colors=myhandles.display_colors;
%colors=color_order(1:number_of_markers);

gui_width=600;
gui_height=700;
background_color='black';
foreground_color='white';
panel_width=0.9;
panel_height=0.1;

done_button_x=0.4;
done_button_y=0.05;
done_button_width=0.2;
done_button_height=0.05;

min_slider_x=0.2;
max_slider_x=0.525;
slider_width=0.225;
slider_height=0.3;
slider_y=0.35;
min_edit_x=min_slider_x+slider_width+0.01;
max_edit_x=max_slider_x+slider_width+0.01;
edit_y=0.35;
edit_width=0.075;
edit_height=0.3;

color_popupmenu_x=0.85;
color_popupmenu_y=edit_y;
color_popupmenu_height=edit_height+0.075;
color_popupmenu_width=0.125;

show_marker_checkbox_x=0.0;
show_marker_checkbox_y=edit_y;
show_marker_checkbox_height=edit_height;
show_marker_checkbox_width=0.2;


handles.fig=figure('position',[0,0,gui_width,gui_height],'Color',background_color,...
    'MenuBar','none');
handles.close_button=uicontrol('Style', 'pushbutton','String','Done','Units','normalized',...
            'position', [done_button_x,done_button_y,done_button_width,done_button_height],...
            'Callback', {@done_callback},'parent',handles.fig);
myhandles=getappdata(0,'myhandles');
myhandles.scale_figure=handles.fig;
setappdata(0,'myhandles',myhandles);
set_myhandle_values();

% display_image(myhandles.img,axis_handle,color_scale,colors,[]);  
% myhandles=getappdata(0,'myhandles');
% axis(myhandles.h,'image');
% axis off
% set(myhandles.h,'XTickLabel',[]);
% set(myhandles.h,'YTickLabel',[]);
% set(myhandles.h,'XGrid','off');
% set(myhandles.h,'YGrid','off');
% set(myhandles.h,'LineWidth',1);
% set(handles.fig,'Name','PhenoRipper:Intensity Scaling','NumberTitle','off');
% setappdata(0,'myhandles',myhandles);


if(isfield(myhandles,'markers'))
  markerNr=0;
  for marker_num=1:size(myhandles.markers,2)
    if(myhandles.markers{marker_num}.isUse)
      markerNr=markerNr+1;
      ischecked=1;
      markerValue=marker_num;
      try
        ischecked=~isempty(myhandles.display_colors{marker_num});
        [~, markerValue] = ismember(myhandles.display_colors{marker_num}, myhandles.color_order);
        markerValue=markerValue(1,1);
        if(markerValue==0)
          markerValue=marker_num;
        end
      catch
      end
      add_marker(markerNr,0.9-1.25*panel_height*(markerNr-1),color_scale(markerNr,1),color_scale(markerNr,2),myhandles.markers{marker_num}.name,ischecked,markerValue);
    end
  end
else
  for marker_num=1:number_of_markers    
      ischecked=1;
      try
        ischecked=~isempty(myhandles.display_colors{marker_num});
      catch
      end
      add_marker(marker_num,0.9-1.25*panel_height*(marker_num-1),color_scale(marker_num,1),color_scale(marker_num,2),[],ischecked,markerValue);
  end
end


   function set_myhandle_values()
        myhandles=getappdata(0,'myhandles');
        display_image(myhandles.img,myhandles.h,color_scale,colors,mask);        
        axis(myhandles.h,'image');
        
        axis off
        set(myhandles.h,'XTickLabel',[]);
        set(myhandles.h,'YTickLabel',[]);
        set(myhandles.h,'XGrid','off');
        set(myhandles.h,'YGrid','off');
        set(myhandles.h,'LineWidth',1);
       
        myhandles.marker_scales=color_scale;
        for i=1:length(colors)
          if(strcmpi(colors{i},''))
            myhandles.analyze_channels(i)=0;
          else
            myhandles.analyze_channels(i)=1;
          end
        end
        myhandles.display_colors=colors;
        setappdata(0,'myhandles',myhandles);
    end

    function done_callback(hObject,eventdata)
%         myhandles=getappdata(0,'myhandles');
%         display_image(myhandles.img,axis_handle,color_scale,colors,mask);
%         myhandles.marker_scales=color_scale;
%         myhandles.display_colors=colors;
%         setappdata(0,'myhandles',myhandles);
        set_myhandle_values();
        delete(handles.fig);
    end

 

    function marker_handles=add_marker(marker_number,position,default_min,default_max,name,ischecked,markerValue)
        
        %Panel
        if(~isempty(name))
          marker_handles.marker_panel=uipanel('Title',name,'BackgroundColor',background_color,...
            'ForegroundColor',foreground_color,'Units','normalized','position',[0.05,position,panel_width,panel_height],...
            'parent',handles.fig);
          
        else
          marker_handles.marker_panel=uipanel('Title','Marker Number ','BackgroundColor',background_color,...
            'ForegroundColor',foreground_color,'Units','normalized','position',[0.05,position,panel_width,panel_height],...
            'parent',handles.fig);
        end
        % Scroll Bars
        marker_handles.min_scroll_bar=uicontrol('Style', 'slider',...
            'Min',min_intensity,'Max',max_intensity,'Value',default_min,'Units','normalized',...
            'position', [min_slider_x,slider_y,slider_width,slider_height],...
            'Callback', {@min_scroll_callback,marker_number},'parent',marker_handles.marker_panel);
        marker_handles.max_scroll_bar=uicontrol('Style', 'slider',...
            'Min',min_intensity,'Max',max_intensity,'Value',default_max,'Units','normalized',...
            'position', [max_slider_x,slider_y,slider_width,slider_height],...
            'Callback', {@max_scroll_callback,marker_number},'parent',marker_handles.marker_panel);
        %Text Boxes
        marker_handles.min_edit=uicontrol('Style', 'edit',...
            'String',num2str(default_min),'Units','normalized',...
            'position', [min_edit_x,edit_y,edit_width,edit_height],...
            'Callback', {@min_edit_callback,marker_number},'parent',marker_handles.marker_panel);
        marker_handles.max_edit=uicontrol('Style', 'edit',...
            'String',num2str(default_max),'Units','normalized',...
            'position', [max_edit_x,edit_y,edit_width,edit_height],...
            'Callback', {@max_edit_callback,marker_number},'parent',marker_handles.marker_panel);
        %Select Color popupmenu
        marker_handles.color_popupmenu=uicontrol('Style', 'popupmenu',...
            'String',color_order,'Units','normalized',...
            'position', [color_popupmenu_x,color_popupmenu_y,color_popupmenu_width,color_popupmenu_height],...
            'Callback', {@color_popupmenu_callback,marker_number},'parent',marker_handles.marker_panel,'Value',markerValue);
        % Show marker checkbox
        marker_handles.show_marker_checkbox=uicontrol('Style', 'checkbox',...
            'String','Use Marker','Units','normalized','Value',ischecked,...
            'position', [show_marker_checkbox_x,show_marker_checkbox_y,show_marker_checkbox_width,show_marker_checkbox_height],...
            'Callback', {@checkbox_callback,marker_number},'parent',marker_handles.marker_panel,...
            'BackgroundColor',[0 0 0],'ForegroundColor',[1 1 1]);
        if(~ischecked)
          set(marker_handles.min_scroll_bar ,'Enable','off');
          set(marker_handles.max_scroll_bar ,'Enable','off');
          set(marker_handles.min_edit ,'Enable','off');
          set(marker_handles.max_edit ,'Enable','off');
          set(marker_handles.color_popupmenu ,'Enable','off');
        end
          
          
          
          
        function min_scroll_callback(hObject,eventdata,marker_number)
            value=get(hObject,'Value');
            set(marker_handles.min_edit,'String',num2str(value));
            color_scale(marker_number,1)=value;
            set_myhandle_values();
%             myhandles=getappdata(0,'myhandles');
%             display_image(myhandles.img,axis_handle,color_scale,colors,mask);
        end
        function max_scroll_callback(hObject,eventdata,marker_number)
            value=get(hObject,'Value');
            set(marker_handles.max_edit,'String',num2str(value));
            color_scale(marker_number,2)=value;
%             myhandles=getappdata(0,'myhandles');
%             display_image(myhandles.img,axis_handle,color_scale,colors,mask);
            set_myhandle_values();
        end
        function min_edit_callback(hObject,eventdata,marker_number)
            value=str2double(get(hObject,'String'));
            if(value<=max_intensity)
                if(value>=min_intensity)
                    set(marker_handles.min_scroll_bar,'Value',value);
                    color_scale(marker_number,1)=value;
%                     myhandles=getappdata(0,'myhandles');
%                     display_image(myhandles.img,axis_handle,color_scale,colors,mask);
                    set_myhandle_values();
                else
                    warndlg(['Intensity must be >=' num2str(min_intensity)]);
                end
            else
                warndlg(['Intensity must be <=' num2str(max_intensity)]);
            end
            
        end
        function max_edit_callback(hObject,eventdata,marker_number)
            value=str2double(get(hObject,'String'));
            if(value<=max_intensity)
                if(value>=min_intensity)
                    set(marker_handles.max_scroll_bar,'Value',value);
                    color_scale(marker_number,2)=value;
%                     myhandles=getappdata(0,'myhandles');
%                     display_image(myhandles.img,axis_handle,color_scale,colors,mask);
                    set_myhandle_values();
                else
                    warndlg(['Intensity must be >=' num2str(min_intensity)]);
                end
            else
                warndlg(['Intensity must be <=' num2str(max_intensity)]);
            end
            
        end
        function color_popupmenu_callback(hObject,eventdata,marker_number) 
            value=get(hObject,'Value');
            colors{marker_number}=color_order{value};
%             myhandles=getappdata(0,'myhandles');
%             display_image(myhandles.img,axis_handle,color_scale,colors,mask);
            set_myhandle_values();
        end
        function checkbox_callback(hObject,eventdata,marker_number) 
            value=get(hObject,'Value');
            if(value)
                value1=get(marker_handles.color_popupmenu,'Value');
                colors{marker_number}=color_order{value1};
                set(marker_handles.min_scroll_bar ,'Enable','on');
                set(marker_handles.max_scroll_bar ,'Enable','on');
                set(marker_handles.min_edit ,'Enable','on');
                set(marker_handles.max_edit ,'Enable','on');
                set(marker_handles.color_popupmenu ,'Enable','on');
                
            else
                colors{marker_number}='';
                set(marker_handles.min_scroll_bar ,'Enable','off');
                set(marker_handles.max_scroll_bar ,'Enable','off');
                set(marker_handles.min_edit ,'Enable','off');
                set(marker_handles.max_edit ,'Enable','off');
                set(marker_handles.color_popupmenu ,'Enable','off');
            end
%             myhandles=getappdata(0,'myhandles');
%             display_image(myhandles.img,axis_handle,color_scale,colors,mask);
              set_myhandle_values();
        end
    end

        
end

