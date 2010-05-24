function varargout = MTBindingSim(varargin)
% MTBindingSim - plot microtubule binding curves under various conditions
%      MTBINDINGSIM, by itself, creates a new MTBINDINGSIM or raises the existing
%      singleton*.
%
%      H = MTBINDINGSIM returns the handle to a new MTBINDINGSIM or the handle to
%      the existing singleton*.
%
%      MTBINDINGSIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MTBINDINGSIM.M with the given input arguments.
%
%      MTBINDINGSIM('Property','Value',...) creates a new MTBINDINGSIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MTBindingSim_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MTBindingSim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%       
%   mtbindingsim is a program to plot binding curves under various
%   conditions, particularly those encountered in microtubule binding or
%   other polymer binding situations.
% 
% See also: GUIDE, GUIDATA, GUIHANDLES

% This file is part of MTBindingSim.
%
% Copyright (C) 2010  University of Notre Dame
%
% MTBindingSim is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% MTBindingSim is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with MTBindingSim.  If not, see <http://www.gnu.org/licenses/>.

% Author:
%   Julia Philip <jphilip@nd.edu>
%
% Version history:
% - 0.5: Initial version


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MTBindingSim_OpeningFcn, ...
                   'gui_OutputFcn',  @MTBindingSim_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end


% --- Executes just before MTBindingSim is made visible.
function MTBindingSim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MTBindingSim (see VARARGIN)

% Choose default command line output for MTBindingSim
handles.output = hObject;

% Save this main figure in the handles object
handles.mainfigure = hObject;

% Shut off the toolbar here
set(hObject, 'Toolbar', 'none');

% Clear out the future home of the graph figure and axes
handles.graphfigure = -1;
handles.graphaxes = -1;

% Creates a color variable to enable rotating colors according to how many
% lines are on the graph
handles.color = 0;
% Create selection change functions for the experimental mode and plotting
% mode button groups
set(handles.exp_mode, 'SelectionChangeFcn', @exp_mode_SelectionChangeFcn);
set(handles.plot_mode, 'SelectionChangeFcn', @plot_mode_SelectionChangeFcn);
set(handles.tot_free, 'SelectionChangeFcn', @tot_free_SelectionChangeFcn);

% Make some global string values for later
global UM KD KS KL KM KA KB;
UM = '&mu;M';
KD = 'K<sub><small>D</small></sub>';
KS = 'K<sub><small>S</small></sub>';
KL = 'K<sub><small>L</small></sub>';
KM = 'K<sub><small>M</small></sub>';
KA = 'K<sub><small>A</small></sub>';
KB = 'K<sub><small>B</small></sub>';

% Convert a bunch of our controls to java controls
handles.units_xmin = make_java_component(handles.units_xmin, UM, 0);
handles.units_xmax = make_java_component(handles.units_xmax, UM, 0);
handles.model1 = make_java_component(handles.model1, '', 1);
handles.equation1 = make_java_component(handles.equation1, '', 1);
handles.model2 = make_java_component(handles.model2, '', 1);
handles.equation2 = make_java_component(handles.equation2, '', 1);
first_order_strings(handles.model1, handles.equation1);
first_order_strings(handles.model2, handles.equation2);
handles.label1_1 = make_java_component(handles.label1_1, '[A] total ', 2);
handles.label2_1 = make_java_component(handles.label2_1, [KD, ' '], 2);
handles.label3_1 = make_java_component(handles.label3_1, '1 MT : ', 2);
handles.label4_1 = make_java_component(handles.label4_1, '', 2);
handles.label5_1 = make_java_component(handles.label5_1, '', 2);
handles.label6_1 = make_java_component(handles.label6_1, '', 2);
handles.label1_2 = make_java_component(handles.label1_2, '[A] total ', 2);
handles.label2_2 = make_java_component(handles.label2_2, [KD, ' '], 2);
handles.label3_2 = make_java_component(handles.label3_2, '', 2);
handles.label4_2 = make_java_component(handles.label4_2, '', 2);
handles.label5_2 = make_java_component(handles.label5_2, '', 2);
handles.label6_2 = make_java_component(handles.label6_2, '', 2);
handles.units1_1 = make_java_component(handles.units1_1, UM, 0);
handles.units2_1 = make_java_component(handles.units2_1, UM, 0);
handles.units3_1 = make_java_component(handles.units3_1, 'A', 0);
handles.units4_1 = make_java_component(handles.units4_1, UM, 0);
handles.units5_1 = make_java_component(handles.units5_1, UM, 0);
handles.units6_1 = make_java_component(handles.units6_1, UM, 0);
handles.units1_2 = make_java_component(handles.units1_2, UM, 0);
handles.units2_2 = make_java_component(handles.units2_2, UM, 0);
handles.units3_2 = make_java_component(handles.units3_2, UM, 0);
handles.units4_2 = make_java_component(handles.units4_2, UM, 0);
handles.units5_2 = make_java_component(handles.units5_2, UM, 0);
handles.units6_2 = make_java_component(handles.units6_2, UM, 0);

% Update handles structure
guidata(hObject, handles);
end



% --- Outputs from this function are returned to the command line.
function varargout = MTBindingSim_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


function control = make_java_component(hObject, string, align)
% hObject    handle to object to convert to Java text control
% string     HTML string to be placed in the Java text control
% align      if 0, left-justify, if 1, center, if 2, right-justify

% Get the current visibility of this uicontrol
visibility = get(hObject, 'Visible');

% Get the current location of this uicontrol
set(hObject, 'Units', 'pixels');
position = get(hObject, 'Position');

% Bomb the uicontrol
delete(hObject);

% Make an HTML string
html = ['<html>', string, '</html>'];

% Create the java object, with appropriate alignment
if align == 1
    jLabel = javaObjectEDT('javax.swing.JLabel', html, javax.swing.SwingConstants.CENTER);
elseif align == 2
    jLabel = javaObjectEDT('javax.swing.JLabel', html, javax.swing.SwingConstants.RIGHT);        
else
    jLabel = javaObjectEDT('javax.swing.JLabel', html, javax.swing.SwingConstants.LEFT);
end

% Wrap the jLabel in MATLAB
[hcomponent, control] = javacomponent(jLabel, position, gcf);
set(control, 'userdata', hcomponent);

% Set the units of the container to normalized, since that's what GUIDE is
% expecting
set(control, 'Units', 'normalized');

% Set the background-color to the required color
bgcolor = get(0,'defaultUicontrolBackgroundColor');
set(hcomponent, 'Background', java.awt.Color(bgcolor(1), bgcolor(2), bgcolor(3)));

% Set the visibility of the control appropriately
set(control, 'Visible', visibility);
end


function set_java_component(hObject, string)
% hObject    handle to MATLAB object (which is a Java text control)
% string     string to set

% Build the string
html = ['<html>', string, '</html>'];

% Get the java object and set the text
jcomponent = get(hObject, 'userdata');
jcomponent.setText(html);
end



% --- Executes on selection change in curve1.
function curve1_Callback(hObject, eventdata, handles)
% hObject    handle to curve1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Gets selected function
switch get(handles.curve1, 'Value')
    % First order binding
    case 1
        
        %determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                first_order_binding_labels1(hObject);
                
            case 'saturation'
                first_order_saturation_labels1(hObject);
                            
            otherwise
        end
        
    % Traditional cooperativity
    case 2
        
        %determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                cooperativity_binding_labels1(hObject);
                
            case 'saturation'
                cooperativity_saturation_labels1(hObject);
                
            otherwise
        end
        
    % MT seam and lattice binding
    case 3
        
        %determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                
               seam_binding_labels1(hObject);
                
            case 'saturation'
                
               seam_saturation_labels1(hObject);
                
            otherwise
        end
        
    % MAPs bind MT-bound MAPs
    case 4
        
        %determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                
                MAP_binding_labels1(hObject);
               
            case 'saturation'
                
                MAP_saturation_labels1(hObject);
                
            otherwise
        end
        
    otherwise
end
end



% --- Executes on selection change in curve2.
function curve2_Callback(hObject, eventdata, handles)
% hObject    handle to curve2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Gets selected function
switch get(handles.curve2, 'Value')
    % First order binding
    case 1
        
        %determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                first_order_binding_labels2(hObject);
                
            case 'saturation'
                first_order_saturation_labels2(hObject);
                            
            otherwise
        end
        
    % Traditional cooperativity
    case 2
        
        %determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                cooperativity_binding_labels2(hObject);
                
            case 'saturation'
                cooperativity_saturation_labels2(hObject);
                
            otherwise
        end
        
    % MT seam and lattice binding
    case 3
        
        %determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                
               seam_binding_labels2(hObject);
                
            case 'saturation'
                
               seam_saturation_labels2(hObject);
                
            otherwise
        end
        
    % MAPs bind MT-bound MAPs
    case 4
        
        %determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                
                MAP_binding_labels2(hObject);
               
            case 'saturation'
                
                MAP_saturation_labels2(hObject);
                
            otherwise
        end
        
    otherwise
end
end


function add_legend(handles, new_legend_string)
% handles    structure with handles and user data (see GUIDATA)

% See if there's a legend already -- if not, this is much easier
legend_object = legend(handles.graphaxes);

% If no legend, make a one-string legend, quickly
if legend_object == []
    legend(handles.graphaxes, new_legend_string);
    return;
end

% Get the guts of the current legend object
[legend_object, legend_parts, plot_parts, legend_strings] = legend(handles.graphaxes);

% Add the new string to the end of the vector
legend_strings = [legend_strings new_legend_string];

% Recreate the legend
legend(handles.graphaxes, legend_strings);
end



function graph_Callback(hObject, eventdata, handles)
% hObject    handle to graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disableButtons(handles.mainfigure);

% Retreives the x-axis values
xmin = str2double(get(handles.input_xmin, 'String'));
xmax = str2double(get(handles.input_xmax, 'String'));

% Checks to make sure that xmin is a positive number
if isnan(xmin) || xmin < 0
   errorbox(['Please enter a positive number for ', get(handles.label_xmin, 'String')], hObject); 
   return
