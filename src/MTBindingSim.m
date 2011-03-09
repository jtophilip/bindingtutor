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
% Copyright (C) 2010-2011  University of Notre Dame
%
% MTBindingSim is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the free Software Foundation, either version 3 of the License, or
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GUIDE initialization and startup code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
handles.graphopen = 0;
figureclose(hObject);

% Creates a color variable to enable rotating colors according to how many
% lines are on the graph
handles.color = 0;

% Creates xmin and xmax variables for plotting
handles.xmin_all = 1*10^20;
handles.xmax_all = 0;

% Creates variables for model selection
handles.mode1 = 'firstorder';
handles.mode2 = 'firstorder';

% Create selection change functions for the experimental mode and plotting
% mode button groups
set(handles.exp_mode, 'SelectionChangeFcn', @exp_mode_SelectionChangeFcn);
set(handles.plot_mode, 'SelectionChangeFcn', @plot_mode_SelectionChangeFcn);
set(handles.tot_free, 'SelectionChangeFcn', @tot_free_SelectionChangeFcn);

% Make some global string values for later
global UM KAS KAL KAM KAA KBM KAAM;
UM = '&#956;M';
KAS = 'K<sub><small>AS</small></sub>';
KAL = 'K<sub><small>AL</small></sub>';
KAM = 'K<sub><small>AMT</small></sub>';
KAA = 'K<sub><small>AA</small></sub>';
KBM = 'K<sub><small>BMT</small></sub>';
KAAM = 'K<sub><small>AAMT</small></sub>';


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
handles.label2_1 = make_java_component(handles.label2_1, [KAM, ' '], 2);
handles.label3_1 = make_java_component(handles.label3_1, '1 MT : ', 2);
handles.label4_1 = make_java_component(handles.label4_1, '', 2);
handles.label5_1 = make_java_component(handles.label5_1, '', 2);
handles.label6_1 = make_java_component(handles.label6_1, '', 2);
handles.label1_2 = make_java_component(handles.label1_2, '[A] total ', 2);
handles.label2_2 = make_java_component(handles.label2_2, [KAM, ' '], 2);
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%             Push Button Callback Code    %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function graph_CloseReq(src, event, mainfig)
% Abort if we don't have a figure
if ishandle(mainfig) == 0
    delete(gcf);
    return;
end

% Get the guidata from the main figure
handles = guidata(mainfig);

% Set that the figure window is now closed
handles.graphopen = 0;

% Set the guidata
guidata(mainfig, handles);

% Call the figure-closed handler
figureclose(mainfig);

% You must delete the figure here, or it won't close
delete(gcf);
end

function graph_Callback(hObject, eventdata, handles)
% hObject    handle to graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Clears the comparision result box
set(handles.result, 'String', '');

% Disables all GUI buttons and sets the mouse pointer to hourglass
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
if xmin >= xmax
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

% Determines which graphing mode is selected
if strcmp(get(get(handles.exp_mode, 'SelectedObject'), 'Tag'), 'competition')
    
    %%% Competition mode %%%

    % Gets the value for MTtot and makes sure that it's a positive number
    MTtot = str2double(get(handles.input1_1, 'String'));
    
    if isnan(MTtot) || MTtot <= 0
        errorbox('Please enter a positive number for [MT] total', hObject);
        return
    end
    
    % Gets the value for Atot and make sure it's a positive number
    Atot = str2double(get(handles.input2_1, 'String'));
    
    if isnan(Atot) || Atot <= 0
        errorbox('Please enter a positive number for [A] total', hObject);
        return
    end
    
    % Gets the value for KAM and make sure it's a positive number
    KAM = str2double(get(handles.input3_1, 'String'));
    
    if isnan(KAM) || KAM <= 0
        errorbox('Please enter a positive number for K_AMT', hObject);
        return
    end
    
    % Gets the value for KBM and makes sure it's a positive number
    KBM = str2double(get(handles.input4_1, 'String'));
    
    if isnan(KBM) || KBM <= 0
        errorbox('Please enter a positive number for K_BMT', hObject);
        return
    end
    
    % Calculates the fraction of A bound
    [frac] = competition(MTtot, Atot, xvals, KAM, KBM);
    
    % Checks to make sure that the calculation succeeded and returns an
    % error if it did not
    [a,b] = size(frac);
    if a == 1 && b == 1
       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
       return
    end
    
    % Sets the x and y values to be plotted
    y1 = frac;
    x1 = xvals;
    
    % Sets the x-axis title, y-axis title, plot title, and legend text
    xaxis = '[B] total';
    yaxis = 'Fraction of A bound';
    plottitle = 'Competition Binding Assay';
    legend1 = ['[MT] total = ' get(handles.input1_1, 'String') ', [A] total = ' get(handles.input2_1, 'String') ', K_{AMT} = ' get(handles.input3_1, 'String') ', K_{BMT} = ' get(handles.input4_1, 'String') ];


