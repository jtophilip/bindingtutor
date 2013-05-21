function varargout = MTBindingSim(varargin)
% MTBindingSim - BindingTutor - an educational tool for teaching students
% about protein binding
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
%   BindingTutpr is a program to plot binding curves under various
%   conditions
% 
% See also: GUIDE, GUIDATA, GUIHANDLES

% This file is part of BindingTutor. BindingTutor is a version of
% MTBindingSim which has been modified to be useful for teaching. The
% variable names in the m files have been retained from MTBindingSim (using
% MT and A as the two main components), but the user interface variablees
% have been modified to P and L, as commonly used in binding instruction.
%
% Copyright (C) 2010-2013  University of Notre Dame
%
% BiningTutor is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% BindingTutor is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with BindingTutor.  If not, see <http://www.gnu.org/licenses/>.

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

% Set the window title
set(hObject, 'Name', 'BindingTutor');

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
global UM KD KD1 KD2 KD3 KD4 KDP KDB;
UM = '&#956;M';
KD = 'K<sub><small>D</small></sub>';
KD1 = 'K<sub><small>D1</small></sub>';
KD2 = 'K<sub><small>D2</small></sub>';
KD3 = 'K<sub><small>D3</small></sub>';
KD4 = 'K<sub><small>D4</small></sub>';
KDP = 'K<sub><small>DP</small></sub>';
KDB = 'K<sub><small>DB</small></sub>';


% More global string values for curve explanation boxes
global firstorder sites concerted coop2 coop4;
firstorder = {'Simple P binds L binding interaction.';'This model is valid for any simple protein-protein or protein-ligand interaction.'};
sites = {'P can bind to two sites on each L.';'This model is valid for any protein-protein or protein-ligand interaction with two independent binding sites.'};
concerted = {'P binds n Ls simultaneously.'};
coop2 = {'P binds to 2 Ls, with different affinities for the first and second L.'};
coop4 = {'P binds to 4 Ls, with different affinities for the first, second, thrid, and fourth L.'};

% Convert a bunch of our controls to java controls
handles.units_xmin = make_java_component(handles.units_xmin, UM, 0);
handles.units_xmax = make_java_component(handles.units_xmax, UM, 0);
handles.model1 = make_java_component(handles.model1, '', 1);
handles.equation1 = make_java_component(handles.equation1, '', 1);
handles.model2 = make_java_component(handles.model2, '', 1);
handles.equation2 = make_java_component(handles.equation2, '', 1);
first_order_strings(handles.model1, handles.equation1);
first_order_strings(handles.model2, handles.equation2);
handles.label1_1 = make_java_component(handles.label1_1, '[P] total ', 2);
handles.label2_1 = make_java_component(handles.label2_1, [KD, ' '], 2);
handles.label3_1 = make_java_component(handles.label3_1, '', 2);
handles.label4_1 = make_java_component(handles.label4_1, '', 2);
handles.label5_1 = make_java_component(handles.label5_1, '', 2);
handles.label6_1 = make_java_component(handles.label6_1, '', 2);
handles.label1_2 = make_java_component(handles.label1_2, '[P] total ', 2);
handles.label2_2 = make_java_component(handles.label2_2, [KD, ' '], 2);
handles.label3_2 = make_java_component(handles.label3_2, '', 2);
handles.label4_2 = make_java_component(handles.label4_2, '', 2);
handles.label5_2 = make_java_component(handles.label5_2, '', 2);
handles.label6_2 = make_java_component(handles.label6_2, '', 2);
handles.units1_1 = make_java_component(handles.units1_1, UM, 0);
handles.units2_1 = make_java_component(handles.units2_1, UM, 0);
handles.units3_1 = make_java_component(handles.units3_1, UM, 0);
handles.units4_1 = make_java_component(handles.units4_1, UM, 0);
handles.units5_1 = make_java_component(handles.units5_1, UM, 0);
handles.units6_1 = make_java_component(handles.units6_1, UM, 0);
handles.units1_2 = make_java_component(handles.units1_2, UM, 0);
handles.units2_2 = make_java_component(handles.units2_2, UM, 0);
handles.units3_2 = make_java_component(handles.units3_2, UM, 0);
handles.units4_2 = make_java_component(handles.units4_2, UM, 0);
handles.units5_2 = make_java_component(handles.units5_2, UM, 0);
handles.units6_2 = make_java_component(handles.units6_2, UM, 0);

% Prettify the info buttons
set(handles.info1, 'String', '');
set(handles.info2, 'String', '');

set(handles.info1, 'Units', 'pixels');
set(handles.info2, 'Units', 'pixels');

% Set the button sizes
info1_pos = get(handles.info1, 'Position');
info1_pos(3) = 28;
info1_pos(4) = 28;
set(handles.info1, 'Position', info1_pos);

info2_pos = get(handles.info2, 'Position');
info2_pos(3) = 28;
info2_pos(4) = 28;
set(handles.info2, 'Position', info2_pos);

% Get 28x28 images of the background behind both of the buttons
frame = getframe(hObject, info1_pos);
info1_base_cdata = frame.cdata;

frame = getframe(hObject, info2_pos);
info2_base_cdata = frame.cdata;

% Load the 22x22 icon data
info_filename = fullfile(matlabroot, '/toolbox/matlab/icons/csh_icon.png');
[cdata, map, alpha] = imread(info_filename, 'png');
x_alpha = blkdiag(zeros(3,3), alpha, zeros(3,3));

% Mix in base * ~alpha + icon * alpha
r = cdata(:,:,1);
r(alpha == 0) = 0;
r = blkdiag(zeros(3,3), r, zeros(3,3));

base_r = info1_base_cdata(:,:,1);
base_r(x_alpha ~= 0) = 0;

g = cdata(:,:,2);
g(alpha == 0) = 0;
g = blkdiag(zeros(3,3), g, zeros(3,3));

base_g = info1_base_cdata(:,:,2);
base_g(x_alpha ~= 0) = 0;

b = cdata(:,:,3);
b(alpha == 0) = 0;
b = blkdiag(zeros(3,3), b, zeros(3,3));

base_b = info1_base_cdata(:,:,3);
base_b(x_alpha ~= 0) = 0;

info1_cdata = cat(3, r + base_r, g + base_g, b + base_b);

r = cdata(:,:,1);
r(alpha == 0) = 0;
r = blkdiag(zeros(3,3), r, zeros(3,3));

base_r = info2_base_cdata(:,:,1);
base_r(x_alpha ~= 0) = 0;

g = cdata(:,:,2);
g(alpha == 0) = NaN;
g = blkdiag(zeros(3,3), g, zeros(3,3));

base_g = info2_base_cdata(:,:,2);
base_g(x_alpha ~= 0) = 0;

b = cdata(:,:,3);
b(alpha == 0) = 0;
b = blkdiag(zeros(3,3), b, zeros(3,3));

base_b = info2_base_cdata(:,:,3);
base_b(x_alpha ~= 0) = 0;

info2_cdata = cat(3, r + base_r, g + base_g, b + base_b);

% Set the images, etc.
set(handles.info1, 'CData', info1_cdata);
set(handles.info2, 'CData', info2_cdata);
set(handles.info1, 'TooltipString', 'Display model information');
set(handles.info2, 'TooltipString', 'Display model information');

set(handles.info2, 'Visible', 'Off');

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
        errorbox('Please enter a positive number for [L] total', hObject);
        return
    end
    
    % Gets the value for Atot and make sure it's a positive number
    Atot = str2double(get(handles.input2_1, 'String'));
    
    if isnan(Atot) || Atot <= 0
        errorbox('Please enter a positive number for [P] total', hObject);
        return
    end
    
    % Gets the value for KAM and make sure it's a positive number
    KAM = str2double(get(handles.input3_1, 'String'));
    
    if isnan(KAM) || KAM <= 0
        errorbox('Please enter a positive number for K_DP', hObject);
        return
    end
    
    % Gets the value for KBM and makes sure it's a positive number
    KBM = str2double(get(handles.input4_1, 'String'));
    
    if isnan(KBM) || KBM <= 0
        errorbox('Please enter a positive number for K_DB', hObject);
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
    yaxis = 'Fraction of P bound';
    plottitle = 'Competition Binding Assay';
    legend1 = ['[L] total = ' get(handles.input1_1, 'String') ', [P] total = ' get(handles.input2_1, 'String') ', K_{DP} = ' get(handles.input3_1, 'String') ', K_{DB} = ' get(handles.input4_1, 'String') ];


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
                errorbox('Please enter a positive number for [P] total', hObject); 
                return
            end

            % Gets the value for KAM and ensures that it's a
            % positive number
            KAM = str2double(get(handles.input2_1, 'String'));

            if isnan(KAM) || KAM <= 0
                errorbox('K_D must be a number greater than 0', hObject); 
                return
            end


            % Determines whether the X-axis is free MT or free MT
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'

                   %Calculates the value of frac, MTfree, and Abound
                   [frac, MTfree] = first_order_binding(xvals, Atot, KAM, 1);
                   
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
                   xaxis = '[L] free';
                   yaxis = 'Fraction of P bound';
                   plottitle = 'Vary [L] Binding Assay';
                   legend1 = ['First order, [P] total = ' get(handles.input1_1, 'String') ', K_{D} = ' get(handles.input2_1, 'String')];

                case 'total'

                   % Calculates the value of frac and MTfree
                   [frac, MTfree] = first_order_binding(xvals, Atot, KAM, 1);
                   
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
                   xaxis = '[L] total';
                   yaxis = 'Fraction of P bound';
                   plottitle = 'Vary [L] Binding Assay';
                   legend1 = ['First order, [P] total = ' get(handles.input1_1, 'String') ', K_{D} = ' get(handles.input2_1, 'String')];

                otherwise
            end

        % Saturation mode is selected
        case 'saturation'

            % Gets the value for [MT] free and ensures that it's a
            % positive number
            MTtot = str2double(get(handles.input1_1, 'String'));

            if isnan(MTtot) || MTtot <= 0
                errorbox('Please enter a positive number for [L] total', hObject); 
                return
            end

            % Gets the value for KAM and ensures that it's a
            % positive number
            KAM = str2double(get(handles.input2_1, 'String'));

            if isnan(KAM) || KAM <= 0
                errorbox('K_D must be a number greater than 0', hObject); 
                return
            end
            
            
            % Determines whether free or free [A] should be graphed
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'
                    
                    % Calculates Abound, and Afree
                    [Abound, Afree] = first_order_saturation(MTtot, xvals, KAM, 1);
                    
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
                    xaxis = '[P] free';
                    yaxis = '[P] bound';
                    plottitle = 'Vary [P] Binding Assay';
                    legend1 = ['First order, [L] total = ' get(handles.input1_1, 'String') ', K_{D} = ' get(handles.input2_1, 'String')];

                    
                case 'total'
                
                    % Calculates Abound and Afree
                    [Abound, Afree] = first_order_saturation(MTtot, xvals, KAM, 1);
                    
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
                    xaxis = '[P] total';
                    yaxis = '[P] bound';
                    plottitle = 'Vary [P] Binding Assay';
                    legend1 = ['First order, [L] total = ' get(handles.input1_1, 'String') ', K_{D} = ' get(handles.input2_1, 'String')];
                    
                case 'scatchard'
                    
                    % Calculates Abound and Afree
                    [Abound, Afree] = first_order_saturation(MTtot, xvals, KAM, 1);
                    
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
                    xaxis = '[P] bound';
                    yaxis = '[P] bound/ [P] free';
                    plottitle = 'Vary [P] Binding Assay';
                    legend1 = ['First order, [L] total = ' get(handles.input1_1, 'String') ', K_{D} = ' get(handles.input2_1, 'String')];
                    

                    
                otherwise
            end

        otherwise
    end