end

% Checks to make sure that xmax is a positive number
if isnan(xmax) || xmax < 0
   errorbox(['Please enter a positive number for ', get(handles.label_xmax, 'String')], hObject); 
   return
end

% Checks to make sure that xmax is greater than xmin
if xmin > xmax
    xminstr = get(handles.label_xmin, 'String');
    xmaxstr = get(handles.label_xmax, 'String');
    errorbox([xmaxstr, ' must be greater than ', xminstr], hObject);
    return
end

% Gets the number of points specified by the user
points = str2double(get(handles.input_points, 'String'));

% Checks to make sure that points is a positive number
if isnan(points) || points < 0
   errorbox(['Please enter a positive number for ', get(handles.label_points, 'String')], hObject); 
   return
end

% Creates a vector of values for x
interval = (xmax - xmin)/points;
xvals = xmin:interval:xmax;

if strcmp(get(get(handles.exp_mode, 'SelectedObject'), 'Tag'), 'competition')

    MTtot = str2double(get(handles.input1_1, 'String'));
    
    if isnan(MTtot) || MTtot < 0
        errorbox('Please enter a positive number for [MT] total', hObject);
        return
    end
    
    Atot = str2double(get(handles.input2_1, 'String'));
    
    if isnan(Atot) || Atot < 0
        errorbox('Please enter a positive number for [A] total', hObject);
        return
    end
    
    KA = str2double(get(handles.input3_1, 'String'));
    
    if isnan(KA) || KA < 0
        errorbox('Please enter a positive number for K_A', hObject);
        return
    end
    
    KB = str2double(get(handles.input4_1, 'String'));
    
    if isnan(KB) || KB < 0
        errorbox('Please enter a positive number for K_B', hObject);
        return
    end
    
    [frac] = competition(MTtot, Atot, xvals, KA, KB);
    
    y1 = frac;
    x1 = xvals;
    
    xaxis = '[B] total';
    yaxis = 'Fraction of A bound';
    plottitle = 'Competition Binding Assay';
    legend1 = ['[MT] total = ' get(handles.input1_1, 'String') ', [A] total = ' get(handles.input2_1, 'String') ', K_A = ' get(handles.input3_1, 'String') ', K_B = ' get(handles.input4_1, 'String') ];