elseif strcmpi(handles.mode1, 'firstorder')
    
    %%% First order binding %%%
    
    % Determine the experimental mode
    switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
        % Binding mode is selected
        case 'binding'

            % Gets the value for [A] free and ensures that it's a
            % positive number
            Atot = str2double(get(handles.input1_1, 'String'));

            if isnan(Atot) || Atot <= 0
                errorbox('Please enter a positive number for [A] total', hObject); 
                return
            end

            % Gets the value for KAM and ensures that it's a
            % positive number
            KAM = str2double(get(handles.input2_1, 'String'));

            if isnan(KAM) || KAM <= 0
                errorbox('K_AMT must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the binding ratio and ensures that it's a positive number
            N = str2double(get(handles.input3_1, 'String'));

            if isnan(N) || N <= 0
               errorbox('The ratio must be a number greater than 0', hObject);
               return
            end


            % Determines whether the X-axis is free MT or free MT
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'

                   %Calculates the value of frac, MTfree, and Abound
                   [frac, MTfree] = first_order_binding(xvals, Atot, KAM, N);
                   
                   % Checks to make sure that the calculation suceeded and
                   % returns an error if it did not
                   [a,b] = size(frac);
                   if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                   end
                   
                   % Sets the x and y values to graph
                   y1 = frac;
                   x1 = MTfree;

                   % Sets the x-axis title, y-axis title, plot title, and
                   % legend text
                   xaxis = '[MT] free';
                   yaxis = 'Fraction of A bound';
                   plottitle = 'Vary [MT] Binding Assay';
                   legend1 = ['First order, [A] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String'), ', N = ' get(handles.input3_1, 'String')];

                case 'total'

                   % Calculates the value of frac and MTfree
                   [frac, MTfree] = first_order_binding(xvals, Atot, KAM, N);
                   
                   % Checks to make sure that the calculation suceeded and
                   % returns an error if it did not
                   [a,b] = size(frac);
                   if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                   end

                   % Sets the x and y values to graph
                   y1 = frac;
                   x1 = xvals; 

                   % Sets the x-axis title, y-axis title, plot title, and
                   % legend text
                   xaxis = '[MT] total';
                   yaxis = 'Fraction of A bound';
                   plottitle = 'Vary [MT] Binding Assay';
                   legend1 = ['First order, [A] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', N = ' get(handles.input3_1, 'String')];

                otherwise
            end

        % Saturation mode is selected
        case 'saturation'

            % Gets the value for [MT] free and ensures that it's a
            % positive number
            MTtot = str2double(get(handles.input1_1, 'String'));

            if isnan(MTtot) || MTtot <= 0
                errorbox('Please enter a positive number for [MT] total', hObject); 
                return
            end

            % Gets the value for KAM and ensures that it's a
            % positive number
            KAM = str2double(get(handles.input2_1, 'String'));

            if isnan(KAM) || KAM <= 0
                errorbox('K_AMT must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the binding ratio and ensures that it's a positive number
            N = str2double(get(handles.input3_1, 'String'));

            if isnan(N) || N <= 0
               errorbox('The ratio must be a number greater than 0', hObject);
               return
            end

            
            % Determines whether free or free [A] should be graphed
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'
                    
                    % Calculates Abound, and Afree
                    [Abound, Afree] = first_order_saturation(MTtot, xvals, KAM, N);
                    
                    % Checks to make sure the calculation suceeded and
                    % returns an error if it did not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end
                    
                    % Sets the x and y values to plot
                    y1 = Abound;
                    x1 = Afree;

                    % Sets the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[A] free';
                    yaxis = '[A] bound';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['First order, [MT] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', N = ' get(handles.input3_1, 'String')];

                    
                case 'total'
                
                    % Calculates Abound and Afree
                    [Abound, Afree] = first_order_saturation(MTtot, xvals, KAM, N);
                    
                    % Checks to make sure the calculation suceeded and
                    % returns an error if it did not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y data to plot
                    y1 = Abound;
                    x1 = xvals;

                    % Sets the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[A] total';
                    yaxis = '[A] bound';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['First order, [MT] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', N = ' get(handles.input3_1, 'String')];
                    
                case 'scatchard'
                    
                    % Calculates Abound and Afree
                    [Abound, Afree] = first_order_saturation(MTtot, xvals, KAM, N);
                    
                    % Checks to make sure the calculation suceeded and
                    % returns an error if it did not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y data to plot
                    y1 = Abound./Afree;
                    x1 = Abound;
                    
                    % Sets the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[A] bound';
                    yaxis = '[A] bound/ [A] free';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['First order, [MT] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', N = ' get(handles.input3_1, 'String')];
                    

                    
                otherwise
            end

        otherwise
    end

elseif strcmpi(handles.mode1, 'cooperativity')
    
    %%% Cooperative binding %%% 

    % Determine the experimental mode
    switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
        % Binding mode is selected
        case 'binding'

            % Gets the value for [A] free and ensures that it's a
            % positive number
            Atot = str2double(get(handles.input1_1, 'String'));

            if isnan(Atot) || Atot <= 0
                errorbox('Please enter a positive number for [A] total', hObject); 
                return
            end

            % Gets the value for KAM and ensures that it's a
            % positive number
            KAM = str2double(get(handles.input2_1, 'String'));

            if isnan(KAM) || KAM <= 0
                errorbox('K_AMT must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for phi and ensures that it's a
            % number
            p = str2double(get(handles.input3_1, 'String'));

            if isnan(p) || p <= 0
                errorbox('phi must be a positive number', hObject); 
                return
            end
            
            % Gets the binding ratio and ensures that it's a positive number
            N = str2double(get(handles.input4_1, 'String'));

            if isnan(N) || N <= 0
               errorbox('The ratio must be a number greater than 0', hObject);
               return
            end


            % Determines whether the X-axis is free MT or free MT
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'

                    % Calculates frac and MTfree
                    [frac, MTfree] = cooperativity_binding(xvals, Atot, KAM, p, N);
                    
                    % Checks to make sure that the calculation was
                    % successful and returns an error if it was not
                    [a,b] = size(frac);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end


                    % Sets the x and y values to plot
                    y1 = frac;
                    x1 = MTfree;

                    % Sets the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[MT] free';
                    yaxis = 'Fraction of A bound';
                    plottitle = 'Vary [MT] Binding Assay';
                    legend1 = ['Cooperativity, [A] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', \phi = ' get(handles.input3_1, 'String') ', N = ' get(handles.input4_1, 'String')];

                case 'total'

                    % Calculates frac, MTfree
                    [frac, MTfree] = cooperativity_binding(xvals, Atot, KAM, p, N);
                    
                    % Checks to make sure the calculation was sucessful and
                    % returns an error if it was not
                    [a,b] = size(frac);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end


                    % Sets the x and y values to plot
                    y1 = frac;
                    x1 = xvals;

                    % Sets the x-axis title, y-axis title, plot title, and legend text 
                    xaxis = '[MT] total';
                    yaxis = 'Fraction of A bound';
                    plottitle = 'Vary [MT] Binding Assay';
                    legend1 = ['Cooperativity, [A] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', \phi = ' get(handles.input3_1, 'String') ', N = ' get(handles.input4_1, 'String')];

                otherwise
            end

        % Saturation mode is selected
        case 'saturation'

            % Gets the value for [MT] free and ensures that it's a
            % positive number
            MTtot = str2double(get(handles.input1_1, 'String'));

            if isnan(MTtot) || MTtot <= 0
                errorbox('Please enter a positive number for [MT] total', hObject); 
                return
            end

            % Gets the value for KAM and ensures that it's a
            % positive number
            KAM = str2double(get(handles.input2_1, 'String'));

            if isnan(KAM) || KAM <= 0
                errorbox('K_AMT must be a number greater than 0', hObject); 
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


            % Determines wether free or free mode is selected
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                
                case 'free'
                    
                    % Calculates Abound and Afree
                    [Abound, Afree] = cooperativity_saturation(MTtot, xvals, KAM, p, N);
                    
                    % Checks to make sure the calculation was sucessful and
                    % returns an error if it was not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y values to plot
                    y1 = Abound;
                    x1 = Afree;

                    % Sets the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[A] free';
                    yaxis = '[A] bound';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['Cooperativity, [MT] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', \phi = ' get(handles.input3_1, 'String') ', N = ' get(handles.input4_1, 'String')];

                    
                case 'total'
                    
                    % Calculates Abound and Afree
                    [Abound, Afree] = cooperativity_saturation(MTtot, xvals, KAM, p, N);
                    
                    % Checks to make sure the calculation was sucessful and
                    % returns an error if it was not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y values to plot
                    y1 = Abound;
                    x1 = xvals;

                    % Sets the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[A] total';
                    yaxis = '[A] bound';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['Cooperativity, [MT] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', \phi = ' get(handles.input3_1, 'String') ', N = ' get(handles.input4_1, 'String')];

                
                case 'saturation'
                    
                    % Calculates Abound and Afree
                    [Abound, Afree] = cooperativity_saturation(MTtot, xvals, KAM, p, N);
                    
                    % Checks to make sure the calculation was sucessful and
                    % returns an error if it was not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y values to plot
                    y1 = Abound./Afree;
                    x1 = Abound;

                    % Sets the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[A] bound';
                    yaxis = '[A] bound/ [A] free';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['Cooperativity, [MT] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', \phi = ' get(handles.input3_1, 'String') ', N = ' get(handles.input4_1, 'String')];

                
                otherwise
                    
            end
            
            
        otherwise
    end



elseif strcmpi(handles.mode1, 'seam')
    %%% Seam and lattice binding %%%
    
    % Determine the experimental mode
    switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
        % Binding mode is selected
        case 'binding'

            % Gets the value for [A] free and ensures that it's a
            % positive number
            Atot = str2double(get(handles.input1_1, 'String'));

            if isnan(Atot) || Atot <= 0
                errorbox('Please enter a positive number for [A] total', hObject); 
                return
            end

            % Gets the value for KAS and ensures that it's a
            % positive number
            KAS = str2double(get(handles.input2_1, 'String'));

            if isnan(KAS) || KAS <= 0
                errorbox('K_AS must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for KAL and ensures that it's a positive
            % number
            KAL = str2double(get(handles.input3_1, 'String'));

            if isnan(KAL) || KAL <= 0
                errorbox('K_AL must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the binding ratio and ensures that it's a positive number
            N = str2double(get(handles.input4_1, 'String'));

            if isnan(N) || N <= 0
               errorbox('The ratio must be a number greater than 0', hObject);
               return
            end


            % Determines whether the X-axis is free MT or free MT
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'

                   % Calculates fraction of A bound and free MT
                   [frac, MTfree] = seam_lattice_binding(xvals, Atot, KAS, KAL, N);
                   
                   % Checks to make sure the calculation was sucessful and
                   % returns an error if it was not
                   [a,b] = size(frac);
                   if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                   end
                   
                   % Sets the x and y values to plot
                   y1 = frac;
                   x1 = MTfree;

                   % Sets the x-axis title, y-axis title, plot title, and
                   % legend text
                   xaxis = '[MT] free';
                   yaxis = 'Fraction of A bound';
                   plottitle = 'Vary [MT] Binding Assay';
                   legend1 = ['Seam binding, [A] total = ' get(handles.input1_1, 'String') ', K_{AS} = ' get(handles.input2_1, 'String') ', K_{AL} = ' get(handles.input3_1, 'String') ', N = ' get(handles.input4_1, 'String')];

                case 'total'

                    % Calculates fraction of A bound and MT free
                    [frac, MTfree] = seam_lattice_binding(xvals, Atot, KAS, KAL, N);
                    
                    % Checks to make sure the calculation was sucessful and
                    % returns an error if it was not
                    [a,b] = size(frac);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end
                    
                    % Sets the x and y values to plot
                    y1 = frac;
                    x1 = xvals;

                    % Sets the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[MT] total';
                    yaxis = 'Fraction of A bound';
                    plottitle = 'Vary [MT] Binding Assay';
                    legend1 = ['Seam binding, [A] total = ' get(handles.input1_1, 'String') ', K_{AS} = ' get(handles.input2_1, 'String') ', K_{AL} = ' get(handles.input3_1, 'String') ', N = ' get(handles.input4_1, 'String')];

                otherwise
            end

        % Saturation mode is selected
        case 'saturation'

            % Gets the value for [MT] free and ensures that it's a
            % positive number
            MTtot = str2double(get(handles.input1_1, 'String'));

            if isnan(MTtot) || MTtot <= 0
                errorbox('Please enter a positive number for [MT] total', hObject); 
                return
            end

            % Gets the value for KAS and ensures that it's a
            % positive number
            KAS = str2double(get(handles.input2_1, 'String'));

            if isnan(KAS) || KAS <= 0
                errorbox('K_AS must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for KAL and ensures that it's a positive
            % number
            KAL = str2double(get(handles.input3_1, 'String'));

            if isnan(KAL) || KAL <= 0
                errorbox('K_AL must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the binding ratio and ensures that it's a positive number
            N = str2double(get(handles.input4_1, 'String'));

            if isnan(N) || N <= 0
               errorbox('The ratio must be a number greater than 0', hObject);
               return
            end
            
            % Determines whether the the x-axis is free or free
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                
                case 'free'
                    
                    % Calculates concentration of Abound and A free
                    [Abound, Afree] = seam_lattice_saturation(MTtot, xvals, KAS, KAL, N);
                    
                    % Checks to make sure the calculation was sucessful and
                    % returns an error if it was not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end
                    
                    % Sets the x and y values to plot
                    y1 = Abound;
                    x1 = Afree;

                    % Sets the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[A] free';
                    yaxis = '[A] bound';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['Seam binding, [MT] total = ' get(handles.input1_1, 'String') ', K_{AS} = ' get(handles.input2_1, 'String') ', K_{AL} = ' get(handles.input3_1, 'String') ', N = ' get(handles.input4_1, 'String')];


                case 'total'
                    
                    % Calculates concentration of A bound and MT free
                    [Abound, Afree] = seam_lattice_saturation(MTtot, xvals, KAS, KAL, N);
                    
                    % Checks to make sure the calculation was sucessful and
                    % returns an error if it was not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end
                    
                    % Sets the x and y values to plot
                    y1 = Abound;
                    x1 = xvals;

                    % Sets the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[A] total';
                    yaxis = '[A] bound';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['Seam binding, [MT] total = ' get(handles.input1_1, 'String') ', K_{AS} = ' get(handles.input2_1, 'String') ', K_{AL} = ' get(handles.input3_1, 'String') ', N = ' get(handles.input4_1, 'String')];
   
                case 'scatchard'
                    
                    % Calculates concentration of A bound and MT free
                    [Abound, Afree] = seam_lattice_saturation(MTtot, xvals, KAS, KAL, N);
                    
                    % Checks to make sure the calculation was sucessful and
                    % returns an error if it was not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end
                    
                    % Sets the x and y values to plot
                    y1 = Abound./Afree;
                    x1 = Abound;

                    % Sets the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[A] bound';
                    yaxis = '[A] bound/[A] free';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['Seam binding, [MT] total = ' get(handles.input1_1, 'String') ', K_{AS} = ' get(handles.input2_1, 'String') ', K_{AL} = ' get(handles.input3_1, 'String') ', N = ' get(handles.input4_1, 'String')];
                
                
                otherwise
            end

            
        otherwise
    end



elseif strcmpi(handles.mode1, 'MAPbind')
    
    %%% MAPs bind MT-bound MAPS %%%

    % Determine the experimental mode
    switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
        % Binding mode is selected
        case 'binding'

            % Gets the value for [A] free and ensures that it's a
            % positive number
            Atot = str2double(get(handles.input1_1, 'String'));

            if isnan(Atot) || Atot <= 0
                errorbox('Please enter a positive number for [A] total', hObject); 
                return
            end

            % Gets the value for KAM and ensures that it's a
            % positive number
            KAM = str2double(get(handles.input2_1, 'String'));

            if isnan(KAM) || KAM <= 0
                errorbox('K_AMT must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for KAA and ensures that it's a positive
            % number
            KAA = str2double(get(handles.input3_1, 'String'));

            if isnan(KAA) || KAA <= 0
                errorbox('K_AA must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the binding ratio and ensures that it's a positive number
            N = str2double(get(handles.input4_1, 'String'));

            if isnan(N) || N <= 0
               errorbox('The ratio must be a number greater than 0', hObject);
               return
            end

            % Determines whether the X-axis is free MT or free MT
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'

                   % Calculates fraction of A bound and free MT
                   [frac, MTfree] =MAP_binding(xvals, Atot, KAM, KAA, N);
                   
                   % Determines whether the calculation was successful and
                   % returns an error if it was not
                   [a,b] = size(frac);
                   if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                   end

                   % Sets the x and y values to plot
                   y1 = frac;
                   x1 = MTfree;

                   % Sets the x-axis title, y-axis title, plot title, and
                   % legend text
                   xaxis = '[MT] free';
                   yaxis = 'Fraction of A bound';
                   plottitle = 'Vary [MT] Binding Assay';
                   legend1 = ['MAP binding, [A] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', K_{AA} = ' get(handles.input3_1, 'String') ', N = ' get(handles.input4_1, 'String')];

                case 'total'

                    % Calculates fraction of A bound and free MT
                    [frac, MTfree] =MAP_binding(xvals, Atot, KAM, KAA, N);
                    
                    % Determines whether the calculation was sucessful and
                    % returns an error if it was not
                    [a,b] = size(frac);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y values to plot
                    y1 = frac;
                    x1 = xvals;

                    % Sets the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[MT] total';
                    yaxis = 'Fraction of A bound';
                    plottitle = 'Vary [MT] Binding Assay';
                    legend1 = ['MAP binding, [A] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', K_{AA} = ' get(handles.input3_1, 'String') ', N = ' get(handles.input4_1, 'String')];

                otherwise
            end

        % Saturation mode is selected
        case 'saturation'

            % Gets the value for [MT] free and ensures that it's a
            % positive number
            MTtot = str2double(get(handles.input1_1, 'String'));

            if isnan(MTtot) || MTtot <= 0
                errorbox('Please enter a positive number for [MT] total', hObject); 
                return
            end

            % Gets the value for KAM and ensures that it's a
            % positive number
            KAM = str2double(get(handles.input2_1, 'String'));

            if isnan(KAM) || KAM <= 0
                errorbox('K_AMT must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for KAA and ensures that it's a positive
            % number
            KAA = str2double(get(handles.input3_1, 'String'));

            if isnan(KAA) || KAA <= 0
                errorbox('K_AA must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the binding ratio and ensures that it's a positive number
            N = str2double(get(handles.input4_1, 'String'));

            if isnan(N) || N <= 0
               errorbox('The ratio must be a number greater than 0', hObject);
               return
            end

            % Determines whether the x-axis is free A or free A
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'
                    
                    % Calculates the concentration of A bound and A free
                    [Abound, Afree] = MAP_saturation(MTtot, xvals, KAM, KAA, N);
                    
                    % Determines whether the calculation was sucessful and
                    % returns an error if it was not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y values to plot
                    y1 = Abound;
                    x1 = Afree;

                    % Sets the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[A] free';
                    yaxis = '[A] bound';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['MAP binding, [MT] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', K_{AA} = ' get(handles.input3_1, 'String') ', N = ' get(handles.input4_1, 'String')];
                    
                case 'total'
                    
                    % Calculates the concentration of A bound
                    [Abound, Afree] = MAP_saturation(MTtot, xvals, KAM, KAA, N);
                    
                    % Determines whether the calculation was sucessful and
                    % returns an error if it was not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y values to plot
                    y1 = Abound;
                    x1 =xvals;

                    % Sets the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[A] total';
                    yaxis = '[A] bound';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['MAP binding, [MT] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', K_{AA} = ' get(handles.input3_1, 'String') ', N = ' get(handles.input4_1, 'String')];

                case 'scatchard'
                    
                    % Calculates the concentration of A bound
                    [Abound, Afree] = MAP_saturation(MTtot, xvals, KAM, KAA, N);
                    
                    % Determines whether the calculation was sucessful and
                    % returns an error if it was not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y values to plot
                    y1 = Abound./Afree;
                    x1 = Abound;

                    % Sets the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[A] bound';
                    yaxis = '[A] bound/[A] free';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['MAP binding, [MT] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', K_{AA} = ' get(handles.input3_1, 'String') ', N = ' get(handles.input4_1, 'String')];

                
                otherwise
            end

            
        otherwise
    end

   
elseif strcmpi(handles.mode1, 'MAPbind2')
    
    %%% 2 MAPs bind MT-bound MAPs %%%
    
    % Determine the experimental mode
    switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
        % Binding mode is selected
        case 'binding'

            % Gets the value for [A] free and ensures that it's a
            % positive number
            Atot = str2double(get(handles.input1_1, 'String'));

            if isnan(Atot) || Atot <= 0
                errorbox('Please enter a positive number for [A] total', hObject); 
                return
            end

            % Gets the value for KAM and ensures that it's a
            % positive number
            KAM = str2double(get(handles.input2_1, 'String'));

            if isnan(KAM) || KAM <= 0
                errorbox('K_AMT must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for KAA and ensures that it's a positive
            % number
            KAA = str2double(get(handles.input3_1, 'String'));

            if isnan(KAA) || KAA <= 0
                errorbox('K_AA must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the binding ratio and ensures that it's a positive number
            N = str2double(get(handles.input4_1, 'String'));

            if isnan(N) || N <= 0
               errorbox('The ratio must be a number greater than 0', hObject);
               return
            end

            % Determines whether the X-axis is free MT or free MT
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'

                   % Calculates fraction of A bound and free MT
                   [frac, MTfree] =MAP2_binding(xvals, Atot, KAM, KAA, N);
                   
                   % Determine whether the calculation was sucessful and
                   % reutrn an error if it was not
                   [a,b] = size(frac);
                   if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                   end

                   % Set the x and y values to plot
                   y1 = frac;
                   x1 = MTfree;

                   
                   % Set the x-axis title, y-axis title, plot title, and
                   % legend text
                   xaxis = '[MT] free';
                   yaxis = 'Fraction of A bound';
                   plottitle = 'Vary [MT] Binding Assay';
                   legend1 = ['2 MAP binding, [A] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', K_{AA} = ' get(handles.input3_1, 'String') ', N = ' get(handles.input4_1, 'String')];

                case 'total'

                    % Calculates fraction of A bound and free MT
                    [frac, MTfree] =MAP2_binding(xvals, Atot, KAM, KAA, N);
                    
                    % Ensure that the calculation was sucessful and return
                    % an error if it was not
                    [a,b] = size(frac);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Set the x and y values to plot
                    y1 = frac;
                    x1 = xvals;

                    % Set the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[MT] total';
                    yaxis = 'Fraction of A bound';
                    plottitle = 'Vary [MT] Binding Assay';
                    legend1 = ['2 MAP binding, [A] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', K_{AA} = ' get(handles.input3_1, 'String') ', N = ' get(handles.input4_1, 'String')];

                otherwise
            end

        % Saturation mode is selected
        case 'saturation'

            % Gets the value for [MT] free and ensures that it's a
            % positive number
            MTtot = str2double(get(handles.input1_1, 'String'));

            if isnan(MTtot) || MTtot <= 0
                errorbox('Please enter a positive number for [MT] total', hObject); 
                return
            end

            % Gets the value for KAM and ensures that it's a
            % positive number
            KAM = str2double(get(handles.input2_1, 'String'));

            if isnan(KAM) || KAM <= 0
                errorbox('K_AMT must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for KAA and ensures that it's a positive
            % number
            KAA = str2double(get(handles.input3_1, 'String'));

            if isnan(KAA) || KAA <= 0
                errorbox('K_AA must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the binding ratio and ensures that it's a positive number
            N = str2double(get(handles.input4_1, 'String'));

            if isnan(N) || N <= 0
               errorbox('The ratio must be a number greater than 0', hObject);
               return
            end

            % Determine whether the x-axis is free A or free A
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'
                    
                    % Calculates the concentration of A bound
                    [Abound, Afree] = MAP2_saturation(MTtot, xvals, KAM, KAA, N);
                    
                    % Ensure that the calculation was sucessful and returns
                    % an error if it was not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y values to plot
                    y1 = Abound;
                    x1 = Afree;

                    % Sets the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[A] free';
                    yaxis = '[A] bound';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['2 MAP binding, [MT] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', K_{AA} = ' get(handles.input3_1, 'String') ', N = ' get(handles.input4_1, 'String')];
                    
                case 'total'
                    
                    % Calculates the concentration of A bound
                    [Abound, Afree] = MAP2_saturation(MTtot, xvals, KAM, KAA, N);
                    
                    % Ensures that the calculation was sucessful and
                    % returns an error if it was not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y values to plot
                    y1 = Abound;
                    x1 =xvals;
                    
                    % Sets the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[A] total';
                    yaxis = '[A] bound';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['2 MAP binding, [MT] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', K_{AA} = ' get(handles.input3_1, 'String') ', N = ' get(handles.input4_1, 'String')];

                case 'scatchard'
                
                    % Calculates the concentration of A bound
                    [Abound, Afree] = MAP2_saturation(MTtot, xvals, KAM, KAA, N);
                    
                    % Ensures that the calculation was sucessful and
                    % returns an error if it was not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y values to plot
                    y1 = Abound./Afree;
                    x1 = Abound;
                    
                    % Sets the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[A] bound';
                    yaxis = '[A] bound/Afree';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['2 MAP binding, [MT] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', K_{AA} = ' get(handles.input3_1, 'String') ', N = ' get(handles.input4_1, 'String')];

                
                otherwise
            end

            
        otherwise
    end
    
elseif strcmpi(handles.mode1, 'dimer')
    
    %%% Dimerization and binding %%%
    
    % Determine the experimental mode
    switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
        % Binding mode is selected
        case 'binding'

            % Gets the value for [A] free and ensures that it's a
            % positive number
            Atot = str2double(get(handles.input1_1, 'String'));

            if isnan(Atot) || Atot <= 0
                errorbox('Please enter a positive number for [A] total', hObject); 
                return
            end

            % Gets the value for KAM and ensures that it's a
            % positive number
            KAM = str2double(get(handles.input2_1, 'String'));

            if isnan(KAM) || KAM <= 0
                errorbox('K_AMT must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for KAAM and ensures that it's a positive
            % number
            KAAM = str2double(get(handles.input3_1, 'String'));

            if isnan(KAAM) || KAAM <= 0
                errorbox('K_AAMT must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the value for KAA and ensures that it's a positive number
            KAA = str2double(get(handles.input4_1, 'String'));
            
            if isnan(KAA) || KAA  <= 0
                errorbox('K_AA must be a number greater than 0', hObject);
                return
            end
            
            % Gets the binding ratio and ensures that it's a positive number
            N = str2double(get(handles.input5_1, 'String'));

            if isnan(N) || N <= 0
               errorbox('The ratio must be a number greater than 0', hObject);
               return
            end

            % Determines whether the X-axis is free MT or free MT
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'

                   % Calculates fraction of A bound and free MT
                   [frac, MTfree] = dimer_binding(xvals, Atot, KAM, KAAM, KAA, N);
                   
                   % Determine whether the calculation was sucessful and
                   % reutrn an error if it was not
                   [a,b] = size(frac);
                   if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                   end

                   % Set the x and y values to plot
                   y1 = frac;
                   x1 = MTfree;

                   
                   % Set the x-axis title, y-axis title, plot title, and
                   % legend text
                   xaxis = '[MT] free';
                   yaxis = 'Fraction of A bound';
                   plottitle = 'Vary [MT] Binding Assay';
                   legend1 = ['Dimerization, [A] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', K_{AAMT} = ' get(handles.input3_1, 'String') ', K_{AA} = ' get(handles.input4_1, 'String') ', N = ' get(handles.input5_1, 'String')];
                case 'total'

                    % Calculates fraction of A bound and free MT
                    [frac, MTfree] = dimer_binding(xvals, Atot, KAM, KAAM, KAA, N);
                    
                    % Ensure that the calculation was sucessful and return
                    % an error if it was not
                    [a,b] = size(frac);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Set the x and y values to plot
                    y1 = frac;
                    x1 = xvals;

                    % Set the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[MT] total';
                    yaxis = 'Fraction of A bound';
                    plottitle = 'Vary [MT] Binding Assay';
                    legend1 = ['Dimerization, [A] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', K_{AAMT} = ' get(handles.input3_1, 'String') ', K_{AA} = ' get(handles.input4_1, 'String') ', N = ' get(handles.input5_1, 'String')];

                otherwise
            end

        % Saturation mode is selected
        case 'saturation'

            % Gets the value for [MT] free and ensures that it's a
            % positive number
            MTtot = str2double(get(handles.input1_1, 'String'));

            if isnan(MTtot) || MTtot <= 0
                errorbox('Please enter a positive number for [MT] total', hObject); 
                return
            end

            % Gets the value for KAM and ensures that it's a
            % positive number
            KAM = str2double(get(handles.input2_1, 'String'));

            if isnan(KAM) || KAM <= 0
                errorbox('K_AMT must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for KAAM and ensures that it's a positive
            % number
            KAAM = str2double(get(handles.input3_1, 'String'));

            if isnan(KAAM) || KAAM <= 0
                errorbox('K_AAMT must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the value for KAA and ensures that it's a positive
            % number
            KAA = str2double(get(handles.input4_1, 'String'));

            if isnan(KAA) || KAA <= 0
                errorbox('K_AA must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the binding ratio and ensures that it's a positive number
            N = str2double(get(handles.input5_1, 'String'));

            if isnan(N) || N <= 0
               errorbox('The ratio must be a number greater than 0', hObject);
               return
            end

            % Determine whether the x-axis is free A or free A
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'
                    
                    % Calculates the concentration of A bound
                    [Abound, Afree] = dimer_saturation(MTtot, xvals, KAM, KAAM, KAA, N);
                    
                    % Ensure that the calculation was sucessful and returns
                    % an error if it was not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y values to plot
                    y1 = Abound;
                    x1 = Afree;

                    % Sets the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[A] free';
                    yaxis = '[A] bound';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['Dimerization, [MT] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', K_{AAMT} = ' get(handles.input3_1, 'String') ', K_{AA} = ' get(handles.input4_1, 'String') ', N = ' get(handles.input5_1, 'String')];
                    
                case 'total'
                    
                    % Calculates the concentration of A bound
                    [Abound, Afree] = dimer_saturation(MTtot, xvals, KAM, KAAM, KAA, N);
                    
                    % Ensures that the calculation was sucessful and
                    % returns an error if it was not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y values to plot
                    y1 = Abound;
                    x1 =xvals;
                    
                    % Sets the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[A] total';
                    yaxis = '[A] bound';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['Dimerization, [MT] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', K_{AAMT} = ' get(handles.input3_1, 'String') ', K_{AA} = ' get(handles.input4_1, 'String') ', N = ' get(handles.input5_1, 'String')];

                case 'scatchard'
                     
                    % Calculates the concentration of A bound
                    [Abound, Afree] = dimer_saturation(MTtot, xvals, KAM, KAAM, KAA, N);
                    
                    % Ensures that the calculation was sucessful and
                    % returns an error if it was not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y values to plot
                    y1 = Abound./Afree;
                    x1 = Abound;
                    
                    % Sets the x-axis title, y-axis title, plot title, and
                    % legend text
                    xaxis = '[A] bound';
                    yaxis = '[A] bound/[A] free';
                    plottitle = 'Vary [A] Binding Assay';
                    legend1 = ['Dimerization, [MT] total = ' get(handles.input1_1, 'String') ', K_{AMT} = ' get(handles.input2_1, 'String') ', K_{AAMT} = ' get(handles.input3_1, 'String') ', K_{AA} = ' get(handles.input4_1, 'String') ', N = ' get(handles.input5_1, 'String')];

                
                otherwise
            end

            
        otherwise
    end
    


end


% Determines if comparision mode is selected and calculates the
% second curve
if strcmp(get(get(handles.plot_mode, 'SelectedObject'), 'Tag'), 'compare')
    
   % Determines the model to be calculated 
   if strcmp(get(get(handles.exp_mode, 'SelectedObject'), 'Tag'), 'competition')

      %%%% Competition mode %%%
       
      % Gets the value of MTtot and ensures it's a positivie number
      MTtot = str2double(get(handles.input1_2, 'String'));
    
      if isnan(MTtot) || MTtot <= 0
          errorbox('Please enter a positive number for [MT] total', hObject);
          return
      end
    
      % Gets the value of Atot and ensures it's a positivie number
    Atot = str2double(get(handles.input2_2, 'String'));
    
    if isnan(Atot) || Atot <= 0
        errorbox('Please enter a positive number for [A] total', hObject);
        return
    end
    
    % Gets the value of KAM and ensures it's a positive number
    KAM = str2double(get(handles.input3_2, 'String'));
    
    if isnan(KAM) || KAM <= 0
        errorbox('Please enter a positive number for K_AMT', hObject);
        return
    end
    
    % Gets the value of KBM and ensures it's a positive number
    KBM = str2double(get(handles.input4_2, 'String'));
    
    if isnan(KBM) || KBM <= 0
        errorbox('Please enter a positive number for K_BMT', hObject);
        return
    end
    
    % Calculates the fraction of A bound
    [frac] = competition(MTtot, Atot, xvals, KAM, KBM);
    
    % Ensures that the calculation suceeded and returns an error if it did
    % not
    [a,b] = size(frac);
    if a == 1 && b == 1
        errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
        return
    end

    
    % Sets the x and y values to graph
    y2 = frac;
    x2 = xvals;

    % Sets the legend text
    legend2 = ['[MT] total = ' get(handles.input1_2, 'String') ', [A] total = ' get(handles.input2_2, 'String') ', K_{AMT} = ' get(handles.input3_2, 'String') ', K_{BMT} = ' get(handles.input4_2, 'String')];

  % Determines the parameters selected for curve2
  elseif strcmpi(handles.mode2, 'firstorder')
    
      %%% First order binding %%%%

        % Determine the experimental mode
        switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
            % Binding mode is selected
            case 'binding'

                % Gets the value for [A] free and ensures that it's a
                % positive number
                Atot = str2double(get(handles.input1_2, 'String'));

                if isnan(Atot) || Atot <= 0
                    errorbox('Please enter a positive number for [A] total', hObject); 
                    return
                end

                % Gets the value for KAM and ensures that it's a
                % positive number
                KAM = str2double(get(handles.input2_2, 'String'));

                if isnan(KAM) || KAM <= 0
                    errorbox('K_AMT must be a number greater than 0', hObject); 
                    return
                end
                
                % Gets the binding ratio and ensures that it's a positive number
                N = str2double(get(handles.input3_2, 'String'));

                if isnan(N) || N <= 0
                   errorbox('The ratio must be a number greater than 0', hObject);
                   return
                end


                % Determines whether the X-axis is free B or free B
                switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                    case 'free'

                       % Function to get fraction A bound and free MT 
                       [frac, MTfree] = first_order_binding(xvals, Atot, KAM, N);
                       
                       % Ensures that the calculation worked and returns an
                       % error if it did not
                       [a,b] = size(frac);
                       if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                       end

                       % Sets the x and y values to plot
                       y2 = frac;
                       x2 = MTfree;

                       % Sets the legend text
                       legend2 = ['First order, [A] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', N = ' get(handles.input3_2, 'String')];

                    case 'total'

                       % Function to get fraction A bound
                       [frac, MTfree] = first_order_binding(xvals, Atot, KAM, N);
                       
                       % Ensures that the calculation succeeded and returns
                       % an error if it did not
                       [a,b] = size(frac);
                       if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                       end

                       % Sets the x and y values to plot
                       y2 = frac;
                       x2 = xvals;

                       % Sets the legend text
                       legend2 = ['First order, [A] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', N = ' get(handles.input3_2, 'String')];

                    otherwise
                end

            % Saturation mode is selected
            case 'saturation'

                % Gets the value for [MT] free and ensures that it's a
                % positive number
                MTtot = str2double(get(handles.input1_2, 'String'));

                if isnan(MTtot) || MTtot <= 0
                    errorbox('Please enter a positive number for [MT] total', hObject); 
                    return
                end

                % Gets the value for KAM and ensures that it's a
                % positive number
                KAM = str2double(get(handles.input2_2, 'String'));

                if isnan(KAM) || KAM <= 0
                    errorbox('K_AMT must be a number greater than 0', hObject); 
                    return
                end
                
                % Gets the binding ratio and ensures that it's a positive number
                N = str2double(get(handles.input3_2, 'String'));

                if isnan(N) || N <= 0
                   errorbox('The ratio must be a number greater than 0', hObject);
                   return
                end
                
                % Determines whether the x-axis is free or free A
                switch get(get(handles.tot_free, 'SelectedObject'), 'Tag')
                    case 'free'
                        
                        % Function to get the concentration of A bound
                        [Abound, Afree] = first_order_saturation(MTtot, xvals, KAM, N);
                        
                        % Ensures that the calculation succeeded and
                        % returns an error if it did not
                        [a,b] = size(Abound);
                        if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                        end

                        % Sets the x an y values to graph
                        y2 = Abound;
                        x2 = Afree;

                        % Sets the legend text
                        legend2 = ['First order, [MT] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', N = ' get(handles.input3_2, 'String')];

                    case 'total'
                        
                        % Function to get the concentration of A bound
                        [Abound, Afree] = first_order_saturation(MTtot, xvals, KAM, N);
                        
                        % Ensures that the calculation was successful and
                        % returns an error if it was not
                        [a,b] = size(Abound);
                        if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                        end

                        % Sets the x and y values to graph
                        y2 = Abound;
                        x2 = xvals;

                        % Sets the legend text
                        legend2 = ['First order, [MT] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', N = ' get(handles.input3_2, 'String')];

                    case 'scatchard'
                        
                        % Function to get the concentration of A bound
                        [Abound, Afree] = first_order_saturation(MTtot, xvals, KAM, N);
                        
                        % Ensures that the calculation was successful and
                        % returns an error if it was not
                        [a,b] = size(Abound);
                        if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                        end

                        % Sets the x and y values to graph
                        y2 = Abound./Afree;
                        x2 = Abound;

                        % Sets the legend text
                        legend2 = ['First order, [MT] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', N = ' get(handles.input3_2, 'String')];

                    
                    otherwise
                end

                
            otherwise
        end

     
    elseif strcmpi(handles.mode2, 'cooperativity')
        
        %%%% Cooperative binding %%%%

        % Determine the experimental mode
        switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
            % Binding mode is selected
            case 'binding'

                % Gets the value for [A] free and ensures that it's a
                % positive number
                Atot = str2double(get(handles.input1_2, 'String'));

                if isnan(Atot) || Atot <= 0
                    errorbox('Please enter a positive number for [A] total', hObject); 
                    return
                end

                % Gets the value for KAM and ensures that it's a
                % positive number
                KAM = str2double(get(handles.input2_2, 'String'));

                if isnan(KAM) || KAM <= 0
                    errorbox('K_AMT must be a number greater than 0', hObject); 
                    return
                end

                % Gets the value for p and ensures that it's a positive
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

                % Determines whether the X-axis is free MT or free MT
                switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                    case 'free'

                       % Function to get fraction A bound and free MT 
                       [frac, MTfree] = cooperativity_binding(xvals, Atot, KAM, p, N);
                       
                       % Ensures that the calculation was successful and
                       % returns an error if it was not
                       [a,b] = size(frac);
                       if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                       end

                       % Sets the x and y values to graph
                       y2 = frac;
                       x2 = MTfree;

                       % Sets the legend text
                       legend2 = ['Cooperativity, [A] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', \phi = ' get(handles.input3_2, 'String') ', N = ' get(handles.input4_2, 'String')];

                    case 'total'

                       % Function to get fraction A bound
                       [frac, MTfree] = cooperativity_binding(xvals, Atot, KAM, p, N);
                       
                       % Ensures that the calculation was successful and
                       % returns an error if it was not
                       [a,b] = size(frac);
                       if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                       end

                       % Sets the x and y values to graph
                       y2 = frac;
                       x2 = xvals;

                       % Sets the legend text
                       legend2 = ['Cooperativity, [A] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', \phi = ' get(handles.input3_2, 'String') ', N = ' get(handles.input4_2, 'String')];

                    otherwise
                end

            % Saturation mode is selected
            case 'saturation'

                % Gets the value for [MT] free and ensures that it's a
                % positive number
                MTtot = str2double(get(handles.input1_2, 'String'));

                if isnan(MTtot) || MTtot <= 0
                    errorbox('Please enter a positive number for [MT] total', hObject); 
                    return
                end

                % Gets the value for KAM and ensures that it's a
                % positive number
                KAM = str2double(get(handles.input2_2, 'String'));

                if isnan(KAM) || KAM <= 0
                    errorbox('K_AMT must be a number greater than 0', hObject); 
                    return
                end

                % Gets the value for p and ensures that it's a
                % number
                p = str2double(get(handles.input3_2, 'String'));

                if isnan(p) || p <= 0
                    errorbox('phi must be a number greatern than 0', hObject); 
                    return
                end
                
                % Gets the binding ratio and ensures that it's a positive number
                N = str2double(get(handles.input4_2, 'String'));

                if isnan(N) || N <= 0
                   errorbox('The ratio must be a number greater than 0', hObject);
                   return
                end

                % Determines whether the x-axis is free or free A
                switch get(get(handles.tot_free, 'SelectedObject'), 'Tag')
                    case 'free'
                        
                        % Function to get the concentration of A bound
                        [Abound, Afree] = cooperativity_saturation(MTtot, xvals, KAM, p, N);
                        
                        % Ensures that the calculation was successful and
                        % returns an error if it was not
                        [a,b] = size(Abound);
                        if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                        end

                        % Sets the x and y values to graph
                        y2 = Abound;
                        x2 = Afree;

                        % Sets the legend text
                        legend2 = ['Cooperativity, [MT] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', \phi = ' get(handles.input3_2, 'String') ', N = ' get(handles.input4_2, 'String')];

                    case 'total'
                        
                        % Function to get the concentration of A bound
                        [Abound, Afree] = cooperativity_saturation(MTtot, xvals, KAM, p, N);
                        
                        % Ensures that the calculation was successful and
                        % returns an error if it was not
                        [a,b] = size(Abound);
                        if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                        end

                        % Sets the x and y values to graph
                        y2 = Abound;
                        x2 = xvals;

                        % Sets the legend text
                        legend2 = ['Cooperativity, [MT] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', \phi = ' get(handles.input3_2, 'String') ', N = ' get(handles.input4_2, 'String')];

                    case 'scatchard'
                        
                        % Function to get the concentration of A bound
                        [Abound, Afree] = cooperativity_saturation(MTtot, xvals, KAM, p, N);
                        
                        % Ensures that the calculation was successful and
                        % returns an error if it was not
                        [a,b] = size(Abound);
                        if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                        end

                        % Sets the x and y values to graph
                        y2 = Abound./Afree;
                        x2 = Abound;

                        % Sets the legend text
                        legend2 = ['Cooperativity, [MT] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', \phi = ' get(handles.input3_2, 'String') ', N = ' get(handles.input4_2, 'String')];

                    
                    otherwise
                end
            otherwise
        end


    
    elseif strcmpi(handles.mode2, 'seam')
        
        %%%% Seam and lattice binding %%%%%
        
        % Determine the experimental mode
        switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
            % Binding mode is selected
            case 'binding'

                % Gets the value for [A] free and ensures that it's a
                % positive number
                Atot = str2double(get(handles.input1_2, 'String'));

                if isnan(Atot) || Atot <= 0
                    errorbox('Please enter a positive number for [A] total', hObject); 
                    return
                end

                % Gets the value for KAS and ensures that it's a
                % positive number
                KAS = str2double(get(handles.input2_2, 'String'));

                if isnan(KAS) || KAS <= 0
                    errorbox('K_AS must be a number greater than 0', hObject); 
                    return
                end

                % Gets the value for KAL and ensures that it's a positive
                % number
                KAL = str2double(get(handles.input3_2, 'String'));

                if isnan(KAL) || KAL <= 0
                    errorbox('K_AL must be a number greater than 0', hObject); 
                    return
                end
                
                % Gets the binding ratio and ensures that it's a positive number
                N = str2double(get(handles.input4_2, 'String'));

                if isnan(N) || N <= 0
                   errorbox('The ratio must be a number greater than 0', hObject);
                   return
                end

                % Determines whether the X-axis is free MT or free MT
                switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                    case 'free'

                       % Function to get fraction A bound and free MT 
                       [frac, MTfree] = seam_lattice_binding(xvals, Atot, KAS, KAL, N);
                       
                       % Ensures that the calculation was successful and
                       % returns an error if it was not
                       [a,b] = size(frac);
                       if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                       end

                       % Sets the x and y values to plot
                       y2 = frac;
                       x2 = MTfree;

                       % Sets the legend text
                       legend2 = ['Seam binding, [A] total = ' get(handles.input1_2, 'String') ', K_{AS} = ' get(handles.input2_2, 'String') ', K_{AL} = ' get(handles.input3_2, 'String') ', N = ' get(handles.input4_2, 'String')];

                    case 'total'

                        % Function to get fraction A bound
                        [frac, MTfree] = seam_lattice_binding(xvals, Atot, KAS, KAL, N);
                        
                        % Ensures that the calculation was successful and
                        % returns an error if it was not
                        [a,b] = size(frac);
                        if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                        end

                        % Sets the x and y values to plot
                        y2 = frac;
                        x2 = xvals;

                        % Sets the legend text
                        legend2 = ['Seam binding, [A] total = ' get(handles.input1_2, 'String') ', K_{AS} = ' get(handles.input2_2, 'String') ', K_{AL} = ' get(handles.input3_2, 'String') ', N = ' get(handles.input4_2, 'String')];

                    otherwise
                end

            % Saturation mode is selected
            case 'saturation'

                % Gets the value for [MT] free and ensures that it's a
                % positive number
                MTtot = str2double(get(handles.input1_2, 'String'));

                if isnan(MTtot) || MTtot <= 0
                    errorbox('Please enter a positive number for [MT] total', hObject); 
                    return
                end

                % Gets the value for KAS and ensures that it's a
                % positive number
                KAS = str2double(get(handles.input2_2, 'String'));

                if isnan(KAS) || KAS <= 0
                    errorbox('K_AS must be a number greater than 0', hObject); 
                    return
                end

                % Gets the value for KAL and ensures that it's a positive
                % number
                KAL = str2double(get(handles.input3_2, 'String'));

                if isnan(KAL) || KAL <= 0
                    errorbox('K_AL must be a number greater than 0', hObject); 
                    return
                end
                
                % Gets the binding ratio and ensures that it's a positive number
                N = str2double(get(handles.input4_2, 'String'));

                if isnan(N) || N <= 0
                   errorbox('The ratio must be a number greater than 0', hObject);
                   return
                end
                
                % Checks to see whether the x-axis is free or free A
                switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                    case 'free'
                        
                        % Function to get the concentration of A bound
                        [Abound, Afree] = seam_lattice_saturation(MTtot, xvals, KAS, KAL, N);
                        
                        % Ensures that the calculation was successful and
                        % returns an error if it was not
                        [a,b] = size(Abound);
                        if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                        end
                        
                        % Sets the x and y values to plot
                        y2 = Abound;
                        x2 = Afree;

                        % Sets the legend text
                        legend2 = ['Seam binding, [MT] total = ' get(handles.input1_2, 'String') ', K_{AS} = ' get(handles.input2_2, 'String') ', K_{AL} = ' get(handles.input3_2, 'String') ', N = ' get(handles.input4_2, 'String')];
                        
                    case 'total'
                        
                        % Function to get the concentration of A bound
                        [Abound, Afree] = seam_lattice_saturation(MTtot, xvals, KAS, KAL, N);
                        
                        % Ensures that the calculation was successful and
                        % returns an error if it was not
                        [a,b] = size(Abound);
                        if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                        end
 
                        % Sets the x and y values to plot
                        y2 = Abound;
                        x2 = xvals;

                        % Sets the legend text
                        legend2 = ['Seam binding, [MT] total = ' get(handles.input1_2, 'String') ', K_{AS} = ' get(handles.input2_2, 'String') ', K_{AL} = ' get(handles.input3_2, 'String') ', N = ' get(handles.input4_2, 'String')];
                        
                    case 'scatchard'
                        
                        % Function to get the concentration of A bound
                        [Abound, Afree] = seam_lattice_saturation(MTtot, xvals, KAS, KAL, N);
                        
                        % Ensures that the calculation was successful and
                        % returns an error if it was not
                        [a,b] = size(Abound);
                        if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                        end
 
                        % Sets the x and y values to plot
                        y2 = Abound./Afree;
                        x2 = Abound;

                        % Sets the legend text
                        legend2 = ['Seam binding, [MT] total = ' get(handles.input1_2, 'String') ', K_{AS} = ' get(handles.input2_2, 'String') ', K_{AL} = ' get(handles.input3_2, 'String') ', N = ' get(handles.input4_2, 'String')];
                        
                    
                    otherwise
                end 
            otherwise
        end


    
    elseif strcmpi(handles.mode2, 'MAPbind')
        
        %%%% MAPs bind MT-bound MAPS %%%%

        % Determine the experimental mode
        switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
            % Binding mode is selected
            case 'binding'

                % Gets the value for [A] free and ensures that it's a
                % positive number
                Atot = str2double(get(handles.input1_2, 'String'));

                if isnan(Atot) || Atot <= 0
                    errorbox('Please enter a positive number for [A] total', hObject); 
                    return
                end

                % Gets the value for KAM and ensures that it's a
                % positive number
                KAM = str2double(get(handles.input2_2, 'String'));

                if isnan(KAM) || KAM <= 0
                    errorbox('K_AMT must be a number greater than 0', hObject); 
                    return
                end

                % Gets the value for KAA and ensures that it's a positive
                % number
                KAA = str2double(get(handles.input3_2, 'String'));

                if isnan(KAA) || KAA <= 0
                    errorbox('K_AA must be a number greater than 0', hObject); 
                    return
                end
                
                % Gets the binding ratio and ensures that it's a positive number
                N = str2double(get(handles.input4_2, 'String'));

                if isnan(N) || N <= 0
                   errorbox('The ratio must be a number greater than 0', hObject);
                   return
                end

                % Determines whether the X-axis is free MT or free MT
                switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                    case 'free'

                       % Function to get fraction A bound and free MT 
                       [frac, MTfree] = MAP_binding(xvals, Atot, KAM, KAA, N);
                       
                       % Ensures that the calculation was successful and
                       % returns an error if it was not
                       [a,b] = size(frac);
                       if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                       end

                       % Sets the x and y values to plot
                       y2 = frac;
                       x2 = MTfree;

                       % Sets the legend text
                       legend2 = ['MAP binding, [A] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', K_{AA} = ' get(handles.input3_2, 'String') ', N = ' get(handles.input4_2, 'String')];

                    case 'total'

                        % Function to get fraction A bound
                        [frac, MTfree] = MAP_binding(xvals, Atot, KAM, KAA, N);
                        
                        % Ensures that the calculation was successful and
                        % returns an error if it was not
                        [a,b] = size(frac);
                        if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                        end

                        % Sets the x and y values to plot
                        y2 = frac;
                        x2 = xvals;

                        % Sets the legend text
                        legend2 = ['MAP binding, [A] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', K_{AA} = ' get(handles.input3_2, 'String') ', N = ' get(handles.input4_2, 'String')];

                    otherwise
                end

            % Saturation mode is selected
            case 'saturation'

                % Gets the value for [MT] free and ensures that it's a
                % positive number
                MTtot = str2double(get(handles.input1_2, 'String'));

                if isnan(MTtot) || MTtot <= 0
                    errorbox('Please enter a positive number for [MT] total', hObject); 
                    return
                end

                % Gets the value for KAM and ensures that it's a
                % positive number
                KAM = str2double(get(handles.input2_2, 'String'));

                if isnan(KAM) || KAM <= 0
                    errorbox('K_AMT must be a number greater than 0', hObject); 
                    return
                end

                % Gets the value for KAA and ensures that it's a positive
                % number
                KAA = str2double(get(handles.input3_2, 'String'));

                if isnan(KAA) || KAA <= 0
                    errorbox('K_AA must be a number greater than 0', hObject); 
                    return
                end
                
                % Gets the binding ratio and ensures that it's a positive number
                N = str2double(get(handles.input4_2, 'String'));

                if isnan(N) || N <= 0
                   errorbox('The ratio must be a number greater than 0', hObject);
                   return
                end
                
                % Determines whether the x-axis mode is free or free A
                switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                    case 'free'
                        
                         % Function to get the concentration of A bound
                        [Abound, Afree] = MAP_saturation(MTtot, xvals, KAM, KAA, N);
                        
                        % Ensures that the calculation was successful and
                        % returns an error if it was not
                        [a,b] = size(Abound);
                        if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                        end

                        % Sets the x and y values to plot
                        y2 = Abound;
                        x2 = Afree;

                        % Sets the legend text
                        legend2 = ['MAP binding, [MT] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', K_{AA} = ' get(handles.input3_2, 'String') ', N = ' get(handles.input4_2, 'String')];

                        
                    case 'total'
                        
                         % Function to get the concentration of A bound
                        [Abound, Afree] = MAP_saturation(MTtot, xvals, KAM, KAA, N);
                        
                        % Ensures that the calculation was successful and
                        % returns an error if it was not
                        [a,b] = size(Abound);
                        if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                        end

                        % Sets the x and y values to plot
                        y2 = Abound;
                        x2 = xvals;

                        % Sets the legend text
                        legend2 = ['MAP binding, [MT] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', K_{AA} = ' get(handles.input3_2, 'String') ', N = ' get(handles.input4_2, 'String')];

                    case 'scatchard'
                        
                        % Function to get the concentration of A bound
                        [Abound, Afree] = MAP_saturation(MTtot, xvals, KAM, KAA, N);
                        
                        % Ensures that the calculation was successful and
                        % returns an error if it was not
                        [a,b] = size(Abound);
                        if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                        end

                        % Sets the x and y values to plot
                        y2 = Abound./Afree;
                        x2 = Abound;

                        % Sets the legend text
                        legend2 = ['MAP binding, [MT] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', K_{AA} = ' get(handles.input3_2, 'String') ', N = ' get(handles.input4_2, 'String')];

                    
                    otherwise
                end
            otherwise
        end
        
        
    
    elseif strcmpi(handles.mode2, 'MAPbind2')
        
        %%%% 2 MAPs bind MT-bound MAPS %%%%

        % Determine the experimental mode
        switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
            % Binding mode is selected
            case 'binding'

                % Gets the value for [A] free and ensures that it's a
                % positive number
                Atot = str2double(get(handles.input1_2, 'String'));

                if isnan(Atot) || Atot <= 0
                    errorbox('Please enter a positive number for [A] total', hObject); 
                    return
                end

                % Gets the value for KAM and ensures that it's a
                % positive number
                KAM = str2double(get(handles.input2_2, 'String'));

                if isnan(KAM) || KAM <= 0
                    errorbox('K_AMT must be a number greater than 0', hObject); 
                    return
                end

                % Gets the value for KAA and ensures that it's a positive
                % number
                KAA = str2double(get(handles.input3_2, 'String'));

                if isnan(KAA) || KAA <= 0
                    errorbox('K_AA must be a number greater than 0', hObject); 
                    return
                end
                
                % Gets the binding ratio and ensures that it's a positive number
                N = str2double(get(handles.input4_2, 'String'));

                if isnan(N) || N <= 0
                   errorbox('The ratio must be a number greater than 0', hObject);
                   return
                end

                % Determines whether the X-axis is free MT or free MT
                switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                    case 'free'

                       % Function to get fraction A bound and free MT 
                       [frac, MTfree] = MAP2_binding(xvals, Atot, KAM, KAA, N);
                       
                       % Ensures that the calculation was successful and
                       % retuns an error if it was not
                       [a,b] = size(frac);
                       if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                       end

                       % Sets the x and y values to plot
                       y2 = frac;
                       x2 = MTfree;

                       % Sets the legend text
                       legend2 = ['2 MAP binding, [A] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', K_{AA} = ' get(handles.input3_2, 'String') ', N = ' get(handles.input4_2, 'String')];

                    case 'total'

                        % Function to get fraction A bound
                        [frac, MTfree] = MAP2_binding(xvals, Atot, KAM, KAA, N);
                        
                        % Ensures that the calculation was successful and
                        % returns an error if it was not
                        [a,b] = size(frac);
                        if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                        end

                        % Sets the x and y values to plot
                        y2 = frac;
                        x2 = xvals;

                        % Sets the legend text
                        legend2 = ['2 MAP binding, [A] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', K_{AA} = ' get(handles.input3_2, 'String') ', N = ' get(handles.input4_2, 'String')];

                    otherwise
                end

            % Saturation mode is selected
            case 'saturation'

                % Gets the value for [MT] free and ensures that it's a
                % positive number
                MTtot = str2double(get(handles.input1_2, 'String'));

                if isnan(MTtot) || MTtot <= 0
                    errorbox('Please enter a positive number for [MT] total', hObject); 
                    return
                end

                % Gets the value for KAM and ensures that it's a
                % positive number
                KAM = str2double(get(handles.input2_2, 'String'));

                if isnan(KAM) || KAM <= 0
                    errorbox('K_AMT must be a number greater than 0', hObject); 
                    return
                end

                % Gets the value for KAA and ensures that it's a positive
                % number
                KAA = str2double(get(handles.input3_2, 'String'));

                if isnan(KAA) || KAA <= 0
                    errorbox('K_AA must be a number greater than 0', hObject); 
                    return
                end
                
                % Gets the binding ratio and ensures that it's a positive number
                N = str2double(get(handles.input4_2, 'String'));

                if isnan(N) || N <= 0
                   errorbox('The ratio must be a number greater than 0', hObject);
                   return
                end
                
                % Determines whether the x-axis is free or free A
                switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                    case 'free'
                        
                         % Function to get the concentration of A bound
                        [Abound, Afree] = MAP2_saturation(MTtot, xvals, KAM, KAA, N);
                        
                        % Determines whether the calculation was successful
                        % and returns an error if it was not
                        [a,b] = size(Abound);
                        if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                        end

                        % Sets the x and y values to plot
                        y2 = Abound;
                        x2 = Afree;

                        % Sets the legend text
                        legend2 = ['2 MAP binding, [MT] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', K_{AA} = ' get(handles.input3_2, 'String') ', N = ' get(handles.input4_2, 'String')];

                        
                    case 'total'
                        
                         % Function to get the concentration of A bound
                        [Abound, Afree] = MAP2_saturation(MTtot, xvals, KAM, KAA, N);
                        
                        % Ensures that the calculation was successful and
                        % returns an error if it was not
                        [a,b] = size(Abound);
                        if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                        end

                        % Sets the x and y values to plot
                        y2 = Abound;
                        x2 = xvals;

                        % Sets the legend text
                        legend2 = ['2 MAP binding, [MT] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', K_{AA} = ' get(handles.input3_2, 'String') ', N = ' get(handles.input4_2, 'String')];

                        
                    case 'scatchard'
                        
                         % Function to get the concentration of A bound
                        [Abound, Afree] = MAP2_saturation(MTtot, xvals, KAM, KAA, N);
                        
                        % Ensures that the calculation was successful and
                        % returns an error if it was not
                        [a,b] = size(Abound);
                        if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                        end

                        % Sets the x and y values to plot
                        y2 = Abound./Afree;
                        x2 = Abound;

                        % Sets the legend text
                        legend2 = ['2 MAP binding, [MT] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', K_{AA} = ' get(handles.input3_2, 'String') ', N = ' get(handles.input4_2, 'String')];

                        
                    
                    otherwise
                end
            otherwise
        end

        
    elseif strcmpi(handles.mode2, 'dimer')

    %%%% Dimerization and binding %%%%

    % Determine the experimental mode
    switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
        % Binding mode is selected
        case 'binding'

            % Gets the value for [A] free and ensures that it's a
            % positive number
            Atot = str2double(get(handles.input1_2, 'String'));

            if isnan(Atot) || Atot <= 0
                errorbox('Please enter a positive number for [A] total', hObject); 
                return
            end

            % Gets the value for KAM and ensures that it's a
            % positive number
            KAM = str2double(get(handles.input2_2, 'String'));

            if isnan(KAM) || KAM <= 0
                errorbox('K_AMT must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for KAAM and ensures that it's a positive
            % number
            KAAM = str2double(get(handles.input3_2, 'String'));
            
            if isnan(KAAM) || KAAM <= 0
                errorbox('K_AAMT must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the value for KAA and ensures that it's a positive
            % number
            KAA = str2double(get(handles.input4_2, 'String'));

            if isnan(KAA) || KAA <= 0
                errorbox('K_AA must be a number greater than 0', hObject); 
                return
            end

            % Gets the binding ratio and ensures that it's a positive number
            N = str2double(get(handles.input5_2, 'String'));

            if isnan(N) || N <= 0
               errorbox('The ratio must be a number greater than 0', hObject);
               return
            end

            % Determines whether the X-axis is free MT or free MT
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'

                   % Function to get fraction A bound and free MT 
                   [frac, MTfree] = dimer_binding(xvals, Atot, KAM, KAAM, KAA, N);

                   % Ensures that the calculation was successful and
                   % retuns an error if it was not
                   [a,b] = size(frac);
                   if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                   end

                   % Sets the x and y values to plot
                   y2 = frac;
                   x2 = MTfree;

                   % Sets the legend text
                   legend2 = ['Dimerization, [A] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', K_{AAMT} = ' get(handles.input3_2, 'String') ', K_{AA} = ' get(handles.input4_2, 'String') ', N = ' get(handles.input5_2, 'String')];

                case 'total'

                    % Function to get fraction A bound
                    [frac, MTfree] = dimer_binding(xvals, Atot, KAM, KAAM, KAA, N);

                    % Ensures that the calculation was successful and
                    % returns an error if it was not
                    [a,b] = size(frac);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y values to plot
                    y2 = frac;
                    x2 = xvals;

                    % Sets the legend text
                    legend2 = ['Dimerization, [A] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', K_{AAMT} = ' get(handles.input3_2, 'String') ', K_{AA} = ' get(handles.input4_2, 'String') ', N = ' get(handles.input5_2, 'String')];

                otherwise
            end

        % Saturation mode is selected
        case 'saturation'

            % Gets the value for [MT] free and ensures that it's a
            % positive number
            MTtot = str2double(get(handles.input1_2, 'String'));

            if isnan(MTtot) || MTtot <= 0
                errorbox('Please enter a positive number for [MT] total', hObject); 
                return
            end

            % Gets the value for KAM and ensures that it's a
            % positive number
            KAM = str2double(get(handles.input2_2, 'String'));

            if isnan(KAM) || KAM <= 0
                errorbox('K_AM must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for KAAM and ensures that it's a positive
            % number
            KAAM = str2double(get(handles.input3_2, 'String'));

            if isnan(KAAM) || KAAM <= 0
                errorbox('K_AAMT must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the value for KAA and ensures that it's a positive
            % number
            KAA = str2double(get(handles.input3_2, 'String'));

            if isnan(KAA) || KAA <= 0
                errorbox('K_AA must be a number greater than 0', hObject); 
                return
            end

            % Gets the binding ratio and ensures that it's a positive number
            N = str2double(get(handles.input5_2, 'String'));

            if isnan(N) || N <= 0
               errorbox('The ratio must be a number greater than 0', hObject);
               return
            end

            % Determines whether the x-axis is free or free A
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'

                     % Function to get the concentration of A bound
                    [Abound, Afree] = dimer_saturation(MTtot, xvals, KAM, KAAM, KAA, N);

                    % Determines whether the calculation was successful
                    % and returns an error if it was not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y values to plot
                    y2 = Abound;
                    x2 = Afree;

                    % Sets the legend text
                    legend2 = ['Dimerization, [MT] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', K_{AAMT} = ' get(handles.input3_2, 'String') ', K_{AA} = ' get(handles.input4_2, 'String') ', N = ' get(handles.input5_2, 'String')];


                case 'total'

                     % Function to get the concentration of A bound
                    [Abound, Afree] = dimer_saturation(MTtot, xvals, KAM, KAAM, KAA, N);

                    % Ensures that the calculation was successful and
                    % returns an error if it was not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y values to plot
                    y2 = Abound;
                    x2 = xvals;

                    % Sets the legend text
                    legend2 = ['Dimerization, [MT] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', K_{AAMT} = ' get(handles.input3_2, 'String') ', K_{AA} = ' get(handles.input4_2, 'String') ', N = ' get(handles.input5_2, 'String')];


                case 'scatchard'
                    
                    
                     % Function to get the concentration of A bound
                    [Abound, Afree] = dimer_saturation(MTtot, xvals, KAM, KAAM, KAA, N);

                    % Ensures that the calculation was successful and
                    % returns an error if it was not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y values to plot
                    y2 = Abound./Afree;
                    x2 = Abound;

                    % Sets the legend text
                    legend2 = ['Dimerization, [MT] total = ' get(handles.input1_2, 'String') ', K_{AMT} = ' get(handles.input2_2, 'String') ', K_{AAMT} = ' get(handles.input3_2, 'String') ', K_{AA} = ' get(handles.input4_2, 'String') ', N = ' get(handles.input5_2, 'String')];

                
                otherwise
            end
        otherwise
    end


    end

    
end

% Create a graph window if necessary
if (ishandle(handles.graphfigure) == 0 || ishandle(handles.graphaxes == 0))
    handles.graphfigure = figure('CloseRequestFcn', {@graph_CloseReq, hObject});
    handles.graphaxes = axes;
    handles.color = 0;
    handles.graphopen = 1;
    figureopen(hObject);
end

% Activate the graph window
figure(handles.graphfigure);

% Updates xmax_all and xmin_all
if min(x1) < handles.xmin_all
    handles.xmin_all = min(x1);
end

if max(x1) > handles.xmax_all
    handles.xmax_all = max(x1);
end

% Plots the x and y data for the first curve
hold on
h = plot(handles.graphaxes, x1, y1);
xlabel(xaxis);
ylabel(yaxis);
title(plottitle);

add_legend(handles, legend1);

% Rotates through colors and colors the plot
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

if strcmp(get(get(handles.exp_mode, 'SelectedObject'), 'Tag'), 'binding')
    axis([handles.xmin_all handles.xmax_all 0 1])
end


% Determines if comparision mode is selected and calculates the
% second curve
if strcmp(get(get(handles.plot_mode, 'SelectedObject'), 'Tag'), 'compare')
    
    % Updates xmax_all and xmin_all
    if min(x1) < handles.xmin_all
        handles.xmin_all = min(x2);
    end

    if max(x1) > handles.xmax_all
        handles.xmax_all = max(x2);
    end
    
    %plots the x and y data
    hold on
    h = plot(handles.graphaxes, x2, y2);
    
    add_legend(handles, legend2);

    % Rotates through the colors and colors the plot
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
    
    if strcmp(get(get(handles.exp_mode, 'SelectedObject'), 'Tag'), 'binding')
    axis([handles.xmin_all handles.xmax_all 0 1])
    end
    
    % Computes and displays the differences between the two curves if the
    % x-axis is in free mode
    if strcmp(get(get(handles.tot_free, 'SelectedObject'), 'Tag'), 'total') || strcmp(get(get(handles.exp_mode, 'SelectedObject'), 'Tag'), 'competition')

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
end
    
% Updates the handles
guidata(hObject, handles);

% Enables all buttons and sets the pointer to arrow
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

% Clears the results string
set(handles.result, 'String', '');

% Resets xmin_all and xmax_all
handles.xmin_all = 1*10^20;
handles.xmax_all = 0;

% Calls the close figure function
figureclose(hObject);

% Updates the handles
guidata(hObject, handles);
end


% Save the axes out as a spreadsheet
function save_Spreadsheet(filename, axes, list, xls)
% filename   Path of file to write
% axes       Axes to save
% list       List of 'line' objects to write
% xls        1 for Excel file, 0 otherwise

% Get the legend text strings
[legend_h,object_h,plot_h,legend_strings] = legend(axes);

% Loop over the list of objects, deal only with the 'line's
saveddata = 0;
data = {};

for i = 1:length(list)
    if ishandle(list(i)) == 0
        continue;
    end
    
    % Okay, we have a line object -- get its XData and YData
    xdata = get(list(i), 'XData');
    ydata = get(list(i), 'YData');
    
    % Sanity check
    if isempty(xdata) || isempty(ydata)
        continue;
    end
    
    % Convert from matrices to cell arrays
    xca = strread(num2str(xdata), '%s');
    yca = strread(num2str(ydata), '%s');
    
    % Get the legend string for this graph
    ls = legend_strings(i);
    
    % Hack something up if there's a problem
    if isempty(ls)
        ls = 'UNKNOWN GRAPH';
    end
    
    % Make X and Y legend strings
    lx = strcat('"', ls, ' X"');
    ly = strcat('"', ls, ' Y"');
    
    % Prepend them onto the cell arrays
    xca = [lx; xca];
    yca = [ly; yca];
    
    % We may have to resize the data/*ca arrays
    if isempty(data) == 0
        datasize = size(data);
        newsize = size(xca);
        
        if datasize(1) < newsize(1)
            data{newsize(1),1} = '';
        elseif newsize(1) < datasize(1)
            xca{datasize(1),1} = '';
            yca{datasize(1),1} = '';
        end
    end
    
    % Stick the new columns, horizontally, onto our dataset
    data = [xca yca data];
    
    % We have some data
    saveddata = 1;
end

% Warn the user if we didn't actually save anything
if saveddata == 0
    msgbox('Cannot save graph data, no curves on graph!', 'MTBindingSim Error', 'error');
    return;
end

% Loop over the array and convert any [] items into '' so we have a solid
% array of strings
datasize = size(data);

for row = 1:datasize(1)
    for col = 1:datasize(2)
        if isempty(data{row,col})
            data{row,col} = '';
        end
    end
end

% Got some good data, write it out
if xls
    % Try Excel, but be careful to detect errors (which are frequent)
    status = xlswrite(filename, data);
    
    if status == true
        return;
    end
    
    % That failed, let's try to delete the bootleg file that xlswrite
    % produced -- it will choke on many platforms when passed a cell array.
    delete(filename);
    
    % Report an error and fail, anything else might delete user data.
    msgbox('ERROR: Your platform does not support the creation of .XLS files.  If you wish to save a spreadsheet, you may save in CSV format instead.',...
        'MTBindingSim Error', 'error');
    return;
end

% Okay, write out a CSV file, the good old-fashioned way
fid = fopen(filename, 'w');

for row = 1:datasize(1)
    for col = 1:datasize(2)
        fprintf(fid, '%s', data{row,col});
        if col ~= datasize(2)
            fprintf(fid, ',');
        end
    end
    fprintf(fid, '\n');
end

fclose(fid);

end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Make sure there's a graph window open, if not report an error
if ishandle(handles.graphaxes) == 0 || ishandle(handles.graphfigure) == 0
    msgbox('Attempted to save graph when no graph was present.  Please report this as a bug!', 'MTBindingSim Error', 'error');
    return;
end

% Get the children of the graph window, including hidden children
list = get(handles.graphaxes, 'Children');
if size(list) == 0
    msgbox('Cannot save graph data, no curves on graph!', 'MTBindingSim Error', 'error');
    return;
end

% Okay, pop up a message box and let's figure out whether we're saving an
% image or the raw data.
[FileName,PathName,FilterIndex] = uiputfile(...
    {'*.ai','Adobe Illustrator image (*.ai)';...
     '*.csv','CSV spreadsheet file (*.csv)';...
     '*.eps','EPS image (*.eps)';...
     '*.fig','MATLAB figure (*.fig)';...
     '*.jpg','JPEG image (*.jpg)';...
     '*.mat','MATLAB file (*.mat)';...
     '*.pdf','PDF image (*.pdf)';...
     '*.png','PNG image (*.png)';...
     '*.tif','TIFF image (*.tif)';...
     '*.xls','Excel spreadsheet file (*.xls)'},...
     'Save graph as');

% Image drivers for each of these
imagedrivers = {'-dill', '', '-depsc2', '', '-djpeg', '', '-dpdf', '-dpng', '-dtiff', ''};
 
if isequal(FileName, 0) || isequal(PathName, 0) || isequal(FilterIndex, 0)
    % User selected Cancel
    return;
end

% Get the full filename
fullname = fullfile(PathName, FileName);
 
% The spreadsheets are indexes 2 (CSV) and 10 (XLS)
if FilterIndex == 2
    save_Spreadsheet(fullname, handles.graphaxes, list, 0);
    return;
elseif FilterIndex == 10
    save_Spreadsheet(fullname, handles.graphaxes, list, 1);
    return;
elseif FilterIndex == 4 || FilterIndex == 6
    % The MATLAB files are indexes 4 (FIG) and 6 (MAT)
    hgsave(handles.graphfigure, fullname);
    return;
else
    % All else are images
    print(handles.graphfigure, imagedrivers{FilterIndex}, fullname);
    return;
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  Radio Button and Drop Down Menu Callback Code  %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on selection change in curve1.
function curve1_Callback(hObject, eventdata, handles)
% hObject    handle to curve1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Gets selected function
switch get(handles.curve1, 'Value')
    % First order binding
    case 1
        
        handles.mode1 = 'firstorder';
        
        %determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                first_order_binding_labels1(hObject);
                
            case 'saturation'
                first_order_saturation_labels1(hObject);
                            
            otherwise
        end
        
    % MT seam and lattice binding
    case 2
        
        handles.mode1 = 'seam';
        
        %determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                
               seam_binding_labels1(hObject);
                
            case 'saturation'
                
               seam_saturation_labels1(hObject);
                
            otherwise
        end
        
    % Dimer binding    
    case 3
        
        handles.mode1 = 'dimer';
        
        % Determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                
                dimer_binding_labels1(hObject);
               
            case 'saturation'
                
                dimer_saturation_labels1(hObject);
                
            otherwise
        end
    
        
        
    % Traditional cooperatitivity model removed because we are unsure about
    % the calcualtions
        
    % Traditional cooperativity
    %case 4
    %    
    %    handles.mode1 = 'cooperativity';
    %    
    %    %determine which experimental mode is selected
    %    switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
    %        case 'binding'
    %            cooperativity_binding_labels1(hObject);
    %            
    %        case 'saturation'
    %            cooperativity_saturation_labels1(hObject);
    %            
    %        otherwise
    %    end
        

        
    % MAPs bind MT-bound MAPs
    case 4
        
        handles.mode1 = 'MAPbind';
        
        %determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                
                MAP_binding_labels1(hObject);
               
            case 'saturation'
                
                MAP_saturation_labels1(hObject);
                
            otherwise
        end
    
    % 2 MAPs bind MT-bound MAPs
    case 5
        
        handles.mode1 = 'MAPbind2';
        
        % Determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                
                MAP2_binding_labels1(hObject);
               
            case 'saturation'
                
                MAP2_saturation_labels1(hObject);
                
            otherwise
        end
     
        
    otherwise
end

% Updates the handles structure
guidata(hObject, handles);

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
        
        handles.mode2 = 'firstorder';
        
        %determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                first_order_binding_labels2(hObject);
                
            case 'saturation'
                first_order_saturation_labels2(hObject);
                            
            otherwise
        end
        
    % MT seam and lattice binding
    case 2
         
        handles.mode2 = 'seam';
        
        %determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                
               seam_binding_labels2(hObject);
                
            case 'saturation'
                
               seam_saturation_labels2(hObject);
                
            otherwise
        end
        
        
               
    % Dimerization binding
    case 3
        
        handles.mode2 = 'dimer';
        
        %determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                
                dimer_binding_labels2(hObject);
               
            case 'saturation'
                
                dimer_saturation_labels2(hObject);
                
            otherwise
        end
    
        
    % Traditional cooperatitivity model removed because we are unsure about
    % the calcualtions    
        
    % Traditional cooperativity
    %case 4
    %    
    %    handles.mode2 = 'cooperativity';
    %    
    %    %determine which experimental mode is selected
    %    switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
    %        case 'binding'
    %            cooperativity_binding_labels2(hObject);
    %            
    %        case 'saturation'
    %            cooperativity_saturation_labels2(hObject);
    %            
    %        otherwise
    %    end
        

        
    % MAPs bind MT-bound MAPs
    case 4
        
        handles.mode2 = 'MAPbind';
        
        %determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                
                MAP_binding_labels2(hObject);
               
            case 'saturation'
                
                MAP_saturation_labels2(hObject);
                
            otherwise
        end
        
    % 2 MAPs bind MT-bound MAPs
    case 5
        
        handles.mode2 = 'MAPbind2';
        
        %determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                
                MAP2_binding_labels2(hObject);
               
            case 'saturation'
                
                MAP2_saturation_labels2(hObject);
                
            otherwise
        end
        
        
    otherwise
end

% Updates the handles structure
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
    
    % Deletes the axes
    if (ishandle(handles.graphaxes))
        delete(handles.graphaxes);
        handles.graphaxes = -1;
    end
    if (ishandle(handles.graphfigure))
        delete(handles.graphfigure);
        handles.graphfigure = -1;
    end
    
    % Resets xmin_all and xmax_all
    handles.xmin_all = 1*10^20;
    handles.xmax_all = 0;
    
    % Changes the graph and save buttons
    figureclose(hObject);
    
    % Updates the handles structure
    guidata(hObject, handles);
    
end

% Get tag of selected buton
switch get(eventdata.NewValue, 'Tag')
    case 'binding'
        
        % Makes the curve selection drop down boxes visible
        set(handles.curve1, 'Visible', 'on');
        
        % Makes the X-axis selection box visible
        set(handles.tot_free, 'Visible', 'on');
        
        % Makes the scatchard radio button invisible
        set(handles.scatchard, 'Visible', 'off');
        
        % Determines which model is selected and sets the labels
        % accordingly

        % First order biding selected
        if strcmpi(handles.mode1, 'firstorder')

            first_order_binding_labels1(hObject);

        % Seam and lattice binding selected
        elseif strcmpi(handles.mode1, 'seam')

            seam_binding_labels1(hObject);

        % Dimerization binding selected
        elseif strcmpi(handles.mode1, 'dimer')

            dimer_binding_labels1(hObject);

        % Cooperativity selected
        elseif strcmpi(handles.mode1, 'cooperativity')

            cooperativity_binding_labels1(hObject);

        % MAPs bind MT-bound MAPs selected
        elseif strcmpi(handles.mode1, 'MAPbind')

            MAP_binding_labels1(hObject);

        elseif strcmpi(handles.mode1, 'MAPbind2')

            MAP2_binding_labels1(hObject);
            
        end

        % Determines if single or comparision mode is selected
        % Changes visible boxes for the second curve if comparision mode is
        % selected
        if strcmp(get(get(handles.plot_mode, 'SelectedObject'), 'Tag'), 'compare')
            
            % Makes the curve selction box visible
            set(handles.curve2, 'Visible', 'on');
            
            % Gets the current value of the first curve slection box and
            % changes the visible boxes accordingly
            
            % First order biding selected
            if strcmpi(handles.mode2, 'firstorder')
                first_order_binding_labels2(hObject);

            % Seam and lattice binding selected
            elseif strcmpi(handles.mode2, 'seam')

                seam_binding_labels2(hObject);

            % Dimerization binding selected
            elseif strcmpi(handles.mode2, 'dimer')

                dimer_binding_labels2(hObject);

            % Cooperativity is selected
            elseif strcmpi(handles.mode2, 'cooperativity')

                cooperativity_binding_labels2(hObject);

            
            % MAPs bind MT-bound MAPs selected
            elseif strcmpi(handles.mode2, 'MAPbind')

                MAP_binding_labels2(hObject);

            % 2 MAPs bind MT-bound MAPs selected    
            elseif strcmpi(handles.mode2, 'MAPbind2')

                MAP2_binding_labels2(hObject);

            end
            
        end
        
    case 'saturation'
        
        % Makes the curve selection drop down boxes visible
        set(handles.curve1, 'Visible', 'on');
        
        % Makes the X-axis selection box visible
        set(handles.tot_free, 'Visible', 'on');
        
        % Makes the scatchard radio button visible
        set(handles.scatchard, 'Visible', 'on');

        % Gets the current value of the first curve slection box and
        % changes the visible boxes accordingly
        
        % First order biding selected
        if strcmpi(handles.mode1, 'firstorder')

            first_order_saturation_labels1(hObject);

        % Cooperative binding selected
        elseif strcmpi(handles.mode1, 'cooperativity')

            cooperativity_saturation_labels1(hObject);

        % Seam and lattice binding selected
        elseif strcmpi(handles.mode1, 'seam')

            seam_saturation_labels1(hObject);

        % MAPs bind MT-bound MAPs selected
        elseif strcmpi(handles.mode1, 'MAPbind')

            MAP_saturation_labels1(hObject);

        % 2 MAPs bind MT-bound MAPs selected
        elseif strcmpi(handles.mode1, 'MAPbind2')

            MAP2_saturation_labels1(hObject);

        % Dimer binding is selected
        elseif strcmpi(handles.mode1, 'dimer')

            dimer_saturation_labels1(hObject);


        end
        
        % Determines if single or comparision mode is selected
        % Changes visible boxes for the second curve if comparision mode is
        % selected
        if strcmp(get(get(handles.plot_mode, 'SelectedObject'), 'Tag'), 'compare')
            
            % Makes the curve selection box visible
            set(handles.curve2, 'Visible', 'on');
            
            % Gets the current value of the second curve slection box and
            % changes the visible boxes accordingly
            
            % First order biding selected
            if strcmpi(handles.mode2, 'firstorder')

                first_order_saturation_labels2(hObject);

            % Cooperative binding selected
            elseif strcmpi(handles.mode2, 'cooperativity')

                cooperativity_saturation_labels2(hObject);

            % Seam and lattice binding selected
            elseif strcmpi(handles.mode2, 'seam')

                seam_saturation_labels2(hObject);

            % MAPs bind MT-bound MAPs selected
            elseif strcmpi(handles.mode2, 'MAPbind')

                MAP_saturation_labels2(hObject);

            % 2 MAPs bind MT-bound MAPs selected
            elseif strcmpi(handles.mode2, 'MAPbind2')

                MAP2_saturation_labels2(hObject);

            % Dimer binding is selected
            elseif strcmpi(handles.mode2, 'dimer')

                dimer_saturation_labels2(hObject);

            end
            
        end
        
    case 'competition'
        
        % Sets the visibility of the x-axis selection box
        set(handles.tot_free, 'Visible', 'off');
        
        % Makes the curve selection drop down boxes invisible
        set(handles.curve1, 'Visible', 'off');
        set(handles.curve2, 'Visible', 'off');
        
        competition_labels1(hObject);
        
        % Determines if comparision mode is selected
        if strcmp(get(get(handles.plot_mode, 'SelectedObject'), 'Tag'), 'compare')
            
            competition_labels2(hObject);
        end
        
        
    otherwise
end

% Retreives the new guidata after the input boxes have been changed
handles = guidata(hObject);

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
                        
                        seam_binding_labels2(hObject);
                        
                    case 3
                        
                        dimer_binding_labels2(hObject);
                        
                    case 4
                        
                        cooperativity_binding_labels2(hObject);
                        
                    case 5
                        
                        MAP_binding_labels2(hObject);
                        
                    case 6
                        
                        MAP2_binding_labels2(hObject);
                        
                    otherwise
                end
                
            case 'saturation'
                
                switch get(handles.curve2, 'Value')
                    
                    case 1
                        
                        first_order_saturation_labels2(hObject);
                        
                    case 2
                        
                        seam_saturation_labels2(hObject);
                        
                    case 3
                        
                        dimer_saturation_labels2(hObject);
                        
                    case 4
                        
                        cooperativity_saturation_labels2(hObject);
                        
                    case 5
                        
                        MAP_saturation_labels2(hObject);
                        
                    case 6
                        
                        MAP2_saturation_labels2(hObject);
                        
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
    
    % Resets xmin_all and xmax_all
    handles.xmin_all = 1*10^20;
    handles.xmax_all = 0;
    
    % Changes the graph and save buttons
    figureclose(hObject);
    
end

% Update the handles structure
guidata(hObject, handles)

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%     Functions that change box labels    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function first_order_strings(model, equation)

% Generates the model and equation strings for first order

global KAM;
set_java_component(model, 'A + MT &#8596; AMT');
set_java_component(equation, [KAM, ' = [A][MT]/[AMT]']);
end

function cooperativity_strings(model, equation)

% Generates the model and equation strings for cooperatitivy

global KAM;
set_java_component(model, 'A + MT &#8596; AMT, A + AMT &#8596; A<sub><small>2</small></sub>MT<sub><small>2</small</sub>');
set_java_component(equation, [KAM, ' = [A][MT]/[AMT], &#981;&#8901;', KAM, ' = [A][AMT]/[A<sub><small>2</small</sub>MT<sub><small>2</small</sub>]']);
end

function seam_strings(model, equation)

% Generates the model and equation strings for seam and lattice binding

global KAS KAL;
set_java_component(model, 'A + S &#8596; AS, A + L &#8596; AL');
set_java_component(equation, [KAL, ' = [A][L]/[AL], ', KAS, ' = [A][S]/[AS]']);
end

function MAP_strings(model, equation)

% Generates the model and equation strings for MAPs bind MT-bound MAPs

global KAM KAA;
set_java_component(model, 'A + MT &#8596; AMT, A + AMT &#8596; A<sub><small>2</small></sub>MT');
set_java_component(equation, [KAM, ' = [A][MT]/[AMT], ', KAA, ' = [A][AMT]/[A<sub><small>2</small></sub>MT]']);
end

function MAP2_strings(model, equation)

% Generates the model and equation strings for 2 MAPs bind MT-bound MAPs

global KAM KAA;
set_java_component(model, 'A + MT &#8596; AMT, A + AMT &#8596; A<sub><small>2</small></sub>MT, A + A<sub><small>2</small></sub>MT &#8596; A<sub><small>3</small></sub>MT');
set_java_component(equation, [KAM, ' = [A][MT]/[AMT], ', KAA, ' = [A][AMT]/[A<sub><small>2</small></sub>MT],<br>', KAA, ' = [A][A<sub><small>2</small></sub>MT]/[A<sub><small>3</small></sub>MT]']);
end


function dimer_strings(model, equation)

% Generates the model and equation strings for dimerization

global KAA KAM KAAM;
set_java_component(model, 'A + MT &#8596; AMT, A<sub><small>2</small></sub> + MT &#8596; A<sub><small>2</small></sub>MT<sub><small>2</small></sub>, A + A &#8596; A<sub><small>2</small></sub>');
set_java_component(equation, [KAM, ' = [A][MT]/[AMT], ', KAAM, ' = [A<sub><small>2</small></sub>][MT]/[A<sub><small>2</small></sub>MT<sub><small>2</small></sub>], ', KAA, ' = [A][A]/[A<sub><small>2</small></sub>]']);
end


function competition_strings(model, equation)

% Generates the model and equation strings for competition

global KAM KBM;
set_java_component(model, 'A + MT &#8596; AMT, B + MT &#8596; BMT');
set_java_component(equation, [KAM, ' =[A][MT]/[AMT], ', KBM, ' =[B][MT]/[BMT]']);
end


function first_order_binding_labels1(hObject)
% Function to update the apperence of MTBindingSim for the case where the
% first function is first order binding in binding mode

global KAM;

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
set_java_component(handles.label2_1, [KAM, ' ']);
set_java_component(handles.label3_1, '1 MT : ');
set_java_component(handles.units3_1, 'A');

% Sets the default ratio to 1
set(handles.input3_1, 'String', '1');

% Updates the handles structure
guidata(hObject, handles);

end



function first_order_saturation_labels1(hObject)
% Function to update the appearence of binding_BUI for the case where the
% first function is first oder binding in saturation mode

global KAM;

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
set_java_component(handles.label2_1, [KAM, ' ']);
set_java_component(handles.label3_1, '1 MT : ');
set_java_component(handles.units3_1, 'A');

% Sets the default ratio to 1
set(handles.input3_1, 'String', '1');

% Updates the handles structure
guidata(hObject, handles);

end



function cooperativity_binding_labels1(hObject)
% Function to update the appearence of MTBindingSim for the case where the
% first function is cooperative binding in binding mode

global KAM;

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
set_java_component(handles.label2_1, [KAM, ' ']);
set_java_component(handles.label3_1, '&#981; ');
set_java_component(handles.label4_1, '1 MT : ');
set_java_component(handles.units4_1, 'A');

% Sets the default ratio to 1
set(handles.input4_1, 'String', '1');

% Hides the units label for p
set(handles.units3_1, 'Visible', 'off');

% Updates the handles structure
guidata(hObject, handles);

end



function cooperativity_saturation_labels1(hObject)
%Function to update the appearance of MTBindingSim for the case where the
%first function is cooperative binding in saturation mode

global KAM;

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
set_java_component(handles.label2_1, [KAM, ' ']);
set_java_component(handles.label3_1, '&#981; ');
set_java_component(handles.label4_1, '1 MT : ');
set_java_component(handles.units4_1, 'A');

% Sets the default ratio to 1
set(handles.input4_1, 'String', '1');

% Hides the units label for p
set(handles.units3_1, 'Visible', 'off');

% Updates the handles structure
guidata(hObject, handles);

end



function seam_binding_labels1(hObject)
% Function to update the appearence of MTBindingSim for the case where the
% first function is seam and lattice binding in binding mode

global KAS KAL UM;

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
set_java_component(handles.label2_1, [KAS, ' ']);
set_java_component(handles.label3_1, [KAL, ' ']);
set_java_component(handles.units3_1, [UM, ' ']);
set_java_component(handles.label4_1, '1 MT : ');
set_java_component(handles.units4_1, 'A');

% Sets the default ratio to 1
set(handles.input4_1, 'String', '1');

% Updates the handles structure
guidata(hObject, handles);

end



function seam_saturation_labels1(hObject)
% Function to update the appearence of MTBindingSim for the case where the
% first function is seam and lattice binding in saturation mode

global KAS KAL UM;

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
set_java_component(handles.label2_1, [KAS, ' ']);
set_java_component(handles.label3_1, [KAL, ' ']);
set_java_component(handles.units3_1, [UM, ' ']);
set_java_component(handles.label4_1, '1 MT : ');
set_java_component(handles.units4_1, 'A');

% Sets the default ratio to 1
set(handles.input4_1, 'String', '1');

% Updates the handles structure
guidata(hObject, handles);

end



function MAP_binding_labels1(hObject)
%Function to update the appearance of MTBindingSim for the case where the
%first function is the MAPs bind to MT-bound MAPs model in binding mode

global KAM KAA UM;

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
set_java_component(handles.label2_1, [KAM, ' ']);
set_java_component(handles.label3_1, [KAA, ' ']);
set_java_component(handles.units3_1, [UM, ' ']);
set_java_component(handles.label4_1, '1 MT : ');
set_java_component(handles.units4_1, 'A');

% Sets the default ratio to 1
set(handles.input4_1, 'String', '1');

% Updates the handles structure
guidata(hObject, handles);

end



function MAP_saturation_labels1(hObject)
%Function to update the appearance of MTBindingSim for the case where the
%first function is the MAPs bind to MT-bound MAPs model in saturation mode

global KAM KAA UM;

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
set_java_component(handles.label2_1, [KAM, ' ']);
set_java_component(handles.label3_1, [KAA, ' ']);
set_java_component(handles.units3_1, [UM, ' ']);
set_java_component(handles.label4_1, '1 MT : ');
set_java_component(handles.units4_1, 'A');

% Sets the default ratio to 1
set(handles.input4_1, 'String', '1');

% Updates the handles structure
guidata(hObject, handles);

end

function MAP2_binding_labels1(hObject)
%Function to update the appearance of MTBindingSim for the case where the
%first function is 2 MAPs bind to MT-bound MAPs model in binding mode

global KAM KAA UM;

% Sets the visibility for all input boxes
inputboxes_display1(hObject, 4);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets model equation and text
MAP2_strings(handles.model1, handles.equation1);

% Sets labels for the input boxes
set(handles.label_xmin, 'String', '[MT] total min ');
set(handles.label_xmax, 'String', '[MT] total max ');
set(handles.total, 'String', '[MT] total');
set(handles.free, 'String', '[MT] free');
set_java_component(handles.label1_1, '[A] total ');
set_java_component(handles.label2_1, [KAM, ' ']);
set_java_component(handles.label3_1, [KAA, ' ']);
set_java_component(handles.units3_1, [UM, ' ']);
set_java_component(handles.label4_1, '1 MT : ');
set_java_component(handles.units4_1, 'A');

% Sets the default ratio to 1
set(handles.input4_1, 'String', '1');

% Updates the handles structure
guidata(hObject, handles);

end



function MAP2_saturation_labels1(hObject)
%Function to update the appearance of MTBindingSim for the case where the
%first function is 2 MAPs bind to MT-bound MAPs model in saturation mode

global KAM KAA UM;

% Sets the visibility for all input boxes
inputboxes_display1(hObject, 4);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets model equation and text
MAP2_strings(handles.model1, handles.equation1);

% Sets labels for the input boxes
set(handles.label_xmin, 'String', '[A] total min ');
set(handles.label_xmax, 'String', '[A] total max ');
set(handles.total, 'String', '[A] total');
set(handles.free, 'String', '[A] free');
set_java_component(handles.label1_1, '[MT] total ');
set_java_component(handles.label2_1, [KAM, ' ']);
set_java_component(handles.label3_1, [KAA, ' ']);
set_java_component(handles.units3_1, [UM, ' ']);
set_java_component(handles.label4_1, '1 MT : ');
set_java_component(handles.units4_1, 'A');

% Sets the default ratio to 1
set(handles.input4_1, 'String', '1');

% Updates the handles structure
guidata(hObject, handles);

end

function dimer_binding_labels1(hObject)
% Function to update the appearnce of MTBindinSim for the case where the
% first function is dimerization in binding mode

global KAA KAM KAAM UM;

% Sets the visibility for all imput boxes
inputboxes_display1(hObject, 5);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the model equation and text
dimer_strings(handles.model1, handles.equation1);

% Sets labels for the input boxes
set(handles.label_xmin, 'String', '[MT] total min ');
set(handles.label_xmax, 'String', '[MT] total max ');
set(handles.total, 'String', '[MT] total');
set(handles.free, 'String', '[MT] free');
set_java_component(handles.label1_1, '[A] total ');
set_java_component(handles.label2_1, [KAM, ' ']);
set_java_component(handles.label3_1, [KAAM, ' ']);
set_java_component(handles.units3_1, [UM, ' ']);
set_java_component(handles.label4_1, [KAA, ' ']);
set_java_component(handles.units4_1, [UM, ' ']);
set_java_component(handles.label5_1, '1 MT : ');
set_java_component(handles.units5_1, 'A');

% Sets the default ratio to 1
set(handles.input5_1, 'String', '1');

% Updates the handles structure
guidata(hObject, handles);

end

function dimer_saturation_labels1(hObject)
% Function to update the appearnce of MTBindinSim for the case where the
% first function is dimerization in saturation mode

global KAA KAM KAAM UM;

% Sets the visibility for all imput boxes
inputboxes_display1(hObject, 5);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the model equation and text
dimer_strings(handles.model1, handles.equation1);

% Sets labels for the input boxes
set(handles.label_xmin, 'String', '[A] total min ');
set(handles.label_xmax, 'String', '[A] total max ');
set(handles.total, 'String', '[A] total');
set(handles.free, 'String', '[A] free');
set_java_component(handles.label1_1, '[MT] total ');
set_java_component(handles.label2_1, [KAM, ' ']);
set_java_component(handles.label3_1, [KAAM, ' ']);
set_java_component(handles.units3_1, [UM, ' ']);
set_java_component(handles.label4_1, [KAA, ' ']);
set_java_component(handles.units4_1, [UM, ' ']);
set_java_component(handles.label5_1, '1 MT : ');
set_java_component(handles.units5_1, 'A');

% Sets the default ratio to 1
set(handles.input5_1, 'String', '1');

% Updates the handles structure
guidata(hObject, handles);

end


function competition_labels1(hObject)
% Function to update the appearnce of MTBindingSim for the case where
% the competition experimental mode is selected

global KAM KBM UM;

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
set_java_component(handles.label3_1, [KAM, ' ']);
set_java_component(handles.units3_1, [UM, ' ']);
set_java_component(handles.label4_1, [KBM, ' ']);
set_java_component(handles.units4_1, [UM, ' ']);

% Updates the handles structure
guidata(hObject, handles);

end



function first_order_binding_labels2(hObject)
% Function to update the apperence of MTBindingSim for the case where the
% first function is first order binding in binding mode

global KAM;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 3);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the equation and model text
first_order_strings(handles.model2, handles.equation2);

% Sets labels for the visible input boxes
set_java_component(handles.label1_2, '[A] total ');
set_java_component(handles.label2_2, [KAM, ' ']);
set_java_component(handles.label3_2, '1 MT : ');
set_java_component(handles.units3_2, 'A');

% Sets the default ratio to 1
set(handles.input3_2, 'String', '1');

% Updates the handles structure
guidata(hObject, handles);

end


function first_order_saturation_labels2(hObject)
% Function to update the appearence of MTBindingSim for the case where the
% frist function is first oder binding in saturation mode

global KAM;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 3);

handles = guidata(hObject);

% Sets the equation and model text
first_order_strings(handles.model2, handles.equation2);

% Sets labels for the input boxes
set_java_component(handles.label1_2, '[MT] total ');
set_java_component(handles.label2_2, [KAM, ' ']);
set_java_component(handles.label3_2, '1 MT : ');
set_java_component(handles.units3_2, 'A');

% Sets the default ratio to 1
set(handles.input3_2, 'String', '1');

% Updates the handles structure
guidata(hObject, handles);

end



function cooperativity_binding_labels2(hObject)
% Function to update the appearence of MTBindingSim for the case where the
% first function is cooperative binding in binding mode

global KAM;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 4);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the equations and model text
cooperativity_strings(handles.model2, handles.equation2);
                
% Sets labels for the input boxes
set_java_component(handles.label1_2, '[A] total ');
set_java_component(handles.label2_2, [KAM, ' ']);
set_java_component(handles.label3_2, '&#981; ');
set_java_component(handles.label4_2, '1 MT : ');
set_java_component(handles.units4_2, 'A');

% Sets the default ratio to 1
set(handles.input4_2, 'String', '1');

% Hides the units label for phi
set(handles.units3_2, 'Visible', 'off');

% Updates the handles structure
guidata(hObject, handles);

end



function cooperativity_saturation_labels2(hObject)
%Function to update the appearance of MTBindingSim for the case where the
%first function is cooperative binding in saturation mode

global KAM;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 4);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the equations and model text
cooperativity_strings(handles.model2, handles.equation2);

%Sets labels for the input boxes
set_java_component(handles.label1_2, '[MT] total ');
set_java_component(handles.label2_2, [KAM, ' ']);
set_java_component(handles.label3_2, '&#981; ');
set_java_component(handles.label4_2, '1 MT : ');
set_java_component(handles.units4_2, 'A');

% Sets the default ratio to 1
set(handles.input4_2, 'String', '1');

% Hides the units label for p
set(handles.units3_2, 'Visible', 'off');

% Updates the handles structure
guidata(hObject, handles);

end


function seam_binding_labels2(hObject)
% Function to update the appearence of MTBindingSim for the case where the
% first function is seam and lattice binding in binding mode

global KAS KAL UM;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 4);

% Retreives the GUI handles structure
handles = guidata(hObject);

%Set model and equation text
seam_strings(handles.model2, handles.equation2);

% Sets labels for the input boxes
set_java_component(handles.label1_2, '[A] total ');
set_java_component(handles.label2_2, [KAS, ' ']);
set_java_component(handles.label3_2, [KAL, ' ']);
set_java_component(handles.units3_2, [UM, ' ']);
set_java_component(handles.label4_2, '1 MT : ');
set_java_component(handles.units4_2, 'A');

% Sets the default ratio to 1
set(handles.input4_2, 'String', '1');

% Updates the handles structure
guidata(hObject, handles);

end



function seam_saturation_labels2(hObject)
% Function to update the appearence of MTBindingSim for the case where the
% first function is seam and lattice binding in saturation mode

global KAS KAL UM;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 4);

% Retreives the GUI handles structure
handles = guidata(hObject);

%Set model and equation text
seam_strings(handles.model2, handles.equation2);

% Sets labels for the input boxes
set_java_component(handles.label1_2, '[MT] total ');
set_java_component(handles.label2_2, [KAS, ' ']);
set_java_component(handles.label3_2, [KAL, ' ']);
set_java_component(handles.units3_2, [UM, ' ']);
set_java_component(handles.label4_2, '1 MT : ');
set_java_component(handles.units4_2, 'A');

% Sets the default ratio to 1
set(handles.input4_2, 'String', '1');

% Updates the handles structure
guidata(hObject, handles);

end

function MAP_binding_labels2(hObject)
%Function to update the appearance of MTBindingSim for the case where the
%first function is MAPs bind to MT-bound MAPs model in binding mode

global KAM KAA UM;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 4);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets model equation and text
MAP_strings(handles.model2, handles.equation2);

% Sets labels for the input boxes
set_java_component(handles.label1_2, '[A] total ');
set_java_component(handles.label2_2, [KAM, ' ']);
set_java_component(handles.label3_2, [KAA, ' ']);
set_java_component(handles.units3_2, [UM, ' ']);
set_java_component(handles.label4_2, '1 MT : ');
set_java_component(handles.units4_2, 'A');

% Sets the default ratio to 1
set(handles.input4_2, 'String', '1');

% Updates the handles structure
guidata(hObject, handles);

end
               
function MAP_saturation_labels2(hObject)
%Function to update the appearance of MTBindingSim for the case where the
%first function is MAPs bind to MT-bound MAPs model in saturation mode

global KAM KAA UM;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 4);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets model equation and text
MAP_strings(handles.model2, handles.equation2);

% Sets labels for the input boxes
set_java_component(handles.label1_2, '[MT] total ');
set_java_component(handles.label2_2, [KAM, ' ']);
set_java_component(handles.label3_2, [KAA, ' ']);
set_java_component(handles.units3_2, [UM, ' ']);
set_java_component(handles.label4_2, '1 MT : ');
set_java_component(handles.units4_2, 'A');

% Sets the default ratio to 1
set(handles.input4_2, 'String', '1');

% Updates the handles structure
guidata(hObject, handles);

end

function MAP2_binding_labels2(hObject)
%Function to update the appearance of MTBindingSim for the case where the
%first function is 2 MAPs bind to MT-bound MAPs model in binding mode

global KAM KAA UM;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 4);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets model equation and text
MAP2_strings(handles.model2, handles.equation2);

% Sets labels for the input boxes
set_java_component(handles.label1_2, '[A] total ');
set_java_component(handles.label2_2, [KAM, ' ']);
set_java_component(handles.label3_2, [KAA, ' ']);
set_java_component(handles.units3_2, [UM, ' ']);
set_java_component(handles.label4_2, '1 MT : ');
set_java_component(handles.units4_2, 'A');

% Sets the default ratio to 1
set(handles.input4_2, 'String', '1');

% Updates the handles structure
guidata(hObject, handles);

end


                
function MAP2_saturation_labels2(hObject)
%Function to update the appearance of MTBindingSim for the case where the
%first function is 2 MAPs bind to MT-bound MAPs model in saturation mode

global KAM KAA UM;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 4);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets model equation and text
MAP2_strings(handles.model2, handles.equation2);

% Sets labels for the input boxes
set_java_component(handles.label1_2, '[MT] total ');
set_java_component(handles.label2_2, [KAM, ' ']);
set_java_component(handles.label3_2, [KAA, ' ']);
set_java_component(handles.units3_2, [UM, ' ']);
set_java_component(handles.label4_2, '1 MT : ');
set_java_component(handles.units4_2, 'A');

% Sets the default ratio to 1
set(handles.input4_2, 'String', '1');

% Updates the handles structure
guidata(hObject, handles);

end

function dimer_binding_labels2(hObject)
% Function to update the appearnce of MTBindinSim for the case where the
% second function is dimerization in binding mode

global KAA KAM KAAM UM;

% Sets the visibility for all imput boxes
inputboxes_display2(hObject, 5);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the model equation and text
dimer_strings(handles.model2, handles.equation2);

% Sets labels for the input boxes
set_java_component(handles.label1_2, '[A] total ');
set_java_component(handles.label2_2, [KAM, ' ']);
set_java_component(handles.label3_2, [KAAM, ' ']);
set_java_component(handles.units3_2, [UM, ' ']);
set_java_component(handles.label4_2, [KAA, ' ']);
set_java_component(handles.units4_2, [UM, ' ']);
set_java_component(handles.label5_2, '1 MT : ');
set_java_component(handles.units5_2, 'A');

% Sets the default ratio to 1
set(handles.input5_2, 'String', '1');

% Updates the handles structure
guidata(hObject, handles);

end

function dimer_saturation_labels2(hObject)
% Function to update the appearnce of MTBindinSim for the case where the
% first function is dimerization in saturation mode

global KAA KAM KAAM UM;

% Sets the visibility for all imput boxes
inputboxes_display2(hObject, 5);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the model equation and text
dimer_strings(handles.model2, handles.equation2);

% Sets labels for the input boxes
set_java_component(handles.label1_2, '[MT] total ');
set_java_component(handles.label2_2, [KAM, ' ']);
set_java_component(handles.label3_2, [KAAM, ' ']);
set_java_component(handles.units3_2, [UM, ' ']);
set_java_component(handles.label4_2, [KAA, ' ']);
set_java_component(handles.units4_2, [UM, ' ']);
set_java_component(handles.label5_2, '1 MT : ');
set_java_component(handles.units5_2, 'A');

% Sets the default ratio to 1
set(handles.input5_2, 'String', '1');

% Updates the handles structure
guidata(hObject, handles);

end



function competition_labels2(hObject)
% Function to update the appearnce of MTBindingSIm for the case where
% the competition experimental mode is selected

global KAM KBM UM;

% Sets the visibility for all imput boxes
inputboxes_display2(hObject, 4);

handles = guidata(hObject);

% Sets the equation and model text
competition_strings(handles.model2, handles.equation2);

% Sets the labels for the visible imput boxes
set_java_component(handles.label1_2, '[MT] total ');
set_java_component(handles.label2_2, '[A] total ');
set_java_component(handles.label3_2, [KAM, ' ']);
set_java_component(handles.label4_2, [KBM, ' ']);
set_java_component(handles.units3_2, [UM, ' ']);
set_java_component(handles.units4_2, [UM, ' ']);

% Updates the handles structure
guidata(hObject, handles);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%    Functions to set input box visibility %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function inputboxes_display1(hObject, num)
% Sets the visibility of the input boxes for the first curve
% num is the number of visible boxes you would like to have

handles = guidata(hObject);

if num >= 1
    set(handles.label1_1, 'Visible', 'on');
    set(handles.input1_1, 'Visible', 'on');
    set(handles.input1_1, 'String', '0');
    set(handles.units1_1, 'Visible', 'on');
else
    set(handles.label1_1, 'Visible', 'off');
    set(handles.input1_1, 'Visible', 'off');
    set(handles.units1_1, 'Visible', 'off');
end

if num >= 2
    set(handles.label2_1, 'Visible', 'on');
    set(handles.input2_1, 'Visible', 'on');
    set(handles.input2_1, 'String', '0');
    set(handles.units2_1, 'Visible', 'on');
else
    set(handles.label2_1, 'Visible', 'off');
    set(handles.input2_1, 'Visible', 'off');
    set(handles.units2_1, 'Visible', 'off');
end

if num >= 3
    set(handles.label3_1, 'Visible', 'on');
    set(handles.input3_1, 'Visible', 'on');
    set(handles.input3_1, 'String', '0');
    set(handles.units3_1, 'Visible', 'on');
else
    set(handles.label3_1, 'Visible', 'off');
    set(handles.input3_1, 'Visible', 'off');
    set(handles.units3_1, 'Visible', 'off');
end

if num >= 4
    set(handles.label4_1, 'Visible', 'on');
    set(handles.input4_1, 'Visible', 'on');
    set(handles.input4_1, 'String', '0');
    set(handles.units4_1, 'Visible', 'on');
else
    set(handles.label4_1, 'Visible', 'off');
    set(handles.input4_1, 'Visible', 'off');
    set(handles.units4_1, 'Visible', 'off');
end

if num >= 5
    set(handles.label5_1, 'Visible', 'on');
    set(handles.input5_1, 'Visible', 'on');
    set(handles.input5_1, 'String', '0');
    set(handles.units5_1, 'Visible', 'on');
else
    set(handles.label5_1, 'Visible', 'off');
    set(handles.input5_1, 'Visible', 'off');
    set(handles.units5_1, 'Visible', 'off');
end

if num >= 6
    set(handles.label6_1, 'Visible', 'on');
    set(handles.input6_1, 'Visible', 'on');
    set(handles.input6_1, 'String', '0');
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
    set(handles.input1_2, 'String', '0');
    set(handles.units1_2, 'Visible', 'on');
else
    set(handles.label1_2, 'Visible', 'off');
    set(handles.input1_2, 'Visible', 'off');
    set(handles.units1_2, 'Visible', 'off');
end

if num >= 2
    set(handles.label2_2, 'Visible', 'on');
    set(handles.input2_2, 'Visible', 'on');
    set(handles.input2_2, 'String', '0');
    set(handles.units2_2, 'Visible', 'on');
else
    set(handles.label2_2, 'Visible', 'off');
    set(handles.input2_2, 'Visible', 'off');
    set(handles.units2_2, 'Visible', 'off');
end

if num >= 3
    set(handles.label3_2, 'Visible', 'on');
    set(handles.input3_2, 'Visible', 'on');
    set(handles.input3_2, 'String', '0');
    set(handles.units3_2, 'Visible', 'on');
else
    set(handles.label3_2, 'Visible', 'off');
    set(handles.input3_2, 'Visible', 'off');
    set(handles.units3_2, 'Visible', 'off');
end

if num >= 4
    set(handles.label4_2, 'Visible', 'on');
    set(handles.input4_2, 'Visible', 'on');
    set(handles.input4_2, 'String', '0');
    set(handles.units4_2, 'Visible', 'on');
else
    set(handles.label4_2, 'Visible', 'off');
    set(handles.input4_2, 'Visible', 'off');
    set(handles.units4_2, 'Visible', 'off');
end

if num >= 5
    set(handles.label5_2, 'Visible', 'on');
    set(handles.input5_2, 'Visible', 'on');
    set(handles.input5_2, 'String', '0');
    set(handles.units5_2, 'Visible', 'on');
else
    set(handles.label5_2, 'Visible', 'off');
    set(handles.input5_2, 'Visible', 'off');
    set(handles.units5_2, 'Visible', 'off');
end

if num >= 6
    set(handles.label6_2, 'Visible', 'on');
    set(handles.input6_2, 'Visible', 'on');
    set(handles.input6_2, 'String', '0');
    set(handles.units6_2, 'Visible', 'on');
else
    set(handles.label6_2, 'Visible', 'off');
    set(handles.input6_2, 'Visible', 'off');
    set(handles.units6_2, 'Visible', 'off');
end

% Updates the handles structure
guidata(hObject, handles);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%          Utility Functions           %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 


function disableButtons(hObject)

% Gets the guidata
handles = guidata(hObject);

% Change the mouse cursor to an hourglass
set(handles.mainfigure, 'Pointer', 'watch');

% Disable all the buttons so they cannot be pressed
set(handles.graph,'Enable','off');
set(handles.clear,'Enable','off');
set(handles.save, 'Enable', 'off');
set(handles.curve1,'Enable','off');
set(handles.curve2, 'Enable', 'off');
set(handles.binding, 'Enable', 'off');
set(handles.saturation, 'Enable', 'off');
set(handles.competition, 'Enable', 'off');
set(handles.single, 'Enable', 'off');
set(handles.compare, 'Enable', 'off');
set(handles.total, 'Enable', 'off');
set(handles.free, 'Enable', 'off');

% Updates the handles structure
guidata(hObject, handles);

% Redraws the GUI
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
set(handles.save, 'Enable', 'on');
set(handles.curve1,'Enable','on');
set(handles.curve2, 'Enable', 'on');
set(handles.binding, 'Enable', 'on');
set(handles.saturation, 'Enable', 'on');
set(handles.competition, 'Enable', 'on');
set(handles.single, 'Enable', 'on');
set(handles.compare, 'Enable', 'on');
set(handles.total, 'Enable', 'on');
set(handles.free, 'Enable', 'on');

% Updates the handles structure
guidata(hObject, handles);

% Redraws the GUI
drawnow;

end

function figureopen(hObject)

% Gets the guidata
handles = guidata(hObject);

% Enables the save button
set(handles.save, 'Enable', 'on');

% Changes the text of the graph button
set(handles.graph, 'String', 'Add to Graph');

% Updates the handles structure
guidata(hObject, handles);

% Redraws the GUI
drawnow;

end

function figureclose(hObject)

% Gets the guidata
handles = guidata(hObject);

% Disables the save button
set(handles.save, 'Enable', 'off');

% Changes the text of the graph button
set(handles.graph, 'String', 'Graph Curve');

%Updates the handles structure
guidata(hObject, handles);

% Redraws the GUI
drawnow;

end

function errorbox(message, hObject)

% Creates an error box and enables the buttons

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