elseif strcmpi(handles.mode1, 'sites')
    
    %%% Two site binding %%%
    
    % Determine the experimental mode
    switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
        % Binding mode is selected
        case 'binding'

            % Gets the value for [A] free and ensures that it's a
            % positive number
            Atot = str2double(get(handles.input1_1, 'String'));

            if isnan(Atot) || Atot <= 0
                errorbox('Please enter a positive number for [P] total', hObject); 
                return
            end

            % Gets the value for KAS and ensures that it's a
            % positive number
            KA1 = str2double(get(handles.input2_1, 'String'));

            if isnan(KA1) || KA1 <= 0
                errorbox('K_D1 must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for KAL and ensures that it's a positive
            % number
            KA2 = str2double(get(handles.input3_1, 'String'));

            if isnan(KA2) || KA2 <= 0
                errorbox('K_D2 must be a number greater than 0', hObject); 
                return
            end
            

            % Determines whether the X-axis is free MT or free MT
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'

                    errorbox('The two sites model cannot be graphed with an X-axis of [MT] free',hObject);
                 
                case 'total'

                    % Calculates fraction of A bound and MT free
                    [frac] = sites_binding(xvals, Atot, KA1, KA2);
                    
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
                    xaxis = '[L] total';
                    yaxis = 'Fraction of P bound';
                    plottitle = 'Vary [L] Binding Assay';
                    legend1 = ['Two sites, [P] total = ' get(handles.input1_1, 'String') ', K_{D1} = ' get(handles.input2_1, 'String') ', K_{D2} = ' get(handles.input3_1, 'String')];

                otherwise
            end

        % Saturation mode is selected
        case 'saturation'

            % Gets the value for [MT] free and ensures that it's a
            % positive number
            MTtot = str2double(get(handles.input1_1, 'String'));

            if isnan(MTtot) || MTtot <= 0
                errorbox('Please enter a positive number for [L] total', hObject); 
                return
            end

            % Gets the value for KAS and ensures that it's a
            % positive number
            KA1 = str2double(get(handles.input2_1, 'String'));

            if isnan(KA1) || KA1 <= 0
                errorbox('K_D1 must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for KAL and ensures that it's a positive
            % number
            KA2 = str2double(get(handles.input3_1, 'String'));

            if isnan(KA2) || KA2 <= 0
                errorbox('K_D2 must be a number greater than 0', hObject); 
                return
            end
                        
            % Determines whether the the x-axis is free or free
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                
                case 'free'
                    
                    % Calculates concentration of Abound and A free
                    [Abound, Afree] = sites_saturation(MTtot, xvals, KA1, KA2);
                    
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
                    xaxis = '[P] free';
                    yaxis = '[P] bound';
                    plottitle = 'Vary [P] Binding Assay';
                    legend1 = ['Two sites, [L] total = ' get(handles.input1_1, 'String') ', K_{D1} = ' get(handles.input2_1, 'String') ', K_{D2} = ' get(handles.input3_1, 'String')];


                case 'total'
                    
                    % Calculates concentration of A bound and MT free
                    [Abound, Afree] = sites_saturation(MTtot, xvals, KA1, KA2);
                    
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
                    xaxis = '[P] total';
                    yaxis = '[P] bound';
                    plottitle = 'Vary [P] Binding Assay';
                    legend1 = ['Two sites, [L] total = ' get(handles.input1_1, 'String') ', K_{D1} = ' get(handles.input2_1, 'String') ', K_{D2} = ' get(handles.input3_1, 'String')];
   
                case 'scatchard'
                    
                    % Calculates concentration of A bound and MT free
                    [Abound, Afree] = sites_saturation(MTtot, xvals, KA1, KA2);
                    
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
                    xaxis = '[P] bound';
                    yaxis = '[P] bound/[P] free';
                    plottitle = 'Vary [P] Binding Assay';
                    legend1 = ['Two sites, [L] total = ' get(handles.input1_1, 'String') ', K_{D1} = ' get(handles.input2_1, 'String') ', K_{D2} = ' get(handles.input3_1, 'String')];
                
                
                otherwise
            end

            
        otherwise
    end


elseif strcmpi(handles.mode1, 'concerted')
    
    %%% Concerted Cooperativity %%%
    
    % Determine the experimental mode
    switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
        % Binding mode is selected
        case 'binding'

            % Gets the value for [A] free and ensures that it's a
            % positive number
            Atot = str2double(get(handles.input1_1, 'String'));

            if isnan(Atot) || Atot <= 0
                errorbox('Please enter a positive number for [P] total', hObject); 
                return
            end

            % Gets the value for KD and ensures that it's a
            % positive number
            KD= str2double(get(handles.input2_1, 'String'));

            if isnan(KD) || KD <= 0
                errorbox('K_D must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for n and ensures that it's a
            % positive number
            n = str2double(get(handles.input3_1, 'String'));

            if isnan(n) || n <= 0
                errorbox('n must be a number greater than 0', hObject); 
                return
            end

            % Determines whether the X-axis is free MT or free MT
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'

                   %Calculates the value of frac, MTfree, and Abound
                   [frac, MTfree] = coop_concerted_binding(xvals, Atot, KD, n);
                   
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
                   xaxis = '[L] free';
                   yaxis = 'Fraction of P bound';
                   plottitle = 'Vary [L] Binding Assay';
                   legend1 = ['Concerted cooperativity, [P] total = ' get(handles.input1_1, 'String') ', K_{D} = ' get(handles.input2_1, 'String') ', n = ' get(handles.input3_1, 'String')];

                case 'total'

                   % Calculates the value of frac and MTfree
                   [frac, MTfree] = coop_concerted_binding(xvals, Atot, KD, n);
                   
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
                   xaxis = '[L] total';
                   yaxis = 'Fraction of P bound';
                   plottitle = 'Vary [L] Binding Assay';
                   legend1 = ['Concerted cooperativity, [P] total = ' get(handles.input1_1, 'String') ', K_{D} = ' get(handles.input2_1, 'String') ', n = ' get(handles.input3_1, 'String')];

                otherwise
            end

        % Saturation mode is selected
        case 'saturation'

            % Gets the value for [MT] free and ensures that it's a
            % positive number
            MTtot = str2double(get(handles.input1_1, 'String'));

            if isnan(MTtot) || MTtot <= 0
                errorbox('Please enter a positive number for [L] total', hObject); 
                return
            end

            % Gets the value for KD and ensures that it's a
            % positive number
            KD = str2double(get(handles.input2_1, 'String'));

            if isnan(KD) || KD <= 0
                errorbox('K_D must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the value for n and ensures that it's a
            % positive number
            n = str2double(get(handles.input3_1, 'String'));

            if isnan(n) || n <= 0
                errorbox('n must be a number greater than 0', hObject); 
                return
            end
            
            
            % Determines whether free or free [A] should be graphed
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'
                    
                    % Calculates Abound, and Afree
                    [Abound, Afree] = coop_concerted_saturation(MTtot, xvals, KD, n);
                    
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
                    xaxis = '[P] free';
                    yaxis = '[P] bound';
                    plottitle = 'Vary [P] Binding Assay';
                    legend1 = ['Concerted cooperativity, [L] total = ' get(handles.input1_1, 'String') ', K_{D} = ' get(handles.input2_1, 'String') ', n = ' get(handles.input3_1, 'String')];

                    
                case 'total'
                
                    % Calculates Abound and Afree
                    [Abound, Afree] = coop_concerted_saturation(MTtot, xvals, KD, n);
                    
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
                    xaxis = '[P] total';
                    yaxis = '[P] bound';
                    plottitle = 'Vary [P] Binding Assay';
                    legend1 = ['Concerted cooperativity, [L] total = ' get(handles.input1_1, 'String') ', K_{D} = ' get(handles.input2_1, 'String') ', n = ' get(handles.input3_1, 'String')];
                    
                case 'scatchard'
                    
                    % Calculates Abound and Afree
                    [Abound, Afree] = coop_concerted_saturation(MTtot, xvals, KD, n);
                    
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
                    xaxis = '[P] bound';
                    yaxis = '[P] bound/ [P] free';
                    plottitle = 'Vary [P] Binding Assay';
                    legend1 = ['Concerted cooperativity, [L] total = ' get(handles.input1_1, 'String') ', K_{D} = ' get(handles.input2_1, 'String') ', n = ' get(handles.input3_1, 'String')];
                    

                    
                otherwise
            end

        otherwise
    end

elseif strcmpi(handles.mode1, 'coop2')
    
    %%% 2 Site sequential cooperativity %%%
    
    % Determine the experimental mode
    switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
        % Binding mode is selected
        case 'binding'

            % Gets the value for [A] free and ensures that it's a
            % positive number
            Atot = str2double(get(handles.input1_1, 'String'));

            if isnan(Atot) || Atot <= 0
                errorbox('Please enter a positive number for [P] total', hObject); 
                return
            end

            % Gets the value for KD1 and ensures that it's a
            % positive number
            KD1= str2double(get(handles.input2_1, 'String'));

            if isnan(KD1) || KD1 <= 0
                errorbox('K_{D1} must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for KD2 and ensures that it's a
            % positive number
            KD2 = str2double(get(handles.input3_1, 'String'));

            if isnan(KD2) || KD2 <= 0
                errorbox('K_{D2} must be a number greater than 0', hObject); 
                return
            end

            % Determines whether the X-axis is free MT or free MT
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'

                   %Calculates the value of frac, MTfree, and Abound
                   [frac, MTfree] = coop2_binding(xvals, Atot, KD1, KD2);
                   
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
                   xaxis = '[L] free';
                   yaxis = 'Fraction of P bound';
                   plottitle = 'Vary [L] Binding Assay';
                   legend1 = ['2 site sequential cooperativity, [P] total = ' get(handles.input1_1, 'String') ', K_{D1} = ' get(handles.input2_1, 'String') ', K_{D2} = ' get(handles.input3_1, 'String')];

                case 'total'

                   % Calculates the value of frac and MTfree
                   [frac, MTfree] = coop2_binding(xvals, Atot, KD1, KD2);
                   
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
                   xaxis = '[L] total';
                   yaxis = 'Fraction of P bound';
                   plottitle = 'Vary [L] Binding Assay';
                   legend1 = ['2 site sequential cooperativity, [P] total = ' get(handles.input1_1, 'String') ', K_{D1} = ' get(handles.input2_1, 'String') ', K_{D2} = ' get(handles.input3_1, 'String')];

                otherwise
            end

        % Saturation mode is selected
        case 'saturation'

            % Gets the value for [MT] free and ensures that it's a
            % positive number
            MTtot = str2double(get(handles.input1_1, 'String'));

            if isnan(MTtot) || MTtot <= 0
                errorbox('Please enter a positive number for [L] total', hObject); 
                return
            end

            % Gets the value for KD1 and ensures that it's a
            % positive number
            KD1 = str2double(get(handles.input2_1, 'String'));

            if isnan(KD1) || KD1 <= 0
                errorbox('K_{D1} must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the value for KD2 and ensures that it's a
            % positive number
            KD2 = str2double(get(handles.input3_1, 'String'));

            if isnan(KD2) || KD2 <= 0
                errorbox('K_{D2} must be a number greater than 0', hObject); 
                return
            end
            
            
            % Determines whether free or free [A] should be graphed
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'
                    
                    % Calculates Abound, and Afree
                    [Abound, Afree] = coop2_saturation(MTtot, xvals, KD1, KD2);
                    
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
                    xaxis = '[P] free';
                    yaxis = '[P] bound';
                    plottitle = 'Vary [P] Binding Assay';
                    legend1 = ['2 site sequential cooperativity, [L] total = ' get(handles.input1_1, 'String') ', K_{D1} = ' get(handles.input2_1, 'String') ', K_{D2} = ' get(handles.input3_1, 'String')];

                    
                case 'total'
                
                    % Calculates Abound and Afree
                    [Abound, Afree] = coop2_saturation(MTtot, xvals, KD1, KD2);
                    
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
                    xaxis = '[P] total';
                    yaxis = '[P] bound';
                    plottitle = 'Vary [P] Binding Assay';
                    legend1 = ['2 site sequential cooperativity, [L] total = ' get(handles.input1_1, 'String') ', K_{D1} = ' get(handles.input2_1, 'String') ', K_{D2} = ' get(handles.input3_1, 'String')];
                    
                case 'scatchard'
                    
                    % Calculates Abound and Afree
                    [Abound, Afree] = coop2_saturation(MTtot, xvals, KD1, KD2);
                    
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
                    xaxis = '[P] bound';
                    yaxis = '[P] bound/ [P] free';
                    plottitle = 'Vary [P] Binding Assay';
                    legend1 = ['2 site sequential cooperativity, [L] total = ' get(handles.input1_1, 'String') ', K_{D1} = ' get(handles.input2_1, 'String') ', K_{D2} = ' get(handles.input3_1, 'String')];
                    

                    
                otherwise
            end

        otherwise
    end

    elseif strcmpi(handles.mode1, 'coop4')
    
    %%% 4 site sequential cooperativity %%%
    
    % Determine the experimental mode
    switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
        % Binding mode is selected
        case 'binding'

            % Gets the value for [A] free and ensures that it's a
            % positive number
            Atot = str2double(get(handles.input1_1, 'String'));

            if isnan(Atot) || Atot <= 0
                errorbox('Please enter a positive number for [P] total', hObject); 
                return
            end

            % Gets the value for KD1 and ensures that it's a
            % positive number
            KD1 = str2double(get(handles.input2_1, 'String'));

            if isnan(KD1) || KD1 <= 0
                errorbox('K_{D1} must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for KD2 and ensures that it's a
            % positive number
            KD2 = str2double(get(handles.input3_1, 'String'));

            if isnan(KD2) || KD2 <= 0
                errorbox('K_{D2} must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the value for KD3 and ensures that it's a
            % positive number
            KD3 = str2double(get(handles.input4_1, 'String'));

            if isnan(KD3) || KD3 <= 0
                errorbox('K_{D3} must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the value for KD4 and ensures that it's a
            % positive number
            KD4 = str2double(get(handles.input5_1, 'String'));

            if isnan(KD4) || KD4 <= 0
                errorbox('K_{D4} must be a number greater than 0', hObject); 
                return
            end

            % Determines whether the X-axis is free MT or free MT
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'

                   %Calculates the value of frac, MTfree, and Abound
                   [frac, MTfree] = coop4_binding(xvals, Atot, KD1, KD2, KD3, KD4);
                   
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
                   xaxis = '[L] free';
                   yaxis = 'Fraction of P bound';
                   plottitle = 'Vary [L] Binding Assay';
                   legend1 = ['4 site sequential cooperativity, [P] total = ' get(handles.input1_1, 'String') ', K_{D1} = ' get(handles.input2_1, 'String') ', K_{D2} = ' get(handles.input3_1, 'String') ', K_{D3} = ' get(handles.input4_1, 'String') ', K_{D4} = ' get(handles.input5_1, 'String')];

                case 'total'

                   % Calculates the value of frac and MTfree
                   [frac, MTfree] = coop4_binding(xvals, Atot, KD1, KD2, KD3, KD4);
                   
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
                   xaxis = '[L] total';
                   yaxis = 'Fraction of P bound';
                   plottitle = 'Vary [L] Binding Assay';
                   legend1 = ['4 site sequential cooperativity, [P] total = ' get(handles.input1_1, 'String') ', K_{D} = ' get(handles.input2_1, 'String') ', K_{D2} = ' get(handles.input3_1, 'String') ', K_{D3} = ' get(handles.input4_1, 'String') ', K_{D4} = ' get(handles.input5_1, 'String')];

                otherwise
            end

        % Saturation mode is selected
        case 'saturation'

            % Gets the value for [MT] free and ensures that it's a
            % positive number
            MTtot = str2double(get(handles.input1_1, 'String'));

            if isnan(MTtot) || MTtot <= 0
                errorbox('Please enter a positive number for [L] total', hObject); 
                return
            end

            % Gets the value for KD1 and ensures that it's a
            % positive number
            KD1 = str2double(get(handles.input2_1, 'String'));

            if isnan(KD1) || KD1 <= 0
                errorbox('K_{D1} must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the value for KD2 and ensures that it's a
            % positive number
            KD2 = str2double(get(handles.input3_1, 'String'));

            if isnan(KD2) || KD2 <= 0
                errorbox('K_{D2} must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the value for KD3 and ensures that it's a
            % positive number
            KD3 = str2double(get(handles.input4_1, 'String'));

            if isnan(KD3) || KD3 <= 0
                errorbox('K_{D3} must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the value for KD4 and ensures that it's a
            % positive number
            KD4 = str2double(get(handles.input5_1, 'String'));

            if isnan(KD4) || KD4 <= 0
                errorbox('K_{D4} must be a number greater than 0', hObject); 
                return
            end
            
            % Determines whether free or free [A] should be graphed
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'
                    
                    % Calculates Abound, and Afree
                    [Abound, Afree] = coop4_saturation(MTtot, xvals, KD1, KD2, KD3, KD4);
                    
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
                    xaxis = '[P] free';
                    yaxis = '[P] bound';
                    plottitle = 'Vary [P] Binding Assay';
                    legend1 = ['4 site sequential cooperativity, [L] total = ' get(handles.input1_1, 'String') ', K_{D1} = ' get(handles.input2_1, 'String') ', K_{D2} = ' get(handles.input3_1, 'String') ', K_{D3} = ' get(handles.input4_1, 'String') ', K_{D4} = ' get(handles.input5_1, 'String')];

                    
                case 'total'
                
                    % Calculates Abound and Afree
                    [Abound, Afree] = coop4_saturation(MTtot, xvals, KD1, KD2, KD3, KD4);
                    
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
                    xaxis = '[P] total';
                    yaxis = '[P] bound';
                    plottitle = 'Vary [P] Binding Assay';
                    legend1 = ['4 site sequential cooperativity, [L] total = ' get(handles.input1_1, 'String') ', K_{D1} = ' get(handles.input2_1, 'String') ', K_{D2} = ' get(handles.input3_1, 'String') ', K_{D3} = ' get(handles.input4_1, 'String') ', K_{D4} = ' get(handles.input5_1, 'String')];
                    
                case 'scatchard'
                    
                    % Calculates Abound and Afree
                    [Abound, Afree] = coop4_saturation(MTtot, xvals, KD1, KD2, KD3, KD4);
                    
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
                    xaxis = '[P] bound';
                    yaxis = '[P] bound/ [P] free';
                    plottitle = 'Vary [P] Binding Assay';
                    legend1 = ['4 site sequential coopeativity, [L] total = ' get(handles.input1_1, 'String') ', K_{D1} = ' get(handles.input2_1, 'String') ', K_{D2} = ' get(handles.input3_1, 'String') ', K_{D3} = ' get(handles.input4_1, 'String') ', K_{D4} = ' get(handles.input5_1, 'String')];
                    

                    
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
          errorbox('Please enter a positive number for [L] total', hObject);
          return
      end
    
      % Gets the value of Atot and ensures it's a positivie number
    Atot = str2double(get(handles.input2_2, 'String'));
    
    if isnan(Atot) || Atot <= 0
        errorbox('Please enter a positive number for [P] total', hObject);
        return
    end
    
    % Gets the value of KAM and ensures it's a positive number
    KAM = str2double(get(handles.input3_2, 'String'));
    
    if isnan(KAM) || KAM <= 0
        errorbox('Please enter a positive number for K_DP', hObject);
        return
    end
    
    % Gets the value of KBM and ensures it's a positive number
    KBM = str2double(get(handles.input4_2, 'String'));
    
    if isnan(KBM) || KBM <= 0
        errorbox('Please enter a positive number for K_DB', hObject);
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
    legend2 = ['[L] total = ' get(handles.input1_2, 'String') ', [P] total = ' get(handles.input2_2, 'String') ', K_{DP} = ' get(handles.input3_2, 'String') ', K_{DB} = ' get(handles.input4_2, 'String')];

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
                    errorbox('Please enter a positive number for [P] total', hObject); 
                    return
                end

                % Gets the value for KAM and ensures that it's a
                % positive number
                KAM = str2double(get(handles.input2_2, 'String'));

                if isnan(KAM) || KAM <= 0
                    errorbox('K_D must be a number greater than 0', hObject); 
                    return
                end
                

                % Determines whether the X-axis is free B or free B
                switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                    case 'free'

                       % Function to get fraction A bound and free MT 
                       [frac, MTfree] = first_order_binding(xvals, Atot, KAM, 1);
                       
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
                       legend2 = ['First order, [P] total = ' get(handles.input1_2, 'String') ', K_{D} = ' get(handles.input2_2, 'String')];

                    case 'total'

                       % Function to get fraction A bound
                       [frac, MTfree] = first_order_binding(xvals, Atot, KAM, 1);
                       
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
                       legend2 = ['First order, [P] total = ' get(handles.input1_2, 'String') ', K_{D} = ' get(handles.input2_2, 'String')];

                    otherwise
                end

            % Saturation mode is selected
            case 'saturation'

                % Gets the value for [MT] free and ensures that it's a
                % positive number
                MTtot = str2double(get(handles.input1_2, 'String'));

                if isnan(MTtot) || MTtot <= 0
                    errorbox('Please enter a positive number for [L] total', hObject); 
                    return
                end

                % Gets the value for KAM and ensures that it's a
                % positive number
                KAM = str2double(get(handles.input2_2, 'String'));

                if isnan(KAM) || KAM <= 0
                    errorbox('K_D must be a number greater than 0', hObject); 
                    return
                end
                
                % Determines whether the x-axis is free or free A
                switch get(get(handles.tot_free, 'SelectedObject'), 'Tag')
                    case 'free'
                        
                        % Function to get the concentration of A bound
                        [Abound, Afree] = first_order_saturation(MTtot, xvals, KAM, 1);
                        
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
                        legend2 = ['First order, [L] total = ' get(handles.input1_2, 'String') ', K_{D} = ' get(handles.input2_2, 'String')];

                    case 'total'
                        
                        % Function to get the concentration of A bound
                        [Abound, Afree] = first_order_saturation(MTtot, xvals, KAM, 1);
                        
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
                        legend2 = ['First order, [L] total = ' get(handles.input1_2, 'String') ', K_{D} = ' get(handles.input2_2, 'String')];

                    case 'scatchard'
                        
                        % Function to get the concentration of A bound
                        [Abound, Afree] = first_order_saturation(MTtot, xvals, KAM, 1);
                        
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
                        legend2 = ['First order, [L] total = ' get(handles.input1_2, 'String') ', K_{D} = ' get(handles.input2_2, 'String')];

                    
                    otherwise
                end

                
            otherwise
        end

    elseif strcmpi(handles.mode2, 'sites')

            %%%% Two sites binding %%%%%

            % Determine the experimental mode
            switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
                % Binding mode is selected
                case 'binding'

                    % Gets the value for [A] free and ensures that it's a
                    % positive number
                    Atot = str2double(get(handles.input1_2, 'String'));

                    if isnan(Atot) || Atot <= 0
                        errorbox('Please enter a positive number for [P] total', hObject); 
                        return
                    end

                    % Gets the value for KAS and ensures that it's a
                    % positive number
                    KA1 = str2double(get(handles.input2_2, 'String'));

                    if isnan(KA1) || KA1 <= 0
                        errorbox('K_D1 must be a number greater than 0', hObject); 
                        return
                    end

                    % Gets the value for KAL and ensures that it's a positive
                    % number
                    KA2 = str2double(get(handles.input3_2, 'String'));

                    if isnan(KA2) || KA2 <= 0
                        errorbox('K_D2 must be a number greater than 0', hObject); 
                        return
                    end


                    % Determines whether the X-axis is free MT or free MT
                    switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                        case 'free'

                          errorbox('The two sites model cannot be graphed with an x-axis of [MT] free',hObject);
                            
                        case 'total'

                            % Function to get fraction A bound
                            [frac] = sites_binding(xvals, Atot, KA1, KA2);

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
                            legend2 = ['Two sites, [P] total = ' get(handles.input1_2, 'String') ', K_{D1} = ' get(handles.input2_2, 'String') ', K_{D2} = ' get(handles.input3_2, 'String')];

                        otherwise
                    end

                % Saturation mode is selected
                case 'saturation'

                    % Gets the value for [MT] free and ensures that it's a
                    % positive number
                    MTtot = str2double(get(handles.input1_2, 'String'));

                    if isnan(MTtot) || MTtot <= 0
                        errorbox('Please enter a positive number for [L] total', hObject); 
                        return
                    end

                    % Gets the value for KAS and ensures that it's a
                    % positive number
                    KA1 = str2double(get(handles.input2_2, 'String'));

                    if isnan(KA1) || KA1 <= 0
                        errorbox('K_D1 must be a number greater than 0', hObject); 
                        return
                    end

                    % Gets the value for KAL and ensures that it's a positive
                    % number
                    KA2 = str2double(get(handles.input3_2, 'String'));

                    if isnan(KA2) || KA2 <= 0
                        errorbox('K_D2 must be a number greater than 0', hObject); 
                        return
                    end


                    % Checks to see whether the x-axis is free or free A
                    switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                        case 'free'

                            % Function to get the concentration of A bound
                            [Abound, Afree] = sites_saturation(MTtot, xvals, KA1, KA2);

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
                            legend2 = ['Two sites, [L] total = ' get(handles.input1_2, 'String') ', K_{D1} = ' get(handles.input2_2, 'String') ', K_{D2} = ' get(handles.input3_2, 'String')];

                        case 'total'

                            % Function to get the concentration of A bound
                            [Abound, Afree] = sites_saturation(MTtot, xvals, KA1, KA2);

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
                            legend2 = ['Two sites, [L] total = ' get(handles.input1_2, 'String') ', K_{D1} = ' get(handles.input2_2, 'String') ', K_{D2} = ' get(handles.input3_2, 'String')];

                        case 'scatchard'

                            % Function to get the concentration of A bound
                            [Abound, Afree] = sites_saturation(MTtot, xvals, KA1, KA2);

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
                            legend2 = ['Two sites, [L] total = ' get(handles.input1_2, 'String') ', K_{D1} = ' get(handles.input2_2, 'String') ', K_{D2} = ' get(handles.input3_2, 'String')];


                        otherwise
                    end 
                otherwise
            end
            
    elseif strcmpi(handles.mode2, 'concerted')
    
    %%% Concerted Cooperativity %%%
    
    % Determine the experimental mode
    switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
        % Binding mode is selected
        case 'binding'

            % Gets the value for [A] free and ensures that it's a
            % positive number
            Atot = str2double(get(handles.input1_2, 'String'));

            if isnan(Atot) || Atot <= 0
                errorbox('Please enter a positive number for [P] total', hObject); 
                return
            end

            % Gets the value for KD and ensures that it's a
            % positive number
            KD= str2double(get(handles.input2_2, 'String'));

            if isnan(KD) || KD <= 0
                errorbox('K_D must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for n and ensures that it's a
            % positive number
            n = str2double(get(handles.input3_2, 'String'));

            if isnan(n) || n <= 0
                errorbox('n must be a number greater than 0', hObject); 
                return
            end

            % Determines whether the X-axis is free MT or free MT
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'

                   %Calculates the value of frac, MTfree, and Abound
                   [frac, MTfree] = coop_concerted_binding(xvals, Atot, KD, n);
                   
                   % Checks to make sure that the calculation suceeded and
                   % returns an error if it did not
                   [a,b] = size(frac);
                   if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                   end
                   
                   % Sets the x and y values to graph
                   y2 = frac;
                   x2 = MTfree;

                   % Sets the legend text
                   legend2 = ['Concerted cooperativity, [P] total = ' get(handles.input1_2, 'String') ', K_{D} = ' get(handles.input2_2, 'String') ', n = ' get(handles.input3_2, 'String')];

                case 'total'

                   % Calculates the value of frac and MTfree
                   [frac, MTfree] = coop_concerted_binding(xvals, Atot, KD, n);
                   
                   % Checks to make sure that the calculation suceeded and
                   % returns an error if it did not
                   [a,b] = size(frac);
                   if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                   end

                   % Sets the x and y values to graph
                   y2 = frac;
                   x2 = xvals; 

                   % Sets the legend text
                   legend2 = ['Concerted cooperativity, [P] total = ' get(handles.input1_2, 'String') ', K_{D} = ' get(handles.input2_2, 'String') ', n = ' get(handles.input3_2, 'String')];

                otherwise
            end

        % Saturation mode is selected
        case 'saturation'

            % Gets the value for [MT] free and ensures that it's a
            % positive number
            MTtot = str2double(get(handles.input1_2, 'String'));

            if isnan(MTtot) || MTtot <= 0
                errorbox('Please enter a positive number for [L] total', hObject); 
                return
            end

            % Gets the value for KD and ensures that it's a
            % positive number
            KD = str2double(get(handles.input2_2, 'String'));

            if isnan(KD) || KD <= 0
                errorbox('K_D must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the value for n and ensures that it's a
            % positive number
            n = str2double(get(handles.input3_2, 'String'));

            if isnan(n) || n <= 0
                errorbox('n must be a number greater than 0', hObject); 
                return
            end
            
            
            % Determines whether free or free [A] should be graphed
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'
                    
                    % Calculates Abound, and Afree
                    [Abound, Afree] = coop_concerted_saturation(MTtot, xvals, KD, n);
                    
                    % Checks to make sure the calculation suceeded and
                    % returns an error if it did not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end
                    
                    % Sets the x and y values to plot
                    y2 = Abound;
                    x2 = Afree;

                    % Sets the legend text
                    legend2 = ['Concerted cooperativity, [L] total = ' get(handles.input1_2, 'String') ', K_{D} = ' get(handles.input2_2, 'String') ', n = ' get(handles.input3_2, 'String')];

                    
                case 'total'
                
                    % Calculates Abound and Afree
                    [Abound, Afree] = coop_concerted_saturation(MTtot, xvals, KD, n);
                    
                    % Checks to make sure the calculation suceeded and
                    % returns an error if it did not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y data to plot
                    y2 = Abound;
                    x2 = xvals;

                    % Sets the legend text
                    legend2 = ['Concerted cooperativity, [L] total = ' get(handles.input1_2, 'String') ', K_{D} = ' get(handles.input2_2, 'String') ', n = ' get(handles.input3_2, 'String')];
                    
                case 'scatchard'
                    
                    % Calculates Abound and Afree
                    [Abound, Afree] = coop_concerted_saturation(MTtot, xvals, KD, n);
                    
                    % Checks to make sure the calculation suceeded and
                    % returns an error if it did not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y data to plot
                    y2 = Abound./Afree;
                    x2 = Abound;
                    
                    % Sets legend text
                    legend2 = ['Concerted cooperativity, [L] total = ' get(handles.input1_2, 'String') ', K_{D} = ' get(handles.input2_2, 'String') ', n = ' get(handles.input3_2, 'String')];
                    

                    
                otherwise
            end

        otherwise
    end

    elseif strcmpi(handles.mode2, 'coop2')

        %%% 2 Site sequential cooperativity %%%

        % Determine the experimental mode
        switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
            % Binding mode is selected
            case 'binding'

                % Gets the value for [A] free and ensures that it's a
                % positive number
                Atot = str2double(get(handles.input1_2, 'String'));

                if isnan(Atot) || Atot <= 0
                    errorbox('Please enter a positive number for [P] total', hObject); 
                    return
                end

                % Gets the value for KD1 and ensures that it's a
                % positive number
                KD1= str2double(get(handles.input2_2, 'String'));

                if isnan(KD1) || KD1 <= 0
                    errorbox('K_{D1} must be a number greater than 0', hObject); 
                    return
                end

                % Gets the value for KD2 and ensures that it's a
                % positive number
                KD2 = str2double(get(handles.input3_2, 'String'));

                if isnan(KD2) || KD2 <= 0
                    errorbox('K_{D2} must be a number greater than 0', hObject); 
                    return
                end

                % Determines whether the X-axis is free MT or free MT
                switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                    case 'free'

                       %Calculates the value of frac, MTfree, and Abound
                       [frac, MTfree] = coop2_binding(xvals, Atot, KD1, KD2);

                       % Checks to make sure that the calculation suceeded and
                       % returns an error if it did not
                       [a,b] = size(frac);
                       if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                       end

                       % Sets the x and y values to graph
                       y2 = frac;
                       x2 = MTfree;

                       % Sets the legend text
                       legend2 = ['2 site sequential cooperativity, [P] total = ' get(handles.input1_2, 'String') ', K_{D1} = ' get(handles.input2_2, 'String') ', K_{D2} = ' get(handles.input3_2, 'String')];

                    case 'total'

                       % Calculates the value of frac and MTfree
                       [frac, MTfree] = coop2_binding(xvals, Atot, KD1, KD2);

                       % Checks to make sure that the calculation suceeded and
                       % returns an error if it did not
                       [a,b] = size(frac);
                       if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                       end

                       % Sets the x and y values to graph
                       y2 = frac;
                       x2 = xvals; 

                       % Sets the legend text
                       legend2 = ['2 site sequential cooperativity, [P] total = ' get(handles.input1_2, 'String') ', K_{D1} = ' get(handles.input2_2, 'String') ', K_{D2} = ' get(handles.input3_2, 'String')];

                    otherwise
                end

            % Saturation mode is selected
            case 'saturation'

                % Gets the value for [MT] free and ensures that it's a
                % positive number
                MTtot = str2double(get(handles.input1_2, 'String'));

                if isnan(MTtot) || MTtot <= 0
                    errorbox('Please enter a positive number for [L] total', hObject); 
                    return
                end

                % Gets the value for KD1 and ensures that it's a
                % positive number
                KD1 = str2double(get(handles.input2_2, 'String'));

                if isnan(KD1) || KD1 <= 0
                    errorbox('K_{D1} must be a number greater than 0', hObject); 
                    return
                end

                % Gets the value for KD2 and ensures that it's a
                % positive number
                KD2 = str2double(get(handles.input3_2, 'String'));

                if isnan(KD2) || KD2 <= 0
                    errorbox('K_{D2} must be a number greater than 0', hObject); 
                    return
                end


                % Determines whether free or free [A] should be graphed
                switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                    case 'free'

                        % Calculates Abound, and Afree
                        [Abound, Afree] = coop2_saturation(MTtot, xvals, KD1, KD2);

                        % Checks to make sure the calculation suceeded and
                        % returns an error if it did not
                        [a,b] = size(Abound);
                        if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                        end

                        % Sets the x and y values to plot
                        y2 = Abound;
                        x2 = Afree;

                        % Sets the legend text
                        legend2 = ['2 site sequential cooperativity, [L] total = ' get(handles.input1_2, 'String') ', K_{D1} = ' get(handles.input2_2, 'String') ', K_{D2} = ' get(handles.input3_2, 'String')];


                    case 'total'

                        % Calculates Abound and Afree
                        [Abound, Afree] = coop2_saturation(MTtot, xvals, KD1, KD2);

                        % Checks to make sure the calculation suceeded and
                        % returns an error if it did not
                        [a,b] = size(Abound);
                        if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                        end

                        % Sets the x and y data to plot
                        y2 = Abound;
                        x2 = xvals;

                        % Sets the legend text
                        legend2 = ['2 site sequential cooperativity, [L] total = ' get(handles.input1_2, 'String') ', K_{D1} = ' get(handles.input2_2, 'String') ', K_{D2} = ' get(handles.input3_2, 'String')];

                    case 'scatchard'

                        % Calculates Abound and Afree
                        [Abound, Afree] = coop2_saturation(MTtot, xvals, KD1, KD2);

                        % Checks to make sure the calculation suceeded and
                        % returns an error if it did not
                        [a,b] = size(Abound);
                        if a == 1 && b == 1
                           errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                           return
                        end

                        % Sets the x and y data to plot
                        y2 = Abound./Afree;
                        x2 = Abound;

                        % Sets the legend text
                        legend2 = ['2 site sequential cooperativity, [L] total = ' get(handles.input1_2, 'String') ', K_{D1} = ' get(handles.input2_2, 'String') ', K_{D2} = ' get(handles.input3_2, 'String')];



                    otherwise
                end

            otherwise
        end

    elseif strcmpi(handles.mode2, 'coop4')
    
    %%% 4 site sequential cooperativity %%%
    
    % Determine the experimental mode
    switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
        % Binding mode is selected
        case 'binding'

            % Gets the value for [A] free and ensures that it's a
            % positive number
            Atot = str2double(get(handles.input1_2, 'String'));

            if isnan(Atot) || Atot <= 0
                errorbox('Please enter a positive number for [P] total', hObject); 
                return
            end

            % Gets the value for KD1 and ensures that it's a
            % positive number
            KD1 = str2double(get(handles.input2_2, 'String'));

            if isnan(KD1) || KD1 <= 0
                errorbox('K_{D1} must be a number greater than 0', hObject); 
                return
            end

            % Gets the value for KD2 and ensures that it's a
            % positive number
            KD2 = str2double(get(handles.input3_2, 'String'));

            if isnan(KD2) || KD2 <= 0
                errorbox('K_{D2} must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the value for KD3 and ensures that it's a
            % positive number
            KD3 = str2double(get(handles.input4_2, 'String'));

            if isnan(KD3) || KD3 <= 0
                errorbox('K_{D3} must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the value for KD4 and ensures that it's a
            % positive number
            KD4 = str2double(get(handles.input5_2, 'String'));

            if isnan(KD4) || KD4 <= 0
                errorbox('K_{D4} must be a number greater than 0', hObject); 
                return
            end

            % Determines whether the X-axis is free MT or free MT
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'

                   %Calculates the value of frac, MTfree, and Abound
                   [frac, MTfree] = coop4_binding(xvals, Atot, KD1, KD2, KD3, KD4);
                   
                   % Checks to make sure that the calculation suceeded and
                   % returns an error if it did not
                   [a,b] = size(frac);
                   if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                   end
                   
                   % Sets the x and y values to graph
                   y2 = frac;
                   x2 = MTfree;

                   % Sets the legend text
                   legend2 = ['4 site sequential cooperativity, [P] total = ' get(handles.input1_2, 'String') ', K_{D1} = ' get(handles.input2_2, 'String') ', K_{D2} = ' get(handles.input3_2, 'String') ', K_{D3} = ' get(handles.input4_2, 'String') ', K_{D4} = ' get(handles.input5_2, 'String')];

                case 'total'

                   % Calculates the value of frac and MTfree
                   [frac, MTfree] = coop4_binding(xvals, Atot, KD1, KD2, KD3, KD4);
                   
                   % Checks to make sure that the calculation suceeded and
                   % returns an error if it did not
                   [a,b] = size(frac);
                   if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                   end

                   % Sets the x and y values to graph
                   y2 = frac;
                   x2 = xvals; 

                   % Sets the legend text
                   legend2 = ['4 site sequential cooperativity, [P] total = ' get(handles.input1_2, 'String') ', K_{D} = ' get(handles.input2_2, 'String') ', K_{D2} = ' get(handles.input3_2, 'String') ', K_{D3} = ' get(handles.input4_2, 'String') ', K_{D4} = ' get(handles.input5_2, 'String')];

                otherwise
            end

        % Saturation mode is selected
        case 'saturation'

            % Gets the value for [MT] free and ensures that it's a
            % positive number
            MTtot = str2double(get(handles.input1_2, 'String'));

            if isnan(MTtot) || MTtot <= 0
                errorbox('Please enter a positive number for [L] total', hObject); 
                return
            end

            % Gets the value for KD1 and ensures that it's a
            % positive number
            KD1 = str2double(get(handles.input2_2, 'String'));

            if isnan(KD1) || KD1 <= 0
                errorbox('K_{D1} must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the value for KD2 and ensures that it's a
            % positive number
            KD2 = str2double(get(handles.input3_2, 'String'));

            if isnan(KD2) || KD2 <= 0
                errorbox('K_{D2} must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the value for KD3 and ensures that it's a
            % positive number
            KD3 = str2double(get(handles.input4_2, 'String'));

            if isnan(KD3) || KD3 <= 0
                errorbox('K_{D3} must be a number greater than 0', hObject); 
                return
            end
            
            % Gets the value for KD4 and ensures that it's a
            % positive number
            KD4 = str2double(get(handles.input5_2, 'String'));

            if isnan(KD4) || KD4 <= 0
                errorbox('K_{D4} must be a number greater than 0', hObject); 
                return
            end
            
            % Determines whether free or free [A] should be graphed
            switch get(get(handles.tot_free, 'SelectedObject'),'Tag')
                case 'free'
                    
                    % Calculates Abound, and Afree
                    [Abound, Afree] = coop4_saturation(MTtot, xvals, KD1, KD2, KD3, KD4);
                    
                    % Checks to make sure the calculation suceeded and
                    % returns an error if it did not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end
                    
                    % Sets the x and y values to plot
                    y2 = Abound;
                    x2 = Afree;

                    % Sets the legend text
                    legend2 = ['4 site sequential cooperativity, [L] total = ' get(handles.input1_2, 'String') ', K_{D1} = ' get(handles.input2_2, 'String') ', K_{D2} = ' get(handles.input3_2, 'String') ', K_{D3} = ' get(handles.input4_2, 'String') ', K_{D4} = ' get(handles.input5_2, 'String')];

                    
                case 'total'
                
                    % Calculates Abound and Afree
                    [Abound, Afree] = coop4_saturation(MTtot, xvals, KD1, KD2, KD3, KD4);
                    
                    % Checks to make sure the calculation suceeded and
                    % returns an error if it did not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y data to plot
                    y2 = Abound;
                    x2 = xvals;

                    % Sets the legend text
                    legend2 = ['4 site sequential cooperativity, [L] total = ' get(handles.input1_2, 'String') ', K_{D1} = ' get(handles.input2_2, 'String') ', K_{D2} = ' get(handles.input3_2, 'String') ', K_{D3} = ' get(handles.input4_2, 'String') ', K_{D4} = ' get(handles.input5_2, 'String')];
                    
                case 'scatchard'
                    
                    % Calculates Abound and Afree
                    [Abound, Afree] = coop4_saturation(MTtot, xvals, KD1, KD2, KD3, KD4);
                    
                    % Checks to make sure the calculation suceeded and
                    % returns an error if it did not
                    [a,b] = size(Abound);
                    if a == 1 && b == 1
                       errorbox('Sorry, that curve cannot be computed. Please report this as a bug.', hObject);
                       return
                    end

                    % Sets the x and y data to plot
                    y2 = Abound./Afree;
                    x2 = Abound;
                    
                    % Sets the legend text
                    legend2 = ['4 site sequential coopeativity, [L] total = ' get(handles.input1_2, 'String') ', K_{D1} = ' get(handles.input2_2, 'String') ', K_{D2} = ' get(handles.input3_2, 'String') ', K_{D3} = ' get(handles.input4_2, 'String') ', K_{D4} = ' get(handles.input5_2, 'String')];
                    

                    
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
    % x-axis is in total mode
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
    ls = legend_strings(length(list) - i + 1);
    
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
        
   % 2 Sites model     
    case 2
        
        handles.mode1 = 'Sites';
        
        % Determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                
                % Checks to see if the x-axis is MT free and deletes the
                % graph
                if strcmpi(get(get(handles.tot_free, 'SelectedObject'),'Tag'), 'free') && (ishandle(handles.graphaxes) || ishandle(handles.graphfigure))
                    
                    clear = questdlg('The 2 Sites model cannot be graphed with the x-axis as [MT] free. Do you want to close the current graph?', 'Close Graph Window?', 'Yes','No','No');
    
                    % Returns the selection to is previous value and stops evaluating further
                    % code if the user selects no
                    if strcmp(clear, 'No')
                        set(handles.curve1, 'Value', 1);
                        handles.mode1 = 'firstorder';
                        first_order_binding_labels1(hObject);
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

                
                Sites_binding_labels1(hObject);
               
            case 'saturation'
                
                Sites_saturation_labels1(hObject);
                
            otherwise
        end
      
    % Concerted cooperativity
    case 3
        
        handles.mode1 = 'concerted';
        
        %determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                concerted_binding_labels1(hObject);
                
            case 'saturation'
                concerted_saturation_labels1(hObject);
                            
            otherwise
        end
        
    % 2 site sequential cooperativity
    case 4
        
        handles.mode1 = 'coop2';
        
        %determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                coop2_binding_labels1(hObject);
                
            case 'saturation'
                coop2_saturation_labels1(hObject);
                            
            otherwise
        end
        
    % First order binding
    case 5
        
        handles.mode1 = 'coop4';
        
        %determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                coop4_binding_labels1(hObject);
                
            case 'saturation'
                coop4_saturation_labels1(hObject);
                            
            otherwise
        end
        
    otherwise
end

% Checks to see if the 2 site mode is selected in binding mode and turns MT
% free on or off accordingly
if strcmpi(get(get(handles.exp_mode, 'SelectedObject'),'Tag'), 'binding')
    if strcmpi(handles.mode1, 'Sites')
        set(handles.free, 'Visible','off');
        set(handles.tot_free, 'SelectedObject', handles.total);
    elseif strcmp(get(get(handles.plot_mode, 'SelectedObject'), 'Tag'), 'compare') && strcmpi(handles.mode2, 'Sites')
        set(handles.free, 'Visible','off');
        set(handles.tot_free, 'SelectedObject', handles.total);
    else
        set(handles.free, 'Visible', 'on');
    end
else
    set(handles.free, 'Visible', 'on');
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
        
      % 2 sites model     
      case 2
        
        handles.mode2 = 'sites';
        
        % Determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                
                % Checks to see if the x-axis is set to MT free and deletes the graph 
                if strcmpi(get(get(handles.tot_free, 'SelectedObject'),'Tag'), 'free') && (ishandle(handles.graphaxes) || ishandle(handles.graphfigure))
                    
                    clear = questdlg('The 2 Sites model cannot be graphed with the x-axis as [MT] free. Do you want to close the current graph?', 'Close Graph Window?', 'Yes','No','No');
    
                    % Returns the selection to is previous value and stops evaluating further
                    % code if the user selects no
                    if strcmp(clear, 'No')
                        set(handles.curve2, 'Value', 1);
                        handles.mode2 = 'firstorder';
                        first_order_binding_lables2(hObject);
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
                
                Sites_binding_labels2(hObject);
               
            case 'saturation'
                
                Sites_saturation_labels2(hObject);
                
            otherwise
        end
        
    % Concerted cooperativity
    case 3
        
        handles.mode2 = 'concerted';
        
        %determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                concerted_binding_labels2(hObject);
                
            case 'saturation'
                concerted_saturation_labels2(hObject);
                            
            otherwise
        end

    % First order binding
    case 4
        
        handles.mode2 = 'coop2';
        
        %determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                coop2_binding_labels2(hObject);
                
            case 'saturation'
                coop2_saturation_labels2(hObject);
                            
            otherwise
        end
        
    % First order binding
    case 5
        
        handles.mode2 = 'coop4';
        
        %determine which experimental mode is selected
        switch get(get(handles.exp_mode, 'SelectedObject'),'Tag')
            case 'binding'
                coop4_binding_labels2(hObject);
                
            case 'saturation'
                coop4_saturation_labels2(hObject);
                            
            otherwise
        end

        
    otherwise
end

% Checks to see if the 2 site mode is selected in binding mode and turns MT
% free on or off accordingly
if strcmpi(get(get(handles.exp_mode, 'SelectedObject'),'Tag'), 'binding')
    if strcmpi(handles.mode1, 'Sites')
        set(handles.free, 'Visible','off');
        set(handles.tot_free, 'SelectedObject', handles.total)
    elseif strcmp(get(get(handles.plot_mode, 'SelectedObject'), 'Tag'), 'compare') && strcmpi(handles.mode2, 'Sites')
        set(handles.free, 'Visible','off');
        set(handles.tot_free, 'SelectedObject', handles.total)
    else
        set(handles.free, 'Visible', 'on');
    end
else
    set(handles.free, 'Visible', 'on');
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
        
        % Makes the curve selection drop down boxes and info box visible
        set(handles.curve1, 'Visible', 'on');
        set(handles.info1, 'Visible', 'on');
        
        % Makes the X-axis selection box visible
        set(handles.tot_free, 'Visible', 'on');
        
        % Makes the scatchard radio button invisible
        set(handles.scatchard, 'Visible', 'off');
        
        % Determines which model is selected and sets the labels
        % accordingly

        % First order biding selected
        if strcmpi(handles.mode1, 'firstorder')

            first_order_binding_labels1(hObject);

        % 2 sites model is selected    
        elseif strcmpi(handles.mode1, 'sites')
            
            Sites_binding_labels1(hObject);
            
        % Concerted cooperativity is selected
        elseif strcmpi(handles.mode1, 'concerted')
            
            concerted_binding_labels1(hObject);
            
        % 2 site sequential cooperativity is selected
        elseif strcmpi(handles.mode1, 'coop2')
            
            coop2_binding_labels1(hObject);
        
        % 4 site sequential cooperativity is selected
        elseif strcmpi(handles.mode1, 'coop4')
            
            coop4_binding_labels1(hObject);
            
        end

        % Determines if single or comparision mode is selected
        % Changes visible boxes for the second curve if comparision mode is
        % selected
        if strcmp(get(get(handles.plot_mode, 'SelectedObject'), 'Tag'), 'compare')
            
            % Makes the curve selction box and info button visible
            set(handles.curve2, 'Visible', 'on');
            set(handles.info2, 'Visible', 'on');
            
            % Gets the current value of the first curve slection box and
            % changes the visible boxes accordingly
            
            % First order biding selected
            if strcmpi(handles.mode2, 'firstorder')
                first_order_binding_labels2(hObject);

            % 2 sites model is selected
            elseif strcmpi(handles.mode2, 'Sites')
                
                Sites_binding_labels2(hObject);
                
            % Concerted cooperativity is selected
            elseif strcmpi(handles.mode2, 'concerted')

                concerted_binding_labels2(hObject);

            % 2 site sequential cooperativity is selected
            elseif strcmpi(handles.mode2, 'coop2')

                coop2_binding_labels2(hObject);

            % 4 site sequential cooperativity is selected
            elseif strcmpi(handles.mode2, 'coop4')

                coop4_binding_labels2(hObject);


            end
            
        end
        
    case 'saturation'
        
        % Makes the curve selection drop down boxes and info box visible
        set(handles.curve1, 'Visible', 'on');
        set(handles.info1, 'Visible', 'on');
        
        % Makes the X-axis selection box visible
        set(handles.tot_free, 'Visible', 'on');
        
        % Makes the scatchard radio button visible
        set(handles.scatchard, 'Visible', 'on');

        % Gets the current value of the first curve slection box and
        % changes the visible boxes accordingly
        
        % First order biding selected
        if strcmpi(handles.mode1, 'firstorder')

            first_order_saturation_labels1(hObject);
            
        % The two site model is selected    
        elseif strcmpi(handles.mode1, 'Sites')
            
            Sites_saturation_labels1(hObject);

        % The concerted cooperativity   
        elseif strcmpi(handles.mode1, 'concerted')
            
            concerted_saturation_labels1(hObject);
            
        % The 2 site sequential cooperativity    
        elseif strcmpi(handles.mode1, 'coop2')
            
            coop2_saturation_labels1(hObject);

        % The 4 site sequential cooperativity    
        elseif strcmpi(handles.mode1, 'coop4')
            
            coop4_saturation_labels1(hObject);
            
        end
        
        % Determines if single or comparision mode is selected
        % Changes visible boxes for the second curve if comparision mode is
        % selected
        if strcmp(get(get(handles.plot_mode, 'SelectedObject'), 'Tag'), 'compare')
            
            % Makes the curve selection box and info box visible
            set(handles.curve2, 'Visible', 'on');
            set(handles.info2, 'Visible', 'on');
            
            % Gets the current value of the second curve slection box and
            % changes the visible boxes accordingly
            
            % First order biding selected
            if strcmpi(handles.mode2, 'firstorder')

                first_order_saturation_labels2(hObject);
                
            % Two sites is selected
            elseif strcmpi(handles.mode2, 'Sites')
                
                Sites_saturation_labels2(hObject);
                
            % The concerted cooperativity   
            elseif strcmpi(handles.mode2, 'concerted')

                concerted_saturation_labels2(hObject);

            % The 2 site sequential cooperativity    
            elseif strcmpi(handles.mode2, 'coop2')

                coop2_saturation_labels2(hObject);

            % The 4 site sequential cooperativity    
            elseif strcmpi(handles.mode2, 'coop4')

                coop4_saturation_labels2(hObject);

            end
            
        end
        
    case 'competition'
        
        % Sets the visibility of the x-axis selection box
        set(handles.tot_free, 'Visible', 'off');
        
        % Makes the curve selection drop down boxes and info boxes invisible
        set(handles.curve1, 'Visible', 'off');
        set(handles.info1, 'Visible', 'off');
        set(handles.curve2, 'Visible', 'off');
        set(handles.info2, 'Visible', 'off');
        
        competition_labels1(hObject);
        
        % Determines if comparision mode is selected
        if strcmp(get(get(handles.plot_mode, 'SelectedObject'), 'Tag'), 'compare')
            
            competition_labels2(hObject);
        end
        
        
    otherwise
end


% Checks to see if the 2 site mode is selected in binding mode and turns MT
% free on or off accordingly
if strcmpi(get(eventdata.NewValue, 'Tag'), 'binding')
    if strcmpi(handles.mode1, 'Sites')
        set(handles.free, 'Visible','off');
        set(handles.tot_free, 'SelectedObject', handles.total)
    elseif strcmp(get(get(handles.plot_mode, 'SelectedObject'), 'Tag'), 'compare') && strcmpi(handles.mode2, 'Sites')
        set(handles.free, 'Visible','off');
        set(handles.tot_free, 'SelectedObject', handles.total)
    else
        set(handles.free, 'Visible', 'on');
    end
else
    set(handles.free, 'Visible', 'on');
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
        set(handles.info2, 'Visible', 'off');
        set(handles.model2, 'Visible', 'off');
        set(handles.equation2, 'Visible', 'off');
        set(handles.result, 'Visible', 'off');
        
        if strcmpi(handles.mode1, 'Sites')
        elseif strcmpi(get(get(handles.exp_mode, 'SelectedObject'), 'Tag'), 'binding')
            set(handles.free, 'Visible', 'on');
        end
        
    case 'compare'
        
        % Sets the curve selection box and curve data boxes as visible
        set(handles.curve2, 'Visible', 'on');
        set(handles.info2, 'Visible', 'on');
        set(handles.model2, 'Visible', 'on');
        set(handles.equation2, 'Visible', 'on');
        set(handles.result, 'Visible', 'on');
        
        % Determines which experimenal mode is selected and sets the imput
        % boxes accordingly
        switch get(get(handles.exp_mode, 'SelectedObject'), 'Tag')
           
            case 'binding'
                
                switch handles.mode2
                    
                    case 'firstorder'
                        
                        first_order_binding_labels2(hObject);
                        
                    case 'Sites'
                        
                        Sites_binding_labels2(hObject);
                        set(handles.free, 'Visible','off');
                        set(handles.tot_free, 'SelectedObject', handles.total);
                        
                    case 'concerted'

                        concerted_binding_labels2(hObject);
                        
                    case 'coop2'
                        
                        coop2_binding_labels2(hObject);
                        
                    case 'coop4'
                        
                        coop4_binding_labels2(hObject);
                        
                    otherwise
                end
                
            case 'saturation'
                
                switch handles.mode2
                    
                    case 'firstorder'
                        
                        first_order_saturation_labels2(hObject);
                        
                        
                    case 'Sites'
                        
                        Sites_saturation_labels2(hObject);
                        
                    case 'concerted'
                        
                        concerted_saturation_labels2(hObject);
                    
                        
                    case 'coop2'
                        
                        coop2_saturation_labels2(hObject);
                    
                        
                    case 'coop4'
                        
                        coop4_saturation_labels2(hObject);
                        
                    otherwise
                end
                
                
            case 'competition'
                
                set(handles.curve2, 'Visible', 'off');
                set(handles.info2, 'Visible', 'off');
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

global KD;
set_java_component(model, 'P + L &#8596; PL');
set_java_component(equation, [KD, ' = [P][L]/[PL]']);
end


function Sites_strings(model, equation)

% Generates the model and equation strings for two sites

global KD1 KD2;
set_java_component(model, 'P + L1 &#8596; PL1, P + L2 &#8596; PL2');
set_java_component(equation, [KD1 ' =[P][L1]/[PL1], ', KD2, ' =[P][L2]/[PL2]']);

end

function concerted_strings(model, equation)

% Generates the model and equation strings for first order

global KD;
set_java_component(model, 'P + nL &#8596; PL_n');
set_java_component(equation, [KD, ' = [P][L]^n/[PL_n]']);
end

function coop2_strings(model, equation)

% Generates the model and equation strings for first order

global KD1 KD2;
set_java_component(model, 'P + L &#8596; PL, PL + L &#8596; PL_2');
set_java_component(equation, [KD1, ' = [P][L]/[PL],' KD2, ' = [PL][L]/[PL_2]' ]);
end

function coop4_strings(model, equation)

% Generates the model and equation strings for first order

global KD1 KD2 KD3 KD4;
set_java_component(model, 'P + L &#8596; PL, PL + L &#8596; PL_2, PL_2 + L &#8596; PL_3, PL_3 + L &#8596; PL_4');
set_java_component(equation, [KD1, ' = [P][L]/[PL], ' KD2, ' = [PL][L]/[PL_2], ' KD3, ' = [PL_2][L]/[PL_3], ' KD4, ' = [PL_3][L]/[PL_4]']);
end

function competition_strings(model, equation)

% Generates the model and equation strings for competition

global KDP KDB;
set_java_component(model, 'P + L &#8596; PL, B + L &#8596; BL');
set_java_component(equation, [KDP, ' =[P][L]/[PL], ', KDB, ' =[B][L]/[BL]']);
end

function first_order_binding_labels1(hObject)
% Function to update the apperence of MTBindingSim for the case where the
% first function is first order binding in binding mode

global KD;

% Sets the visibility for all input boxes
inputboxes_display1(hObject, 2);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the equation and model text
first_order_strings(handles.model1, handles.equation1);


% Sets labels for the visible input boxes
set(handles.label_xmin, 'String', '[L] total min ');
set(handles.label_xmax, 'String', '[L] total max ');
set(handles.total, 'String', '[L] total');
set(handles.free, 'String', '[L] free');
set_java_component(handles.label1_1, '[P] total');
set_java_component(handles.label2_1, [KD, ' ']);


% Updates the handles structure
guidata(hObject, handles);

end



function first_order_saturation_labels1(hObject)
% Function to update the appearence of binding_BUI for the case where the
% first function is first oder binding in saturation mode

global KD;

% Sets the visibility for all input boxes
inputboxes_display1(hObject, 2);

handles = guidata(hObject);

% Sets the equation and model text
first_order_strings(handles.model1, handles.equation1);

%Sets labels for the input boxes
set(handles.label_xmin, 'String', '[P] total min ');
set(handles.label_xmax, 'String', '[P] total max ');
set(handles.total, 'String', '[P] total');
set(handles.free, 'String', '[P] free');
set_java_component(handles.label1_1, '[L] total ');
set_java_component(handles.label2_1, [KD, ' ']);


% Updates the handles structure
guidata(hObject, handles);

end

function Sites_binding_labels1(hObject)
% Function to update the appearnce of MTBindinSim for the case where the
% first function is dimerization in binding mode

global KD1 KD2 UM;

% Sets the visibility for all imput boxes
inputboxes_display1(hObject, 3);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the model equation and text
Sites_strings(handles.model1, handles.equation1);

% Sets labels for the input boxes
set(handles.label_xmin, 'String', '[L] total min ');
set(handles.label_xmax, 'String', '[L] total max ');
set(handles.total, 'String', '[L] total');
set(handles.free, 'String', '[L] free');
set_java_component(handles.label1_1, '[P] total ');
set_java_component(handles.label2_1, [KD1, ' ']);
set_java_component(handles.label3_1, [KD2, ' ']);
set_java_component(handles.units3_1, [UM, ' ']);

% Updates the handles structure
guidata(hObject, handles);

end

function Sites_saturation_labels1(hObject)
% Function to update the appearnce of MTBindinSim for the case where the
% first function is dimerization in saturation mode

global KD1 KD2 UM;

% Sets the visibility for all imput boxes
inputboxes_display1(hObject, 3);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the model equation and text
Sites_strings(handles.model1, handles.equation1);

% Sets labels for the input boxes
set(handles.label_xmin, 'String', '[P] total min ');
set(handles.label_xmax, 'String', '[P] total max ');
set(handles.total, 'String', '[P] total');
set(handles.free, 'String', '[P] free');
set_java_component(handles.label1_1, '[L] total ');
set_java_component(handles.label2_1, [KD1, ' ']);
set_java_component(handles.label3_1, [KD2, ' ']);
set_java_component(handles.units3_1, [UM, ' ']);

% Updates the handles structure
guidata(hObject, handles);

end

function concerted_binding_labels1(hObject)
% Function to update the apperence of MTBindingSim for the case where the
% first function is concerted cooperative binding in binding mode

global KD;

% Sets the visibility for all input boxes
inputboxes_display1(hObject, 3);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the equation and model text
concerted_strings(handles.model1, handles.equation1);


% Sets labels for the visible input boxes
set(handles.label_xmin, 'String', '[L] total min ');
set(handles.label_xmax, 'String', '[L] total max ');
set(handles.total, 'String', '[L] total');
set(handles.free, 'String', '[L] free');
set_java_component(handles.label1_1, '[P] total');
set_java_component(handles.label2_1, [KD, ' ']);
set_java_component(handles.label3_1, 'n');
set(handles.units3_1, 'Visible', 'off');


% Updates the handles structure
guidata(hObject, handles);

end



function concerted_saturation_labels1(hObject)
% Function to update the appearence of binding_BUI for the case where the
% first function is concerted cooperative binding in saturation mode

global KD;

% Sets the visibility for all input boxes
inputboxes_display1(hObject, 3);

handles = guidata(hObject);

% Sets the equation and model text
concerted_strings(handles.model1, handles.equation1);

%Sets labels for the input boxes
set(handles.label_xmin, 'String', '[P] total min ');
set(handles.label_xmax, 'String', '[P] total max ');
set(handles.total, 'String', '[P] total');
set(handles.free, 'String', '[P] free');
set_java_component(handles.label1_1, '[L] total ');
set_java_component(handles.label2_1, [KD, ' ']);
set_java_component(handles.label3_1, 'n');
set(handles.units3_1, 'Visible', 'off');

% Updates the handles structure
guidata(hObject, handles);

end

function coop2_binding_labels1(hObject)
% Function to update the apperence of MTBindingSim for the case where the
% first function is 2 site sequential cooperative binding in binding mode

global KD1 KD2;

% Sets the visibility for all input boxes
inputboxes_display1(hObject, 3);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the equation and model text
coop2_strings(handles.model1, handles.equation1);


% Sets labels for the visible input boxes
set(handles.label_xmin, 'String', '[L] total min ');
set(handles.label_xmax, 'String', '[L] total max ');
set(handles.total, 'String', '[L] total');
set(handles.free, 'String', '[L] free');
set_java_component(handles.label1_1, '[P] total');
set_java_component(handles.label2_1, [KD1, ' ']);
set_java_component(handles.label3_1, [KD2, ' ']);


% Updates the handles structure
guidata(hObject, handles);

end



function coop2_saturation_labels1(hObject)
% Function to update the appearence of binding_BUI for the case where the
% first function is 2 site sequential cooperative binding in saturation mode

global KD1 KD2;

% Sets the visibility for all input boxes
inputboxes_display1(hObject, 3);

handles = guidata(hObject);

% Sets the equation and model text
coop2_strings(handles.model1, handles.equation1);

%Sets labels for the input boxes
set(handles.label_xmin, 'String', '[P] total min ');
set(handles.label_xmax, 'String', '[P] total max ');
set(handles.total, 'String', '[P] total');
set(handles.free, 'String', '[P] free');
set_java_component(handles.label1_1, '[L] total ');
set_java_component(handles.label2_1, [KD1, ' ']);
set_java_component(handles.label3_1, [KD2, ' ']);

% Updates the handles structure
guidata(hObject, handles);

end

function coop4_binding_labels1(hObject)
% Function to update the apperence of MTBindingSim for the case where the
% first function is 4 site sequential cooperative binding in binding mode

global KD1 KD2 KD3 KD4;

% Sets the visibility for all input boxes
inputboxes_display1(hObject, 5);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the equation and model text
coop4_strings(handles.model1, handles.equation1);


% Sets labels for the visible input boxes
set(handles.label_xmin, 'String', '[L] total min ');
set(handles.label_xmax, 'String', '[L] total max ');
set(handles.total, 'String', '[L] total');
set(handles.free, 'String', '[L] free');
set_java_component(handles.label1_1, '[P] total');
set_java_component(handles.label2_1, [KD1, ' ']);
set_java_component(handles.label3_1, [KD2, ' ']);
set_java_component(handles.label4_1, [KD3, ' ']);
set_java_component(handles.label5_1, [KD4, ' ']);


% Updates the handles structure
guidata(hObject, handles);

end



function coop4_saturation_labels1(hObject)
% Function to update the appearence of binding_BUI for the case where the
% first function is 4 site sequential cooperative binding in saturation mode

global KD1 KD2 KD3 KD4;

% Sets the visibility for all input boxes
inputboxes_display1(hObject, 5);

handles = guidata(hObject);

% Sets the equation and model text
coop4_strings(handles.model1, handles.equation1);

%Sets labels for the input boxes
set(handles.label_xmin, 'String', '[P] total min ');
set(handles.label_xmax, 'String', '[P] total max ');
set(handles.total, 'String', '[P] total');
set(handles.free, 'String', '[P] free');
set_java_component(handles.label1_1, '[L] total ');
set_java_component(handles.label2_1, [KD1, ' ']);
set_java_component(handles.label3_1, [KD2, ' ']);
set_java_component(handles.label4_1, [KD3, ' ']);
set_java_component(handles.label5_1, [KD4, ' ']);


% Updates the handles structure
guidata(hObject, handles);

end

function competition_labels1(hObject)
% Function to update the appearnce of MTBindingSim for the case where
% the competition experimental mode is selected

global KDP KDB UM;

% Sets the visibility for all imput boxes
inputboxes_display1(hObject, 4);

handles = guidata(hObject);

% Sets the equation and model text
competition_strings(handles.model1, handles.equation1);

% Sets the labels for the visible imput boxes
set(handles.label_xmin, 'String', '[B] total min ');
set(handles.label_xmax, 'String', '[B] total max ');
set_java_component(handles.label1_1, '[L] total ');
set_java_component(handles.label2_1, '[P] total ');
set_java_component(handles.label3_1, [KDP, ' ']);
set_java_component(handles.units3_1, [UM, ' ']);
set_java_component(handles.label4_1, [KDB, ' ']);
set_java_component(handles.units4_1, [UM, ' ']);

% Updates the handles structure
guidata(hObject, handles);

end



function first_order_binding_labels2(hObject)
% Function to update the apperence of MTBindingSim for the case where the
% second function is first order binding in binding mode

global KD;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 2);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the equation and model text
first_order_strings(handles.model2, handles.equation2);

% Sets labels for the visible input boxes
set_java_component(handles.label1_2, '[P] total ');
set_java_component(handles.label2_2, [KD, ' ']);

% Updates the handles structure
guidata(hObject, handles);

end


function first_order_saturation_labels2(hObject)
% Function to update the appearence of MTBindingSim for the case where the
% second function is first oder binding in saturation mode

global KD;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 2);

handles = guidata(hObject);

% Sets the equation and model text
first_order_strings(handles.model2, handles.equation2);

% Sets labels for the input boxes
set_java_component(handles.label1_2, '[L] total ');
set_java_component(handles.label2_2, [KD, ' ']);

% Updates the handles structure
guidata(hObject, handles);

end


function Sites_binding_labels2(hObject)
% Function to update the appearnce of MTBindinSim for the case where the
% second function is dimerization in binding mode

global KD1 KD2 UM;

% Sets the visibility for all imput boxes
inputboxes_display2(hObject, 3);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the model equation and text
Sites_strings(handles.model2, handles.equation2);

% Sets labels for the input boxes
set_java_component(handles.label1_2, '[P] total ');
set_java_component(handles.label2_2, [KD1, ' ']);
set_java_component(handles.label3_2, [KD2, ' ']);
set_java_component(handles.units3_2, [UM, ' ']);

% Updates the handles structure
guidata(hObject, handles);

end

function Sites_saturation_labels2(hObject)
% Function to update the appearnce of MTBindinSim for the case where the
% second function is dimerization in saturation mode

global KD1 KD2 UM;

% Sets the visibility for all imput boxes
inputboxes_display2(hObject, 3);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the model equation and text
Sites_strings(handles.model2, handles.equation2);

% Sets labels for the input boxes
set_java_component(handles.label1_2, '[L] total ');
set_java_component(handles.label2_2, [KD1, ' ']);
set_java_component(handles.label3_2, [KD2, ' ']);
set_java_component(handles.units3_2, [UM, ' ']);

% Updates the handles structure
guidata(hObject, handles);

end

function concerted_binding_labels2(hObject)
% Function to update the apperence of MTBindingSim for the case where the
% second function is concerted cooperative binding in binding mode

global KD;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 3);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the equation and model text
concerted_strings(handles.model2, handles.equation2);


% Sets labels for the visible input boxes
set_java_component(handles.label1_2, '[P] total');
set_java_component(handles.label2_2, [KD, ' ']);
set_java_component(handles.label3_2, 'n');
set(handles.units3_2, 'Visible', 'off');


% Updates the handles structure
guidata(hObject, handles);

end



function concerted_saturation_labels2(hObject)
% Function to update the appearence of binding_BUI for the case where the
% second function is concerted cooperative binding in saturation mode

global KD;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 3);

handles = guidata(hObject);

% Sets the equation and model text
concerted_strings(handles.model2, handles.equation2);

%Sets labels for the input boxes
set_java_component(handles.label1_2, '[L] total ');
set_java_component(handles.label2_2, [KD, ' ']);
set_java_component(handles.label3_2, 'n');
set(handles.units3_2, 'Visible', 'off');

% Updates the handles structure
guidata(hObject, handles);

end

function coop2_binding_labels2(hObject)
% Function to update the apperence of MTBindingSim for the case where the
% second function is 2 site sequential cooperative binding in binding mode

global KD1 KD2;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 3);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the equation and model text
coop2_strings(handles.model2, handles.equation2);


% Sets labels for the visible input boxes
set_java_component(handles.label1_2, '[P] total');
set_java_component(handles.label2_2, [KD1, ' ']);
set_java_component(handles.label3_2, [KD2, ' ']);


% Updates the handles structure
guidata(hObject, handles);

end



function coop2_saturation_labels2(hObject)
% Function to update the appearence of binding_BUI for the case where the
% second function is 2 site sequential cooperative binding in saturation mode

global KD1 KD2;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 3);

handles = guidata(hObject);

% Sets the equation and model text
coop2_strings(handles.model2, handles.equation2);

%Sets labels for the input boxes
set_java_component(handles.label1_2, '[L] total ');
set_java_component(handles.label2_2, [KD1, ' ']);
set_java_component(handles.label3_2, [KD2, ' ']);

% Updates the handles structure
guidata(hObject, handles);

end

function coop4_binding_labels2(hObject)
% Function to update the apperence of MTBindingSim for the case where the
% second function is 4 site sequential cooperative binding in binding mode

global KD1 KD2 KD3 KD4;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 5);

% Retreives the GUI handles structure
handles = guidata(hObject);

% Sets the equation and model text
coop4_strings(handles.model2, handles.equation2);


% Sets labels for the visible input boxes
set_java_component(handles.label1_2, '[P] total');
set_java_component(handles.label2_2, [KD1, ' ']);
set_java_component(handles.label3_2, [KD2, ' ']);
set_java_component(handles.label4_2, [KD3, ' ']);
set_java_component(handles.label5_2, [KD4, ' ']);


% Updates the handles structure
guidata(hObject, handles);

end



function coop4_saturation_labels2(hObject)
% Function to update the appearence of binding_BUI for the case where the
% second function is 4 site sequential cooperative binding in saturation mode

global KD1 KD2 KD3 KD4;

% Sets the visibility for all input boxes
inputboxes_display2(hObject, 5);

handles = guidata(hObject);

% Sets the equation and model text
coop4_strings(handles.model2, handles.equation2);

%Sets labels for the input boxes
set(handles.label_xmin, 'String', '[P] total min ');
set(handles.label_xmax, 'String', '[P] total max ');
set(handles.total, 'String', '[P] total');
set(handles.free, 'String', '[P] free');
set_java_component(handles.label1_2, '[L] total ');
set_java_component(handles.label2_2, [KD1, ' ']);
set_java_component(handles.label3_2, [KD2, ' ']);
set_java_component(handles.label4_2, [KD3, ' ']);
set_java_component(handles.label5_2, [KD4, ' ']);


% Updates the handles structure
guidata(hObject, handles);

end

function competition_labels2(hObject)
% Function to update the appearnce of MTBindingSIm for the case where
% the competition experimental mode is selected

global KDP KDB UM;

% Sets the visibility for all imput boxes
inputboxes_display2(hObject, 4);

handles = guidata(hObject);

% Sets the equation and model text
competition_strings(handles.model2, handles.equation2);

% Sets the labels for the visible imput boxes
set_java_component(handles.label1_2, '[L] total ');
set_java_component(handles.label2_2, '[P] total ');
set_java_component(handles.label3_2, [KDP, ' ']);
set_java_component(handles.label4_2, [KDB, ' ']);
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
set(handles.scatchard, 'Enable', 'off');

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
set(handles.scatchard, 'Enable', 'on');

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


% --- Executes on button press in info1.
function info1_Callback(hObject, eventdata, handles)
% hObject    handle to info1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global firstorder dimer MAPbind MAP2bind pseudocooperativity sites seam;

% Determines which model is selected an displays the appropriate info box

% First order biding selected
if strcmpi(handles.mode1, 'firstorder')

    msgbox(firstorder, 'Model Information');

% 2 sites is selected
elseif strcmpi(handles.mode1, 'Sites')

    msgbox(sites, 'Model Information');

end

end


% --- Executes on button press in info2.
function info2_Callback(hObject, eventdata, handles)
% hObject    handle to info2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global firstorder dimer MAPbind MAP2bind pseudocooperativity sites seam;


% Determines which model is selected an displays the appropriate info box

% First order biding selected
if strcmpi(handles.mode2, 'firstorder')

    msgbox(firstorder, 'Model Information');

% 2 sites is selected
elseif strcmpi(handles.mode2, 'Sites')

    msgbox(sites, 'Model Information');

end

end