% Determines the parameters selected for curve1
elseif get(handles.curve1, 'Value') == 1
    % First order binding

    % Determine the experimental mode
    switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
        % Binding mode is selected
        case 'binding'

            % Gets the value for [A] total and ensures that it's a
            % positive number
            Atot = str2double(get(handles.input1_1, 'String'));

            if isnan(Atot) || Atot < 0
                errorbox('Please enter a positive number for [A] total', hObject); 
                return
            end

            % Gets the value for KD and ensures that it's a
            % positive number
            KD = str2double(get(handles.input2_1, 'String'));

            if isnan(KD) || KD <= 0
                errorbox('K_D must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the binding ratio and ensures that it's a positive number
            N = str2double(get(handles.input3_1, 'String'));

            if isnan(N) || N <= 0
               errorbox('The ratio must be a number greater than 0', hObject);
               return
            end


            % Determines whether the X-axis is free MT or total MT
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'

                   %Calculates the value of frac, MTfree, and Abound at
                   %each value of x
                   [frac, MTfree, Abound, Afree] = first_order(xvals, Atot, KD, N);

                   y1 = frac;
                   x1 = MTfree;

                   xaxis = '[MT] free';
                   yaxis = 'Fraction of A bound';
                   plottitle = 'Vary [MT] Binding Assay';
                   legend1 = ['First order, [A] total = ' get(handles.input1_1, 'String') ', K_D = ' get(handles.input2_1, 'String'), ', N = ' get(handles.input3_1, 'String')];

                case 'total'

                   % Calculates the value of frac, MTfree, and Abound
                   [frac, MTfree, Abound, Afree] = first_order(xvals, Atot, KD, N);


                   y1 = frac;
                   x1 = xvals; 

                   xaxis = '[MT] total';
                   yaxis = 'Fraction of A bound';
                   plottitle = 'Vary [MT] Binding Assay';
                   legend1 = ['First order, [A] total = ' get(handles.input1_1, 'String') ', K_D = ' get(handles.input2_1, 'String') ', N = ' get(handles.input3_1, 'String')];

                otherwise
            end

        % Saturation mode is selected
        case 'saturation'

            % Gets the value for [MT] total and ensures that it's a
            % positive number
            MTtot = str2double(get(handles.input1_1, 'String'));

            if isnan(MTtot) || MTtot < 0
                errorbox('Please enter a positive number for [MT] total', hObject); 
                return
            end

            % Gets the value for KD and ensures that it's a
            % positive number
            KD = str2double(get(handles.input2_1, 'String'));

            if isnan(KD) || KD <= 0
                errorbox('K_D must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the binding ratio and ensures that it's a positive number
            N = str2double(get(handles.input3_1, 'String'));

            if isnan(N) || N <= 0
               errorbox('The ratio must be a number greater than 0', hObject);
               return
            end

            
            % Determines whether free or total [A] should be graphed
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'
                    
                    % Calculates frac, MTfree, Abound, and Afree
                    [Frac, MTfree, Abound, Afree] = first_order(MTtot, xvals, KD, N);


                    y1 = Abound;
                    x1 = Afree;

                    xaxis = '[A] free';
                    yaxis = '[A] bound';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['First order, [MT] total = ' get(handles.input1_1, 'String') ', K_D = ' get(handles.input2_1, 'String') ', N = ' get(handles.input3_1, 'String')];

                    
                case 'total'
                
                    % Calculates frac, MTfree, and Abound
                    [Frac, MTfree, Abound, Afree] = first_order(MTtot, xvals, KD, N);


                    y1 = Abound;
                    x1 = xvals;

                    xaxis = '[A] total';
                    yaxis = '[A] bound';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['First order, [MT] total = ' get(handles.input1_1, 'String') ', K_D = ' get(handles.input2_1, 'String') ', N = ' get(handles.input3_1, 'String')];

                    
                otherwise
            end

        otherwise
    end

% Cooperative binding  
elseif get(handles.curve1, 'Value') == 2

    % Determine the experimental mode
    switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
        % Binding mode is selected
        case 'binding'

            % Gets the value for [A] total and ensures that it's a
            % positive number
            Atot = str2double(get(handles.input1_1, 'String'));

            if isnan(Atot) || Atot < 0
                errorbox('Please enter a positive number for [A] total', hObject); 
                return
            end

            % Gets the value for KD and ensures that it's a
            % positive number
            KD = str2double(get(handles.input2_1, 'String'));

            if isnan(KD) || KD <= 0
                errorbox('K_D must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for phi and ensures that it's a
            % number
            p = str2double(get(handles.input3_1, 'String'));

            if isnan(p)
                errorbox('phi must be a number', hObject); 
                return
            end
            
            % Gets the binding ratio and ensures that it's a positive number
            N = str2double(get(handles.input4_1, 'String'));

            if isnan(N) || N <= 0
               errorbox('The ratio must be a number greater than 0', hObject);
               return
            end


            % Determines whether the X-axis is free MT or total MT
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'

                    % Calculates frac, MTfree, and Abound
                    [frac, MTfree, Abound, Afree] = cooperativity(xvals, Atot, KD, p, N);


                    y1 = frac;
                    x1 = MTfree;

                    xaxis = '[MT] free';
                    yaxis = 'Fraction of A bound';
                    plottitle = 'Vary [MT] Binding Assay';
                    legend1 = ['Cooperativity, [A] total = ' get(handles.input1_1, 'String') ', K_D = ' get(handles.input2_1, 'String') ', \phi = ' get(handles.input3_1, 'String')];

                case 'total'

                    % Calculates frac, MTfree, and Abound
                    [frac, MTfree, Abound, Afree] = cooperativity(xvals, Atot, KD, p, N);


                    y1 = frac;
                    x1 = xvals;

                    xaxis = '[MT] total';
                    yaxis = 'Fraction of A bound';
                    plottitle = 'Vary [MT] Binding Assay';
                    legend1 = ['Cooperativity, [A] total = ' get(handles.input1_1, 'String') ', K_D = ' get(handles.input2_1, 'String') ', \phi = ' get(handles.input3_1, 'String')];

                otherwise
            end

        % Saturation mode is selected
        case 'saturation'

            % Gets the value for [MT] total and ensures that it's a
            % positive number
            MTtot = str2double(get(handles.input1_1, 'String'));

            if isnan(MTtot) || MTtot < 0
                errorbox('Please enter a positive number for [MT] total', hObject); 
                return
            end

            % Gets the value for KD and ensures that it's a
            % positive number
            KD = str2double(get(handles.input2_1, 'String'));

            if isnan(KD) || KD <= 0
                errorbox('K_D must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for phi and ensures that it's a
            % number
            p = str2double(get(handles.input3_1, 'String'));

            if isnan(p) || p <= 0
                errorbox('phi must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the binding ratio and ensures that it's a positive number
            N = str2double(get(handles.input4_1, 'String'));

            if isnan(N) || N <= 0
               errorbox('The ratio must be a number greater than 0', hObject);
               return
            end


            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                
                case 'free'
                    
                    [Frac, MTfree, Abound, Afree] = cooperativity(MTtot, xvals, KD, p, N);

                    y1 = Abound;
                    x1 = Afree;

                    xaxis = '[A] free';
                    yaxis = '[A] bound';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['Cooperativity, [MT] total = ' get(handles.input1_1, 'String') ', K_D = ' get(handles.input2_1, 'String') ', \phi = ' get(handles.input3_1, 'String')];

                    
                case 'total'
                    
                    [Frac, MTfree, Abound, Afree] = cooperativity(MTtot, xvals, KD, p, N);

                    y1 = Abound;
                    x1 = xvals;

                    xaxis = '[A] total';
                    yaxis = '[A] bound';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['Cooperativity, [MT] total = ' get(handles.input1_1, 'String') ', K_D = ' get(handles.input2_1, 'String') ', \phi = ' get(handles.input3_1, 'String')];

                otherwise
            end
            
            
        otherwise
    end


% Seam and lattice binding
elseif get(handles.curve1, 'Value') == 3
    % Determine the experimental mode
    switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
        % Binding mode is selected
        case 'binding'

            % Gets the value for [A] total and ensures that it's a
            % positive number
            Atot = str2double(get(handles.input1_1, 'String'));

            if isnan(Atot) || Atot < 0
                errorbox('Please enter a positive number for [A] total', hObject); 
                return
            end

            % Gets the value for KS and ensures that it's a
            % positive number
            KS = str2double(get(handles.input2_1, 'String'));

            if isnan(KS) || KS <= 0
                errorbox('K_S must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for KL and ensures that it's a positive
            % number
            KL = str2double(get(handles.input3_1, 'String'));

            if isnan(KL) || KL <= 0
                errorbox('K_L must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the binding ratio and ensures that it's a positive number
            N = str2double(get(handles.input4_1, 'String'));

            if isnan(N) || N <= 0
               errorbox('The ratio must be a number greater than 0', hObject);
               return
            end


            % Determines whether the X-axis is free MT or total MT
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'

                   % Calculates fraction of A bound and free MT
                   [Frac, MTfree, Abound, Afree] = seam_lattice(xvals, Atot, KS, KL, N);
                   y1 = Frac;
                   x1 = MTfree;

                   xaxis = '[MT] free';
                   yaxis = 'Fraction of A bound';
                   plottitle = 'Vary [MT] Binding Assay';
                   legend1 = ['Seam binding, [A] total = ' get(handles.input1_1, 'String') ', K_S = ' get(handles.input2_1, 'String') ', K_L = ' get(handles.input3_1, 'String')];

                case 'total'

                    % Calculates fraction of A bound and MT free
                    [Frac, MTfree, Abound, Afree] = seam_lattice(xvals, Atot, KS, KL, N);
                    y1 = Frac;
                    x1 = xvals;

                    xaxis = '[MT] total';
                    yaxis = 'Fraction of A bound';
                    plottitle = 'Vary [MT] Binding Assay';
                    legend1 = ['Seam binding, [A] total = ' get(handles.input1_1, 'String') ', K_S = ' get(handles.input2_1, 'String') ', K_L = ' get(handles.input3_1, 'String')];

                otherwise
            end

        % Saturation mode is selected
        case 'saturation'

            % Gets the value for [MT] total and ensures that it's a
            % positive number
            MTtot = str2double(get(handles.input1_1, 'String'));

            if isnan(MTtot) || MTtot < 0
                errorbox('Please enter a positive number for [MT] total', hObject); 
                return
            end

            % Gets the value for KS and ensures that it's a
            % positive number
            KS = str2double(get(handles.input2_1, 'String'));

            if isnan(KS) || KS <= 0
                errorbox('K_S must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for KL and ensures that it's a positive
            % number
            KL = str2double(get(handles.input3_1, 'String'));

            if isnan(KL) || KL <= 0
                errorbox('K_L must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the binding ratio and ensures that it's a positive number
            N = str2double(get(handles.input4_1, 'String'));

            if isnan(N) || N <= 0
               errorbox('The ratio must be a number greater than 0', hObject);
               return
            end
            
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                
                case 'free'
                    
                    % Calculates concentration of A bound and MT free
                    [Frac, MTfree, Abound, Afree] = seam_lattice(MTtot, xvals, KS, KL, N);
                    y1 = Abound;
                    x1 = Afree;

                    xaxis = '[A] free';
                    yaxis = '[A] bound';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['Seam binding, [MT] total = ' get(handles.input1_1, 'String') ', K_S = ' get(handles.input2_1, 'String') ', K_L = ' get(handles.input3_1, 'String')];


                case 'total'
                    
                    % Calculates concentration of A bound and MT free
                    [Frac, MTfree, Abound, Afree] = seam_lattice(MTtot, xvals, KS, KL, N);
                    y1 = Abound;
                    x1 = xvals;

                    xaxis = '[A] total';
                    yaxis = '[A] bound';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['Seam binding, [MT] total = ' get(handles.input1_1, 'String') ', K_S = ' get(handles.input2_1, 'String') ', K_L = ' get(handles.input3_1, 'String')];
   
                otherwise
            end

            
        otherwise
    end


% MAPs bind MT-bound MAPS
elseif get(handles.curve1, 'Value') == 4

    % Determine the experimental mode
    switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
        % Binding mode is selected
        case 'binding'

            % Gets the value for [A] total and ensures that it's a
            % positive number
            Atot = str2double(get(handles.input1_1, 'String'));

            if isnan(Atot) || Atot < 0
                errorbox('Please enter a positive number for [A] total', hObject); 
                return
            end

            % Gets the value for KM and ensures that it's a
            % positive number
            KM = str2double(get(handles.input2_1, 'String'));

            if isnan(KM) || KM <= 0
                errorbox('K_M must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for KA and ensures that it's a positive
            % number
            KA = str2double(get(handles.input3_1, 'String'));

            if isnan(KA) || KA <= 0
                errorbox('K_A must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the binding ratio and ensures that it's a positive number
            N = str2double(get(handles.input4_1, 'String'));

            if isnan(N) || N <= 0
               errorbox('The ratio must be a number greater than 0', hObject);
               return
            end

            % Determines whether the X-axis is free MT or total MT
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'

                   % Calculates fraction of A bound and free MT
                   [Frac, MTfree, Abound, Afree] =MAP_bind(xvals, Atot, KM, KA, N);

                   y1 = Frac;
                   x1 = MTfree;

                   xaxis = '[MT] free';
                   yaxis = 'Fraction of A bound';
                   plottitle = 'Vary [MT] Binding Assay';
                   legend1 = ['MAP binding, [A] total = ' get(handles.input1_1, 'String') ', K_M = ' get(handles.input2_1, 'String') ', K_A = ' get(handles.input3_1, 'String')];

                case 'total'

                    % Calculates fraction of A bound and free MT
                    [Frac, MTfree, Abound, Afree] =MAP_bind(xvals, Atot, KM, KA, N);

                    y1 = Frac;
                    x1 = xvals;

                    xaxis = '[MT] total';
                    yaxis = 'Fraction of A bound';
                    plottitle = 'Vary [MT] Binding Assay';
                    legend1 = ['MAP binding, [A] total = ' get(handles.input1_1, 'String') ', K_M = ' get(handles.input2_1, 'String') ', K_A = ' get(handles.input3_1, 'String')];

                otherwise
            end

        % Saturation mode is selected
        case 'saturation'

            % Gets the value for [MT] total and ensures that it's a
            % positive number
            MTtot = str2double(get(handles.input1_1, 'String'));

            if isnan(MTtot) || MTtot < 0
                errorbox('Please enter a positive number for [MT] total', hObject); 
                return
            end

            % Gets the value for KM and ensures that it's a
            % positive number
            KM = str2double(get(handles.input2_1, 'String'));

            if isnan(KM) || KM <= 0
                errorbox('K_M must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for KA and ensures that it's a positive
            % number
            KA = str2double(get(handles.input3_1, 'String'));

            if isnan(KA) || KA <= 0
                errorbox('K_A must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the binding ratio and ensures that it's a positive number
            N = str2double(get(handles.input4_1, 'String'));

            if isnan(N) || N <= 0
               errorbox('The ratio must be a number greater than 0', hObject);
               return
            end

            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'
                    
                    % Calculates the concentration of A bound
                    [Frac, MTfree, Abound, Afree] = MAP_bind(MTtot, xvals, KM, KA, N);

                    y1 = Abound;
                    x1 = Afree;

                    xaxis = '[A] free';
                    yaxis = '[A] bound';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['MAP binding, [MT] total = ' get(handles.input1_1, 'String') ', K_M = ' get(handles.input2_1, 'String') ', K_A = ' get(handles.input3_1, 'String')];
                    
                case 'total'
                    
                    % Calculates the concentration of A bound
                    [Frac, MTfree, Abound, Afree] = MAP_bind(MTtot, xvals, KM, KA, N);

                    y1 = Abound;
                    x1 =xvals;

                    xaxis = '[A] total';
                    yaxis = '[A] bound';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['MAP binding, [MT] total = ' get(handles.input1_1, 'String') ', K_M = ' get(handles.input2_1, 'String') ', K_A = ' get(handles.input3_1, 'String')];

                otherwise
            end

            
        otherwise
    end

end


% Determines if comparision mode is selected and calculates the
% second curve
if strcmp(get(get(handles.plot_mode, 'SelectedObject'), 'Tag'), 'compare')
    
  if strcmp(get(get(handles.exp_mode, 'SelectedObject'), 'Tag'), 'competition')

    MTtot = str2double(get(handles.input1_2, 'String'));
    
    if isnan(MTtot) || MTtot < 0
        errorbox('Please enter a positive number for [MT] total', hObject);
        return
    end
    
    Atot = str2double(get(handles.input2_2, 'String'));
    
    if isnan(Atot) || Atot < 0
        errorbox('Please enter a positive number for [A] total', hObject);
        return
    end
    
    KA = str2double(get(handles.input3_2, 'String'));
    
    if isnan(KA) || KA < 0
        errorbox('Please enter a positive number for K_A', hObject);
        return
    end
    
    KB = str2double(get(handles.input4_2, 'String'));
    
    if isnan(KB) || KB < 0
        errorbox('Please enter a positive number for K_B', hObject);
        return
    end
    
    [frac] = competition(MTtot, Atot, xvals, KA, KB);
    
    y2 = frac;
    x2 = xvals;

    legend2 = ['[MT] total = ' get(handles.input1_2, 'String') ', [A] total = ' get(handles.input2_2, 'String') ', K_A = ' get(handles.input3_2, 'String') ', K_B = ' get(handles.input4_2, 'String') ];

  % Determines the parameters selected for curve1
  elseif get(handles.curve2, 'Value') == 1
    % First order binding

        % Determine the experimental mode
        switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
            % Binding mode is selected
            case 'binding'

                % Gets the value for [A] total and ensures that it's a
                % positive number
                Atot = str2double(get(handles.input1_2, 'String'));

                if isnan(Atot) || Atot < 0
                    errorbox('Please enter a positive number for [A] total', hObject); 
                    return
                end

                % Gets the value for KD and ensures that it's a
                % positive number
                KD = str2double(get(handles.input2_2, 'String'));

                if isnan(KD) || KD <= 0
                    errorbox('K_D must be a number greater than 0', hObject); 
                    return
                end
                
                % Gets the binding ratio and ensures that it's a positive number
                N = str2double(get(handles.input3_2, 'String'));

                if isnan(N) || N <= 0
                   errorbox('The ratio must be a number greater than 0', hObject);
                   return
                end


                % Determines whether the X-axis is free B or total B
                switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                    case 'free'

                       % Function to get fraction A bound and free MT 
                       [Frac, MTfree, Abound, Afree] = first_order(xvals, Atot, KD, N);

                       y2 = Frac;
                       x2 = MTfree;

                       legend2 = ['First order, [A] total = ' get(handles.input1_2, 'String') ', K_D = ' get(handles.input2_2, 'String') ', N = ' get(handles.input3_2, 'String')];

                    case 'total'

                       % Function to get fraction A bound
                       [Frac, MTfree, Abound, Afree] = first_order(xvals, Atot, KD, N);

                       y2 = Frac;
                       x2 = xvals;

                       legend2 = ['First order, [A] total = ' get(handles.input1_2, 'String') ', K_D = ' get(handles.input2_2, 'String') ', N = ' get(handles.input3_2, 'String')];

                    otherwise
                end

            % Saturation mode is selected
            case 'saturation'

                % Gets the value for [MT] total and ensures that it's a
                % positive number
                MTtot = str2double(get(handles.input1_2, 'String'));

                if isnan(MTtot) || MTtot < 0
                    errorbox('Please enter a positive number for [MT] total', hObject); 
                    return
                end

                % Gets the value for KD and ensures that it's a
                % positive number
                KD = str2double(get(handles.input2_2, 'String'));

                if isnan(KD) || KD <= 0
                    errorbox('K_D must be a number greater than 0', hObject); 
                    return
                end
                
                % Gets the binding ratio and ensures that it's a positive number
                N = str2double(get(handles.input3_2, 'String'));

                if isnan(N) || N <= 0
                   errorbox('The ratio must be a number greater than 0', hObject);
                   return
                end
                
                switch get(get(handles.tot_free, 'SelectedObject'), 'Tag')
                    case 'free'
                        
                        % Function to get the concentration of A bound
                        [Frac, MTfree, Abound, Afree] = first_order(MTtot, xvals, KD, N);

                        y2 = Abound;
                        x2 = Afree;

                        legend2 = ['First order, [MT] total = ' get(handles.input1_2, 'String') ', K_D = ' get(handles.input2_2, 'String') ', N = ' get(handles.input3_2, 'String')];

                    case 'total'
                        
                        % Function to get the concentration of A bound
                        [Frac, MTfree, Abound, Afree] = first_order(MTtot, xvals, KD, N);

                        y2 = Abound;
                        x2 = xvals;

                        legend2 = ['First order, [MT] total = ' get(handles.input1_2, 'String') ', K_D = ' get(handles.input2_2, 'String') ', N = ' get(handles.input3_2, 'String')];

                    otherwise
                end

                
            otherwise
        end

    % Cooperative binding  
    elseif get(handles.curve2, 'Value') == 2

        % Determine the experimental mode
        switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
            % Binding mode is selected
            case 'binding'

                % Gets the value for [A] total and ensures that it's a
                % positive number
                Atot = str2double(get(handles.input1_2, 'String'));

                if isnan(Atot) || Atot < 0
                    errorbox('Please enter a positive number for [A] total', hObject); 
                    return
                end

                % Gets the value for KD and ensures that it's a
                % positive number
                KD = str2double(get(handles.input2_2, 'String'));

                if isnan(KD) || KD <= 0
                    errorbox('K_D must be a number greater than 0', hObject); 
                    return
                end

                % Gets the value for p and ensures that it's a
                % number
                p = str2double(get(handles.input3_2, 'String'));

                if isnan(p) || p <= 0
                    errorbox('phi must be a number greater than 0', hObject); 
                    return
                end
                
                % Gets the binding ratio and ensures that it's a positive number
                N = str2double(get(handles.input4_2, 'String'));

                if isnan(N) || N <= 0
                   errorbox('The ratio must be a number greater than 0', hObject);
                   return
                end

                % Determines whether the X-axis is free MT or total MT
                switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                    case 'free'

                       % Function to get fraction A bound and free MT 
                       [Frac, MTfree, Abound, Afree] = cooperativity(xvals, Atot, KD, p, N);

                       y2 = Frac;
                       x2 = MTfree;

                       legend2 = ['Cooperativity, [A] total = ' get(handles.input1_2, 'String') ', K_D = ' get(handles.input2_2, 'String') ', \phi = ' get(handles.input3_2, 'String')];

                    case 'total'

                       % Function to get fraction A bound
                       [Frac, MTfree, Abound, Afree] = cooperativity(xvals, Atot, KD, p, N);

                       y2 = Frac;
                       x2 = xvals;

                       legend2 = ['Cooperativity, [A] total = ' get(handles.input1_2, 'String') ', K_D = ' get(handles.input2_2, 'String') ', \phi = ' get(handles.input3_2, 'String')];

                    otherwise
                end

            % Saturation mode is selected
            case 'saturation'

                % Gets the value for [MT] total and ensures that it's a
                % positive number
                MTtot = str2double(get(handles.input1_2, 'String'));

                if isnan(MTtot) || MTtot < 0
                    errorbox('Please enter a positive number for [MT] total', hObject); 
                    return
                end

                % Gets the value for KD and ensures that it's a
                % positive number
                KD = str2double(get(handles.input2_2, 'String'));

                if isnan(KD) || KD <= 0
                    errorbox('K_D must be a number greater than 0', hObject); 
                    return
                end

                % Gets the value for p and ensures that it's a
                % number
                p = str2double(get(handles.input3_2, 'String'));

                if isnan(p)
                    errorbox('phi must be a number', hObject); 
                    return
                end
                
                % Gets the binding ratio and ensures that it's a positive number
                N = str2double(get(handles.input4_2, 'String'));

                if isnan(N) || N <= 0
                   errorbox('The ratio must be a number greater than 0', hObject);
                   return
                end

                switch get(get(handles.tot_free, 'SelectedObject'), 'Tag')
                    case 'free'
                        
                        % Function to get the concentration of A bound
                        [Frac, MTfree, Abound, Afree] = cooperativity(MTtot, xvals, KD, p, N);

                        y2 = Abound;
                        x2 = Afree;

                        legend2 = ['Cooperativity, [MT] total = ' get(handles.input1_2, 'String') ', K_D = ' get(handles.input2_2, 'String') ', \phi = ' get(handles.input3_2, 'String')];

                    case 'total'
                        
                        % Function to get the concentration of A bound
                        [Frac, MTfree, Abound, Afree] = cooperativity(MTtot, xvals, KD, p, N);

                        y2 = Abound;
                        x2 = xvals;

                        legend2 = ['Cooperativity, [MT] total = ' get(handles.input1_2, 'String') ', K_D = ' get(handles.input2_2, 'String') ', \phi = ' get(handles.input3_2, 'String')];

                    otherwise
                end
            otherwise
        end


    % Seam and lattice binding
    elseif get(handles.curve2, 'Value') == 3
        % Determine the experimental mode
        switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
            % Binding mode is selected
            case 'binding'

                % Gets the value for [A] total and ensures that it's a
                % positive number
                Atot = str2double(get(handles.input1_2, 'String'));

                if isnan(Atot) || Atot < 0
                    errorbox('Please enter a positive number for [A] total', hObject); 
                    return
                end

                % Gets the value for KS and ensures that it's a
                % positive number
                KS = str2double(get(handles.input2_2, 'String'));

                if isnan(KS) || KS <= 0
                    errorbox('K_S must be a number greater than 0', hObject); 
                    return
                end

                % Gets the value for KL and ensures that it's a positive
                % number
                KL = str2double(get(handles.input3_2, 'String'));

                if isnan(KL) || KL <= 0
                    errorbox('K_L must be a number greater than 0', hObject); 
                    return
                end
                
                % Gets the binding ratio and ensures that it's a positive number
                N = str2double(get(handles.input4_2, 'String'));

                if isnan(N) || N <= 0
                   errorbox('The ratio must be a number greater than 0', hObject);
                   return
                end

                % Determines whether the X-axis is free MT or total MT
                switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                    case 'free'

                       % Function to get fraction A bound and free MT 
                       [Frac, MTfree, Abound, Afree] = seam_lattice(xvals, Atot, KS, KL, N);

                       y2 = Frac;
                       x2 = MTfree;

                       legend2 = ['Seam binding, [A] total = ' get(handles.input1_2, 'String') ', K_S = ' get(handles.input2_2, 'String') ', K_L = ' get(handles.input3_2, 'String')];

                    case 'total'

                        % Function to get fraction A bound
                        [Frac, MTfree, Abound, Afree] = seam_lattice(xvals, Atot, KS, KL, N);

                        y2 = Frac;
                        x2 = xvals;

                        legend2 = ['Seam binding, [A] total = ' get(handles.input1_2, 'String') ', K_S = ' get(handles.input2_2, 'String') ', K_L = ' get(handles.input3_2, 'String')];

                    otherwise
                end

            % Saturation mode is selected
            case 'saturation'

                % Gets the value for [MT] total and ensures that it's a
                % positive number
                MTtot = str2double(get(handles.input1_2, 'String'));

                if isnan(MTtot) || MTtot < 0
                    errorbox('Please enter a positive number for [MT] total', hObject); 
                    return
                end

                % Gets the value for KS and ensures that it's a
                % positive number
                KS = str2double(get(handles.input2_2, 'String'));

                if isnan(KS) || KS <= 0
                    errorbox('K_S must be a number greater than 0', hObject); 
                    return
                end

                % Gets the value for KL and ensures that it's a positive
                % number
                KL = str2double(get(handles.input3_2, 'String'));

                if isnan(KL) || KL <= 0
                    errorbox('K_L must be a number greater than 0', hObject); 
                    return
                end
                
                % Gets the binding ratio and ensures that it's a positive number
                N = str2double(get(handles.input4_2, 'String'));

                if isnan(N) || N <= 0
                   errorbox('The ratio must be a number greater than 0', hObject);
                   return
                end
                
                switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                    case 'free'
                        
                        % Function to get the concentration of A bound
                        [Frac, MTfree, Abound, Afree] = seam_lattice(MTtot, xvals, KS, KL, N);

                        y2 = Abound;
                        x2 = Afree;

                        legend2 = ['Seam binding, [MT] total = ' get(handles.input1_2, 'String') ', K_S = ' get(handles.input2_2, 'String') ', K_L = ' get(handles.input3_2, 'String')];
                        
                    case 'total'
                        
                        % Function to get the concentration of A bound
                        [Frac, MTfree, Abound, Afree] = seam_lattice(MTtot, xvals, KS, KL, N);

                        y2 = Abound;
                        x2 = xvals;

                        legend2 = ['Seam binding, [MT] total = ' get(handles.input1_2, 'String') ', K_S = ' get(handles.input2_2, 'String') ', K_L = ' get(handles.input3_2, 'String')];
                        
                    otherwise
                end 
            otherwise
        end


    % MAPs bind MT-bound MAPS
    elseif get(handles.curve2, 'Value') == 4

        % Determine the experimental mode
        switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
            % Binding mode is selected
            case 'binding'

                % Gets the value for [A] total and ensures that it's a
                % positive number
                Atot = str2double(get(handles.input1_2, 'String'));

                if isnan(Atot) || Atot < 0
                    errorbox('Please enter a positive number for [A] total', hObject); 
                    return
                end

                % Gets the value for KM and ensures that it's a
                % positive number
                KM = str2double(get(handles.input2_2, 'String'));

                if isnan(KM) || KM <= 0
                    errorbox('K_M must be a number greater than 0', hObject); 
                    return
                end

                % Gets the value for KA and ensures that it's a positive
                % number
                KA = str2double(get(handles.input3_2, 'String'));

                if isnan(KA) || KA <= 0
                    errorbox('K_A must be a number greater than 0', hObject); 
                    return
                end
                
                % Gets the binding ratio and ensures that it's a positive number
                N = str2double(get(handles.input4_2, 'String'));

                if isnan(N) || N <= 0
                   errorbox('The ratio must be a number greater than 0', hObject);
                   return
                end

                % Determines whether the X-axis is free MT or total MT
                switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                    case 'free'

                       % Function to get fraction A bound and free MT 
                       [Frac, MTfree, Abound, Afree] = MAP_bind(xvals, Atot, KM, KA, N);

                       y2 = Frac;
                       x2 = MTfree;

                       legend2 = ['MAP binding, [A] total = ' get(handles.input1_2, 'String') ', K_M = ' get(handles.input2_2, 'String') ', K_A = ' get(handles.input3_2, 'String')];

                    case 'total'

                        % Function to get fraction A bound
                        [Frac, MTfree, Abound, Afree] = MAP_bind(xvals, Atot, KM, KA, N);

                        y2 = Frac;
                        x2 = xvals;

                        legend2 = ['MAP binding, [A] total = ' get(handles.input1_2, 'String') ', K_M = ' get(handles.input2_2, 'String') ', K_A = ' get(handles.input3_2, 'String')];

                    otherwise
                end

            % Saturation mode is selected
            case 'saturation'

                % Gets the value for [MT] total and ensures that it's a
                % positive number
                MTtot = str2double(get(handles.input1_2, 'String'));

                if isnan(MTtot) || MTtot < 0
                    errorbox('Please enter a positive number for [MT] total', hObject); 
                    return
                end

                % Gets the value for KM and ensures that it's a
                % positive number
                KM = str2double(get(handles.input2_2, 'String'));

                if isnan(KM) || KM <= 0
                    errorbox('K_M must be a number greater than 0', hObject); 
                    return
                end

                % Gets the value for KA and ensures that it's a positive
                % number
                KA = str2double(get(handles.input3_2, 'String'));

                if isnan(KA) || KA <= 0
                    errorbox('K_A must be a number greater than 0', hObject); 
                    return
                end
                
                % Gets the binding ratio and ensures that it's a positive number
                N = str2double(get(handles.input4_2, 'String'));

                if isnan(N) || N <= 0
                   errorbox('The ratio must be a number greater than 0', hObject);
                   return
                end
                
                switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                    case 'free'
                        
                         % Function to get the concentration of A bound
                        [Frac, MTfree, Abound, Afree] = MAP_bind(MTtot, xvals, KM, KA, N);

                        y2 = Abound;
                        x2 = Afree;

                        legend2 = ['MAP binding, [MT] total = ' get(handles.input1_2, 'String') ', K_M = ' get(handles.input2_2, 'String') ', K_A = ' get(handles.input3_2, 'String')];

                        
                    case 'total'
                        
                         % Function to get the concentration of A bound
                        [Frac, MTfree, Abound, Afree] = MAP_bind(MTtot, xvals, KM, KA, N);

                        y2 = Abound;
                        x2 = xvals;

                        legend2 = ['MAP binding, [MT] total = ' get(handles.input1_2, 'String') ', K_M = ' get(handles.input2_2, 'String') ', K_A = ' get(handles.input3_2, 'String')];

                        
                    otherwise
                end
            otherwise
        end

    end

    
end

% Create a graph window if necessary
if (ishandle(handles.graphfigure) == 0 || ishandle(handles.graphaxes == 0))
    handles.graphfigure = figure;
    handles.graphaxes = axes;
end

% Activate the graph window
figure(handles.graphfigure);

%plots the x and y data
hold on
h = plot(handles.graphaxes, x1, y1);
xlabel(xaxis);
ylabel(yaxis);
title(plottitle);

add_legend(handles, legend1);

% Rotates through the availble MatLab colors, colors the plot, and
% displays the color in the color readout
if rem(handles.color,7) == 0
    set(h,'color','blue');
elseif rem(handles.color,7) ==1
    set(h,'color','red');
elseif rem(handles.color,7) ==2
    set(h,'color',[1 0.65 0]);
elseif rem(handles.color,7) ==3
    set(h,'color','green');
elseif rem(handles.color,7) ==4
    set(h,'color','magenta');
elseif rem(handles.color,7) ==5
    set(h,'color','cyan');
elseif rem(handles.color,7) ==6
    set(h,'color','black');
end
handles.color = handles.color +1;


% Determines if comparision mode is selected and calculates the
% second curve
if strcmp(get(get(handles.plot_mode, 'SelectedObject'), 'Tag'), 'compare')
    
    %plots the x and y data
    hold on
    h = plot(handles.graphaxes, x2, y2);
    
    add_legend(handles, legend2);

    % Rotates through the availble MatLab colors, colors the plot, and
    % displays the color in the color readout
    if rem(handles.color,7) == 0
        set(h,'color','blue');
    elseif rem(handles.color,7) ==1
        set(h,'color','red');
    elseif rem(handles.color,7) ==2
        set(h,'color',[1 0.65 0]);
    elseif rem(handles.color,7) ==3
        set(h,'color','green');
    elseif rem(handles.color,7) ==4
        set(h,'color','magenta');
    elseif rem(handles.color,7) ==5
        set(h,'color','cyan');
    elseif rem(handles.color,7) ==6
        set(h,'color','black');
    end
    handles.color = handles.color +1;
    
    % Computes and displays the difference between the two curves
    
    % Computes absolute and percent differences, then calculates the
    % average and maximum values of each
    diff = abs(y1-y2);
    per = 100*diff./(1/2.*(y1 + y2));
    
    % Finds the maximum average and percent difference and their locations
    [a, b] = size(x1);
    
    maxdiff = 0;
    maxper = 0;
    xmaxdiff = 0;
    xmaxper = 0;
    
    for n = 1:b
        if isnan(diff(n))
            diff(n) = 0;
        end
        if isnan(per(n))
            per(n) = 0;
        end
        if diff(n) > maxdiff
            maxdiff = diff(n);
            xmaxdiff = x1(n);
        end
        if per(n) > maxper
            maxper = per(n);
            xmaxper = x1(n);
        end
        
    end
    
    avgdiff = mean(diff);
    avgper = mean(per);
    
    % Displays the differences between the curves
    
    set(handles.result, 'String', {['Average absolute difference: ' num2str(avgdiff)] ;...
        ['Average percent difference: ' num2str(avgper) '%'] ;...
        ['Maximum absolute difference is ' num2str(maxdiff) ' at ' num2str(xmaxdiff) ' ' xaxis] ;...
        ['Maxmum percent difference is ' num2str(maxper) '% at ' num2str(xmaxper) ' ' xaxis]})
end
    
% Updates the handles
guidata(hObject, handles);

enableButtons(handles.mainfigure);
end



function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Close the graph figure if it exists
if ishandle(handles.graphaxes)
    delete(handles.graphaxes);
    handles.graphaxes = -1;
end
if ishandle(handles.graphfigure)
    delete(handles.graphfigure);
    handles.graphfigure = -1;
end

% Resets the color counter
handles.color = 0;

% Updates the handles
guidata(hObject, handles);
end



function exp_mode_SelectionChangeFcn(hObject, eventdata)

% Retrieve GUI data, i.e. the handles structure
handles = guidata(hObject); 

% Creates a dialog box notifying the user that the axes will be cleared and
% asking them if they want to proceed
if (ishandle(handles.graphaxes) || ishandle(handles.graphfigure))
    clear = questdlg('Changing the experimental mode will automatically close the graph window. Do you want to continue?', 'Close Graph Window?', 'Yes','No','No');
    
    % Returns the selection to is previous value and stops evaluating further
    % code if the user selects no
    if strcmp(clear, 'No')
        set(handles.exp_mode, 'SelectedObject', eventdata.OldValue);
        % Updates the handles
        guidata(hObject, handles);
        return
    end
    
    if (ishandle(handles.graphaxes))
        delete(handles.graphaxes);
        handles.graphaxes = -1;
    end
    if (ishandle(handles.graphfigure))
        delete(handles.graphfigure);
        handles.graphfigure = -1;
    end
end

% Get tag of selected buton
switch get(eventdata.NewValue, 'Tag')
    case 'binding'
        
        % Makes the curve selection drop down boxes visible
        set(handles.curve1, 'Visible', 'on');
        
        % Makes the X-axis selection box visible
        set(handles.tot_free, 'Visible', 'on');
        
        % Gets the current value of the first curve slection box and
        % changes the visible boxes accordingly
        switch get(handles.curve1, 'Value')
            % First order biding selected
            case 1
                
                first_order_binding_labels1(hObject);
            
            % Cooperative binding selected
            case 2
                
                cooperativity_binding_labels1(hObject);
                
            % Seam and lattice binding selected
            case 3
                
                seam_binding_labels1(hObject);
                
            % MAPs bind MT-bound MAPs selected
            case 4
                
                MAP_binding_labels1(hObject);
                
            otherwise
        end
        
        % Determines if single or comparision mode is selected
        % Changes visible boxes for the second curve if comparision mode is
        % selected
        if strcmp(get(get(handles.plot_mode, 'SelectedObject'), 'Tag'), 'compare')
            
            % Makes the curve selction box visible
            set(handles.curve2, 'Visible', 'on');
            
            % Gets the current value of the first curve slection box and
            % changes the visible boxes accordingly
            switch get(handles.curve2, 'Value');
                % First order biding selected
                case 1
                
                    first_order_binding_labels2(hObject);
            
                % Cooperative binding selected
                case 2
                
                    cooperativity_binding_labels2(hObject);
               
                % Seam and lattice binding selected
                case 3
                
                    seam_binding_labels2(hObject);
                
                % MAPs bind MT-bound MAPs selected
                case 4
                
                    MAP_binding_labels2(hObject);
                
                otherwise
            end
            
        end
        
    case 'saturation'
        
        % Makes the curve selection drop down boxes visible
        set(handles.curve1, 'Visible', 'on');
        
        % Makes the X-axis selection box visible
        set(handles.tot_free, 'Visible', 'on');

        % Gets the current value of the first curve slection box and
        % changes the visible boxes accordingly
        switch get(handles.curve1, 'Value');
            % First order biding selected
            case 1
                
                first_order_saturation_labels1(hObject);
            
            % Cooperative binding selected
            case 2
                
                cooperativity_saturation_labels1(hObject);
                
            % Seam and lattice binding selected
            case 3
                
                seam_saturation_labels1(hObject);
                
            % MAPs bind MT-bound MAPs selected
            case 4
                
                MAP_saturation_labels1(hObject);
                
            otherwise
        end
        
        % Determines if single or comparision mode is selected
        % Changes visible boxes for the second curve if comparision mode is
        % selected
        if strcmp(get(get(handles.plot_mode, 'SelectedObject'), 'Tag'), 'compare')
            
            % Makes the curve selection box visible
            set(handles.curve2, 'Visible', 'on');
            
            % Gets the current value of the second curve slection box and
            % changes the visible boxes accordingly
            switch get(handles.curve2, 'Value');
                % First order biding selected
                case 1
                
                    first_order_saturation_labels2(hObject);
            
                % Cooperative binding selected
                case 2
                
                    cooperativity_saturation_labels2(hObject);
                
                % Seam and lattice binding selected
                case 3
                
                    seam_saturation_labels2(hObject);
                
                % MAPs bind MT-bound MAPs selected
                case 4
                
                    MAP_saturation_labels2(hObject);
                
                otherwise
            end
            
        end
        
    case 'competition'
        
        % Sets the visibility of the x-axis selection box
        set(handles.tot_free, 'Visible', 'off');
        
        % Makes the curve selection drop down boxes invisible
        set(handles.curve1, 'Visible', 'off');
        set(handles.curve2, 'Visible', 'off');
        
        competition_labels1(hObject);
        
        if strcmp(get(get(handles.plot_mode, 'SelectedObject'), 'Tag'), 'compare')
            
            competition_labels2(hObject);
        end
        
        
    otherwise
end

% Retreives the new guidata after the input boxes have been changed
handles = guidata(hObject);

% Resets the color counter
handles.color = 0;

% Updates the handles
guidata(hObject, handles);
end



function plot_mode_SelectionChangeFcn(hObject, eventdata)

% Retrieve GUI data, i.e. the handles structure
handles = guidata(hObject); 

% Get tag of selected buton
switch get(eventdata.NewValue, 'Tag')
    case 'single'
        
        inputboxes_display2(hObject, 0);
        set(handles.curve2, 'Visible', 'off');
        set(handles.model2, 'Visible', 'off');
        set(handles.equation2, 'Visible', 'off');
        set(handles.result, 'Visible', 'off');
        
    case 'compare'
        
        % Sets the curve selection box and curve data boxes as visible
        set(handles.curve2, 'Visible', 'on');
        set(handles.model2, 'Visible', 'on');
        set(handles.equation2, 'Visible', 'on');
        set(handles.result, 'Visible', 'on');
        
        % Determines which experimenal mode is selected and sets the imput
        % boxes accordingly
        switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
           
            case 'binding'
                
                switch get(handles.curve2, 'Value')
                    
                    case 1
                        
                        first_order_binding_labels2(hObject);
                        
                    case 2
                        
                        cooperatiivty_binding_labels2(hObject);
                        
                    case 3
                        
                        seam_binding_labels2(hObject);
                        
                    case 4
                        
                        MAP_binding_labels2(hObject);
                        
                    otherwise
                end
                
            case 'saturation'
                
                switch get(handles.curve2, 'Value')
                    
                    case 1
                        
                        first_order_saturation_labels2(hObject);
                        
                    case 2
                        
                        cooperatiivty_saturation_labels2(hObject);
                        
                    case 3
                        
                        seam_saturation_labels2(hObject);
                        
                    case 4
                        
                        MAP_saturation_labels2(hObject);
                        
                    otherwise
                end
                
                
            case 'competition'
                
                set(handles.curve2, 'Visible', 'off');
                competition_labels2(hObject);
                
            otherwise
        end
        
    otherwise
end
end

function tot_free_SelectionChangeFcn(hObject, eventdata)

% Retrieve GUI data, i.e. the handles structure
handles = guidata(hObject); 

% Creates a dialog box notifying the user that the axes will be cleared and
% asking them if they want to proceed
if (ishandle(handles.graphaxes) || ishandle(handles.graphfigure))
    clear = questdlg('Changing the experimental mode will automatically close the graph window. Do you want to continue?', 'Close Graph Window?', 'Yes','No','No');
    
    % Returns the selection to is previous value and stops evaluating further
    % code if the user selects no
    if strcmp(clear, 'No')
        set(handles.tot_free, 'SelectedObject', eventdata.OldValue);
        % Updates the handles
        guidata(hObject, handles);
        return
    end
    
    if (ishandle(handles.graphaxes))
        delete(handles.graphaxes);
        handles.graphaxes = -1;
    end
    if (ishandle(handles.graphfigure))
        delete(handles.graphfigure);
        handles.graphfigure = -1;
    end
end

end


function first_order_strings(model, equation)
global KD;
set_java_component(model, 'A + MT &harr; AMT');
set_java_component(equation, [KD, ' = [A][MT]/[AMT]']);
end

function cooperativity_strings(model, equation)
global KD;
set_java_component(model, 'A + MT &harr; AMT, A + AMT &harr; A<sub><small>2</small></sub>MT');
set_java_component(model, [KD, ' = [A][MT]/[AMT], &phi;&sdot;', KD, ' = [A][AMT]/[A<sub><small>2</small</sub>MT]']);
end

function seam_strings(model, equation)
global KS KL;
set_java_component(model, 'A + S &harr; AS, A + L &harr; AL');
set_java_component(equation, [KL, ' = [A][L]/[AL], ', KS, ' = [A][S]/[AS]']);
end

function MAP_strings(model, equation)
global KM KA;
set_java_component(model, 'A + MT &harr; AMT, A + AMT &harr; A<sub><small>2</small></sub>MT');
set_java_component(equation, [KM, ' = [A][MT]/[AMT], ', KA, ' = [A][AMT]/[A<sub><small>2</small></sub>MT]']);
end

function competition_strings(model, equation)
global KA KB;
set_java_component(model, 'A + MT &harr; AMT, B + MT &harr; BMT');
set_java_component(equation, [KA, ' =[A][MT]/[AMT], ', KB, ' =[B][MT]/[BMT]']);
end


function first_order_binding_labels1(hObject)
% Function to update the apperence of MTBindingSim for the case where the
% first function is first order binding in binding mode

global KD;

% Sets the visibility for all input boxes
inputboxes_display1(hObject, 3);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the equation and model text
first_order_strings(handles.model1, handles.equation1);


% Sets labels for the visible input boxes
set(handles.label_xmin, 'String', '[MT] total min ');
set(handles.label_xmax, 'String', '[MT] total max ');
set(handles.total, 'String', '[MT] total');
set(handles.free, 'String', '[MT] free');
set_java_component(handles.label1_1, '[A] total');
set_java_component(handles.label2_1, [KD, ' ']);
set_java_component(handles.label3_1, '1 MT : ');
set_java_component(handles.units3_1, 'A');

% Updates the handles structure
guidata(hObject, handles);

end



function first_order_saturation_labels1(hObject)
% Function to update the appearence of binding_BUI for the case where the
% frist function is first oder binding in saturation mode

global KD;

% Sets the visibility for all input boxes
inputboxes_display1(hObject, 3);

handles = guidata(hObject);

% Sets the equation and model text
first_order_strings(handles.model1, handles.equation1);

%Sets labels for the input boxes
set(handles.label_xmin, 'String', '[A] total min ');
set(handles.label_xmax, 'String', '[A] total max ');
set(handles.total, 'String', '[A] total');
set(handles.free, 'String', '[A] free');
set_java_component(handles.label1_1, '[MT] total ');
set_java_component(handles.label2_1, [KD, ' ']);
set_java_component(handles.label3_1, '1 MT : ');
set_java_component(handles.units3_1, 'A');

% Updates the handles structure
guidata(hObject, handles);

end



function cooperativity_binding_labels1(hObject)
% Function to update the appearence of MTBindingSim for the case where the
% first function is cooperative binding in binding mode

global KD;

% Sets the visibility for all input boxes
inputboxes_display1(hObject, 4);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the equations and model text
cooperativity_strings(handles.model1, handles.equation1);
                
% Sets labels for the input boxes
set(handles.label_xmin, 'String', '[MT] total min ');
set(handles.label_xmax, 'String', '[MT] total max ');
set(handles.total, 'String', '[MT] total');
set(handles.free, 'String', '[MT] free');
set_java_component(handles.label1_1, '[A] total ');
set_java_component(handles.label2_1, [KD, ' ']);
set_java_component(handles.label3_1, '&phi; ');
set_java_component(handles.label4_1, '1 MT : ');
set_java_component(handles.units4_1, 'A');

% Hides the units label for p
set(handles.units3_1, 'Visible', 'off');

% Updates the handles structure
guidata(hObject, handles);

end



function cooperativity_saturation_labels1(hObject)
%Function to update the appearance of MTBindingSim for the case where the
%first function is cooperative binding in saturation mode

global KD;

% Sets the visibility for all input boxes
inputboxes_display1(hObject, 4);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the equations and model text
cooperativity_strings(handles.model1, handles.equation1);

%Sets labels for the input boxes
set(handles.label_xmin, 'String', '[A] total min ');
set(handles.label_xmax, 'String', '[A] total max ');
set(handles.total, 'String', '[A] total');
set(handles.free, 'String', '[A] free');
set_java_component(handles.label1_1, '[MT] total ');
set_java_component(handles.label2_1, [KD, ' ']);
set_java_component(handles.label3_1, '&phi; ');
set_java_component(handles.label4_1, '1 MT : ');
set_java_component(handles.units4_1, 'A');

% Hides the units label for p
set(handles.units3_1, 'Visible', 'off');

% Updates the handles structure
guidata(hObject, handles);

end



function seam_binding_labels1(hObject)
% Function to update the appearence of MTBindingSim for the case where the
% first function is seam and lattice binding in binding mode

global KS KL UM;

% Sets the visibility for all input boxes
inputboxes_display1(hObject, 4);

% Retreives the GUI handles structure
handles = guidata(hObject);

%Set model and equation text
seam_strings(handles.model1, handles.equation1);

% Sets labels for the input boxes
set(handles.label_xmin, 'String', '[MT] total min ');
set(handles.label_xmax, 'String', '[MT] total max ');
set(handles.total, 'String', '[MT] total');
set(handles.free, 'String', '[MT] free');
set_java_component(handles.label1_1, '[A] total ');
set_java_component(handles.label2_1, [KS, ' ']);
set_java_component(handles.label3_1, [KL, ' ']);
set_java_component(handles.units3_1, [UM, ' ']);
set_java_component(handles.label4_1, '1 MT : ');
set_java_component(handles.units4_1, 'A');

% Updates the handles structure
guidata(hObject, handles);

end



function seam_saturation_labels1(hObject)
% Function to update the appearence of MTBindingSim for the case where the
% first function is seam and lattice binding in saturation mode

global KS KL UM;

% Sets the visibility for all input boxes
inputboxes_display1(hObject, 4);

% Retreives the GUI handles structure
handles = guidata(hObject);

%Set model and equation text
seam_strings(handles.model1, handles.equation1);

% Sets labels for the input boxes
set(handles.label_xmin, 'String', '[A] total min ');
set(handles.label_xmax, 'String', '[A] total max ');
set(handles.total, 'String', '[A] total');
set(handles.free, 'String', '[A] free');
set_java_component(handles.label1_1, '[MT] total ');
set_java_component(handles.label2_1, [KS, ' ']);
set_java_component(handles.label3_1, [KL, ' ']);
set_java_component(handles.units3_1, [UM, ' ']);
set_java_component(handles.label4_1, '1 MT : ');
set_java_component(handles.units4_1, 'A');

% Updates the handles structure
guidata(hObject, handles);

end



function MAP_binding_labels1(hObject)
%Function to update the appearance of MTBindingSim for the case where the
%first function is the MAPs bind to MT-bound MAPs model in binding mode

global KM KA UM;

% Sets the visibility for all input boxes
inputboxes_display1(hObject, 4);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets model equation and text
MAP_strings(handles.model1, handles.equation1);

% Sets labels for the input boxes
set(handles.label_xmin, 'String', '[MT] total min ');
set(handles.label_xmax, 'String', '[MT] total max ');
set(handles.total, 'String', '[MT] total');
set(handles.free, 'String', '[MT] free');
set_java_component(handles.label1_1, '[A] total ');
set_java_component(handles.label2_1, [KM, ' ']);
set_java_component(handles.label3_1, [KA, ' ']);
set_java_component(handles.units3_1, [UM, ' ']);
set_java_component(handles.label4_1, '1 MT : ');
set_java_component(handles.units4_1, 'A');

% Updates the handles structure
guidata(hObject, handles);

end



function MAP_saturation_labels1(hObject)
%Function to update the appearance of MTBindingSim for the case where the
%first function is the MAPs bind to MT-bound MAPs model in saturation mode

global KM KA UM;

% Sets the visibility for all input boxes
inputboxes_display1(hObject, 4);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets model equation and text
MAP_strings(handles.model1, handles.equation1);

% Sets labels for the input boxes
set(handles.label_xmin, 'String', '[A] total min ');
set(handles.label_xmax, 'String', '[A] total max ');
set(handles.total, 'String', '[A] total');
set(handles.free, 'String', '[A] free');
set_java_component(handles.label1_1, '[MT] total ');
set_java_component(handles.label2_1, [KM, ' ']);
set_java_component(handles.label3_1, [KA, ' ']);
set_java_component(handles.units3_1, [UM, ' ']);
set_java_component(handles.label4_1, '1 MT : ');
set_java_component(handles.units4_1, 'A');

% Updates the handles structure
guidata(hObject, handles);

end


function competition_labels1(hObject)
% Function to update the appearnce of MTBindingSIm for the case where
% the competition experimental mode is selected

global KA KB UM;

% Sets the visibility for all imput boxes
inputboxes_display1(hObject, 4);

handles = guidata(hObject);

% Sets the equation and model text
competition_strings(handles.model1, handles.equation1);

% Sets the labels for the visible imput boxes
set(handles.label_xmin, 'String', '[B] total min ');
set(handles.label_xmax, 'String', '[B] total max ');
set_java_component(handles.label1_1, '[MT] total ');
set_java_component(handles.label2_1, '[A] total ');
set_java_component(handles.label3_1, [KA, ' ']);
set_java_component(handles.units3_1, [UM, ' ']);
set_java_component(handles.label4_1, [KB, ' ']);
set_java_component(handles.units4_1, [UM, ' ']);

% Updates the handles structure
guidata(hObject, handles);

end





function first_order_binding_labels2(hObject)
% Function to update the apperence of MTBindingSim for the case where the
% first function is first order binding in binding mode

global KD;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 3);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the equation and model text
first_order_strings(handles.model2, handles.equation2);

% Sets labels for the visible input boxes
set_java_component(handles.label1_2, '[A] total ');
set_java_component(handles.label2_2, [KD, ' ']);
set_java_component(handles.label3_2, '1 MT : ');
set_java_component(handles.units3_2, 'A');

% Updates the handles structure
guidata(hObject, handles);

end


function first_order_saturation_labels2(hObject)
% Function to update the appearence of MTBindingSim for the case where the
% frist function is first oder binding in saturation mode

global KD;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 3);

handles = guidata(hObject);

% Sets the equation and model text
first_order_strings(handles.model2, handles.equation2);

% Sets labels for the input boxes
set_java_component(handles.label1_2, '[MT] total ');
set_java_component(handles.label2_2, [KD, ' ']);
set_java_component(handles.label3_2, '1 MT : ');
set_java_component(handles.units3_2, 'A');

% Updates the handles structure
guidata(hObject, handles);

end



function cooperativity_binding_labels2(hObject)
% Function to update the appearence of MTBindingSim for the case where the
% first function is cooperative binding in binding mode

global KD;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 4);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the equations and model text
cooperativity_strings(handles.model2, handles.equation2);
                
% Sets labels for the input boxes
set_java_component(handles.label1_2, '[A] total ');
set_java_component(handles.label2_2, [KD, ' ']);
set_java_component(handles.label3_2, '&phi; ');
set_java_component(handles.label4_2, '1 MT : ');
set_java_component(handles.units4_2, 'A');

% Hides the units label for phi
set(handles.units3_2, 'Visible', 'off');

% Updates the handles structure
guidata(hObject, handles);

end



function cooperativity_saturation_labels2(hObject)
%Function to update the appearance of MTBindingSim for the case where the
%first function is cooperative binding in saturation mode

global KD;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 4);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the equations and model text
cooperativity_strings(handles.model2, handles.equation2);

%Sets labels for the input boxes
set_java_component(handles.label1_2, '[MT] total ');
set_java_component(handles.label2_2, [KD, ' ']);
set_java_component(handles.label3_2, '&phi; ');
set_java_component(handles.label4_2, '1 MT : ');
set_java_component(handles.units4_2, 'A');

% Hides the units label for p
set(handles.units3_2, 'Visible', 'off');

% Updates the handles structure
guidata(hObject, handles);

end


function seam_binding_labels2(hObject)
% Function to update the appearence of MTBindingSim for the case where the
% first function is seam and lattice binding in binding mode

global KS KL UM;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 4);

% Retreives the GUI handles structure
handles = guidata(hObject);

%Set model and equation text
seam_strings(handles.model2, handles.equation2);

% Sets labels for the input boxes
set_java_component(handles.label1_2, '[A] total ');
set_java_component(handles.label2_2, [KS, ' ']);
set_java_component(handles.label3_2, [KL, ' ']);
set_java_component(handles.units3_2, [UM, ' ']);
set_java_component(handles.label4_2, '1 MT : ');
set_java_component(handles.units4_2, 'A');

% Updates the handles structure
guidata(hObject, handles);

end



function seam_saturation_labels2(hObject)
% Function to update the appearence of MTBindingSim for the case where the
% first function is seam and lattice binding in saturation mode

global KS KL UM;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 4);

% Retreives the GUI handles structure
handles = guidata(hObject);

%Set model and equation text
seam_strings(handles.model2, handles.equation2);

% Sets labels for the input boxes
set_java_component(handles.label1_2, '[MT] total ');
set_java_component(handles.label2_2, [KS, ' ']);
set_java_component(handles.label3_2, [KL, ' ']);
set_java_component(handles.units3_2, [UM, ' ']);
set_java_component(handles.label4_2, '1 MT : ');
set_java_component(handles.units4_2, 'A');

% Updates the handles structure
guidata(hObject, handles);

end


function MAP_binding_labels2(hObject)
%Function to update the appearance of MTBindingSim for the case where the
%first function is the MAPs bind to MT-bound MAPs model in binding mode

global KM KA UM;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 4);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets model equation and text
MAP_strings(handles.model2, handles.equation2);

% Sets labels for the input boxes
set_java_component(handles.label1_2, '[A] total ');
set_java_component(handles.label2_2, [KM, ' ']);
set_java_component(handles.label3_2, [KA, ' ']);
set_java_component(handles.units3_2, [UM, ' ']);
set_java_component(handles.label4_2, '1 MT : ');
set_java_component(handles.units4_2, 'A');

% Updates the handles structure
guidata(hObject, handles);

end


                
function MAP_saturation_labels2(hObject)
%Function to update the appearance of MTBindingSim for the case where the
%first function is the MAPs bind to MT-bound MAPs model in saturation mode

global KM KA UM;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 4);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets model equation and text
MAP_strings(handles.model2, handles.equation2);

% Sets labels for the input boxes
set_java_component(handles.label1_2, '[MT] total ');
set_java_component(handles.label2_2, [KM, ' ']);
set_java_component(handles.label3_2, [KA, ' ']);
set_java_component(handles.units3_2, [UM, ' ']);
set_java_component(handles.label4_2, '1 MT : ');
set_java_component(handles.units4_2, 'A');

% Updates the handles structure
guidata(hObject, handles);

end

function competition_labels2(hObject)
% Function to update the appearnce of MTBindingSIm for the case where
% the competition experimental mode is selected

global KA KB UM;

% Sets the visibility for all imput boxes
inputboxes_display2(hObject, 4);

handles = guidata(hObject);

% Sets the equation and model text
competition_strings(handles.model2, handles.equation2);

% Sets the labels for the visible imput boxes
set_java_component(handles.label1_2, '[MT] total ');
set_java_component(handles.label2_2, '[A] total ');
set_java_component(handles.label3_2, [KA, ' ']);
set_java_component(handles.label4_2, [KB, ' ']);
set_java_component(handles.units3_2, [UM, ' ']);
set_java_component(handles.units4_2, [UM, ' ']);

% Updates the handles structure
guidata(hObject, handles);

end


function inputboxes_display1(hObject, num)
% Sets the visibility of the input boxes for the first curve
% num is the number of visible boxes you would like to have

handles = guidata(hObject);

if num >= 1
    set(handles.label1_1, 'Visible', 'on');
    set(handles.input1_1, 'Visible', 'on');
    set(handles.units1_1, 'Visible', 'on');
else
    set(handles.label1_1, 'Visible', 'off');
    set(handles.input1_1, 'Visible', 'off');
    set(handles.units1_1, 'Visible', 'off');
end

if num >= 2
    set(handles.label2_1, 'Visible', 'on');
    set(handles.input2_1, 'Visible', 'on');
    set(handles.units2_1, 'Visible', 'on');
else
    set(handles.label2_1, 'Visible', 'off');
    set(handles.input2_1, 'Visible', 'off');
    set(handles.units2_1, 'Visible', 'off');
end

if num >= 3
    set(handles.label3_1, 'Visible', 'on');
    set(handles.input3_1, 'Visible', 'on');
    set(handles.units3_1, 'Visible', 'on');
else
    set(handles.label3_1, 'Visible', 'off');
    set(handles.input3_1, 'Visible', 'off');
    set(handles.units3_1, 'Visible', 'off');
end

if num >= 4
    set(handles.label4_1, 'Visible', 'on');
    set(handles.input4_1, 'Visible', 'on');
    set(handles.units4_1, 'Visible', 'on');
else
    set(handles.label4_1, 'Visible', 'off');
    set(handles.input4_1, 'Visible', 'off');
    set(handles.units4_1, 'Visible', 'off');
end

if num >= 5
    set(handles.label5_1, 'Visible', 'on');
    set(handles.input5_1, 'Visible', 'on');
    set(handles.units5_1, 'Visible', 'on');
else
    set(handles.label5_1, 'Visible', 'off');
    set(handles.input5_1, 'Visible', 'off');
    set(handles.units5_1, 'Visible', 'off');
end

if num >= 6
    set(handles.label6_1, 'Visible', 'on');
    set(handles.input6_1, 'Visible', 'on');
    set(handles.units6_1, 'Visible', 'on');
else
    set(handles.label6_1, 'Visible', 'off');
    set(handles.input6_1, 'Visible', 'off');
    set(handles.units6_1, 'Visible', 'off');
end

% Updates the handles structure
guidata(hObject, handles);

end



function inputboxes_display2(hObject, num)
% Sets the visibility of the input boxes for the second curve
% num is the number of visible boxes you would like to have

% Gets the guidata
handles = guidata(hObject);

if num >= 1
    set(handles.label1_2, 'Visible', 'on');
    set(handles.input1_2, 'Visible', 'on');
    set(handles.units1_2, 'Visible', 'on');
else
    set(handles.label1_2, 'Visible', 'off');
    set(handles.input1_2, 'Visible', 'off');
    set(handles.units1_2, 'Visible', 'off');
end

if num >= 2
    set(handles.label2_2, 'Visible', 'on');
    set(handles.input2_2, 'Visible', 'on');
    set(handles.units2_2, 'Visible', 'on');
else
    set(handles.label2_2, 'Visible', 'off');
    set(handles.input2_2, 'Visible', 'off');
    set(handles.units2_2, 'Visible', 'off');
end

if num >= 3
    set(handles.label3_2, 'Visible', 'on');
    set(handles.input3_2, 'Visible', 'on');
    set(handles.units3_2, 'Visible', 'on');
else
    set(handles.label3_2, 'Visible', 'off');
    set(handles.input3_2, 'Visible', 'off');
    set(handles.units3_2, 'Visible', 'off');
end

if num >= 4
    set(handles.label4_2, 'Visible', 'on');
    set(handles.input4_2, 'Visible', 'on');
    set(handles.units4_2, 'Visible', 'on');
else
    set(handles.label4_2, 'Visible', 'off');
    set(handles.input4_2, 'Visible', 'off');
    set(handles.units4_2, 'Visible', 'off');
end

if num >= 5
    set(handles.label5_2, 'Visible', 'on');
    set(handles.input5_2, 'Visible', 'on');
    set(handles.units5_2, 'Visible', 'on');
else
    set(handles.label5_2, 'Visible', 'off');
    set(handles.input5_2, 'Visible', 'off');
    set(handles.units5_2, 'Visible', 'off');
end

if num >= 6
    set(handles.label6_2, 'Visible', 'on');
    set(handles.input6_2, 'Visible', 'on');
    set(handles.units6_2, 'Visible', 'on');
else
    set(handles.label6_2, 'Visible', 'off');
    set(handles.input6_2, 'Visible', 'off');
    set(handles.units6_2, 'Visible', 'off');
end

% Updates the handles structure
guidata(hObject, handles);

end



function disableButtons(hObject)

% Gets the guidata
handles = guidata(hObject);

% Change the mouse cursor to an hourglass
set(handles.mainfigure, 'Pointer', 'watch');

% Disable all the buttons so they cannot be pressed
set(handles.graph,'Enable','off');
set(handles.clear,'Enable','off');
set(handles.curve1,'Enable','off');
set(handles.curve2, 'Enable', 'off');
set(handles.binding, 'Enable', 'off');
set(handles.saturation, 'Enable', 'off');
set(handles.competition, 'Enable', 'off');
set(handles.single, 'Enable', 'off');
set(handles.compare, 'Enable', 'off');
set(handles.free, 'Enable', 'off');
set(handles.total, 'Enable', 'off');

guidata(hObject, handles);

drawnow;

end


 
function enableButtons(hObject)

% Gets the guidata
handles = guidata(hObject);

% Change the mouse cursor to an arrow
set(handles.mainfigure,'Pointer','arrow');

% Enable all the buttons so they can be pressed
set(handles.graph,'Enable','on');
set(handles.clear,'Enable','on');
set(handles.curve1,'Enable','on');
set(handles.curve2, 'Enable', 'on');
set(handles.binding, 'Enable', 'on');
set(handles.saturation, 'Enable', 'on');
set(handles.competition, 'Enable', 'on');
set(handles.single, 'Enable', 'on');
set(handles.compare, 'Enable', 'on');
set(handles.free, 'Enable', 'on');
set(handles.total, 'Enable', 'on');

guidata(hObject, handles);

drawnow;

end

function errorbox(message, hObject)

errordlg(message);
enableButtons(hObject);

end


%%%%%%%%%%%%%%
% GUIDE utility functions
% 
% The below is auto-generated GUIDE code for making controls
% look right.  Ignore.
%%%%%%%%%%%%%%

function input_xmin_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function input_xmax_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function curve2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function input1_2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function input2_2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function input3_2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function input4_2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function input5_2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function input6_2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function input_points_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function curve1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function input1_1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function input2_1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function input3_1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function input4_1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function input5_1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function input6_1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
