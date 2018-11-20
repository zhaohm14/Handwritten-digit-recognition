function varargout = Training(varargin)
% TRAINING MATLAB code for Training.fig
%      TRAINING, by itself, creates a new TRAINING or raises the existing
%      singleton*.
%
%      H = TRAINING returns the handle to a new TRAINING or the handle to
%      the existing singleton*.
%
%      TRAINING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRAINING.M with the given input arguments.
%
%      TRAINING('Property','Value',...) creates a new TRAINING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Training_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Training_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Training

% Last Modified by GUIDE v2.5 13-Oct-2018 13:04:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Training_OpeningFcn, ...
                   'gui_OutputFcn',  @Training_OutputFcn, ...
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


% --- Executes just before Training is made visible.
function Training_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Training (see VARARGIN)

% Choose default command line output for Training
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
addpath(genpath(pwd));

movegui(gcf, 'center');

global BGNum;
BGNum = 1;
try
    BG = dir('BGP');
    axes(handles.BGAxes);
    image(imread(['\BGP\', BG(BGNum + 2).name]));
    axis off;
end

set(handles.ParametersSetting, 'Userdata', 0);

global hInfoText;
hInfoText = handles.TextDisp;
set(hInfoText, 'String', {'Opened ''Training.'''; datestr(now, 0); '---------------------------------------------------'});

% UIWAIT makes Training wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Training_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ArchitectureSelection.
function ArchitectureSelection_Callback(hObject, eventdata, handles)
% hObject    handle to ArchitectureSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
infoText('Executed ''Select architecture''');

global layer;
if layer == layer
    layer = str2double(inputdlg('Layer num of neutral network£º', 'Input', 1, {num2str(layer)}));
else
    layer = str2double(inputdlg('Layer num of neutral network£º', 'Input'));
end
if size(layer, 1) == 0
    return;
end
if layer == layer
    if layer >= 1 && mod(layer, 1) == 0
        if layer > 10
            myerrordlg('This number is too much for this program!');
            ArchitectureSelection_Callback(hObject, eventdata, handles);
            return;
        end
        get_unit(hObject, eventdata, handles);
        return;
    end
end
myerrordlg('The number of layers of the neural network must be a positive integer£¡');
ArchitectureSelection_Callback(hObject, eventdata, handles);


function get_unit(hObject, eventdata, handles)
global unit_net;
global layer;

prompt = cell(1, layer);
for ii = 1 : layer
    prompt{ii} = ['Layer ', num2str(ii), ':']; 
end
UnitNet = unit_inputdlg(prompt, 'Set the number of units in each layer (excluding bias unit)');

if isempty(UnitNet)
    mywarndlg('Units are not defined.');
    return;
else
    for ii = 1 : layer
        if isempty(UnitNet{ii})
            mywarndlg('All the units have to be defined!');
            get_unit(hObject, eventdata, handles);
            return;
        end
    end
end

unit_net = str2double(UnitNet);

for ii = 1 : layer
    if ~(unit_net(ii) >=1 )
        myerrordlg('The values of the units must be positive integers!');
        get_unit(hObject, eventdata, handles);
        return;
    end
end

infoText('Architecture successfully defined.')


% --- Executes on button press in SamplesImport.
function SamplesImport_Callback(hObject, eventdata, handles)
% hObject    handle to SamplesImport (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
infoText('Executed ''Import samples''');

global train_x train_y;
global sample_size_x sample_size_y;
global PrmStg;

[sample_filename_x, sample_pathname_x, file_is_get_x] = uigetfile('train_x.mat', 'Import input feature');
if file_is_get_x
    infoText('Input feature imported');
    
    [sample_filename_y, sample_pathname_y, file_is_get_y] = uigetfile('train_y.mat', 'Import predicted feature');
    if file_is_get_y
        infoText('Predicted feature imported');
        
        train_x = myload([sample_pathname_x sample_filename_x]);
        train_y = myload([sample_pathname_y sample_filename_y]);

        [sample_num_x, sample_size_x] = size(train_x);
        [sample_num_y, sample_size_y] = size(train_y);

        if sample_num_x ~= sample_num_y
            mywarndlg({'The number of input feature samples is inconsistent with the number of predicted feature samples. Please check carefully!'; ...
                        ['There are', num2str(sample_num_x), 'input feature samples and', num2str(sample_num_y), 'predicted feature samples']});
        else
            sample_num = sample_num_x;
            successStr = {[num2str(sample_num), ' samples are loaded.']; ...
                            ['The dimension of input feature is ', num2str(sample_size_x), '.']; ...
                            ['The dimension of predicted feature is ', num2str(sample_size_y), '.']};
            mymsgbox(successStr);
            for ii = 1 : 3
                infoText(successStr{ii});
            end
        end

        PrmStg.m_df = round(sample_num * 0.75);
        PrmStg.m_v_df = sample_num - PrmStg.m_df;
        
    else
        infoText('Predicted feature import is canceled');
    end
    
else
    infoText('Input feature import is canceled');
end
    


% --- Executes on button press in ParametersSetting.
function ParametersSetting_Callback(hObject, eventdata, handles)
% hObject    handle to ParametersSetting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
infoText('Executed ''Parameters setting''');
isPrmSet = ParameterSetting;
if isPrmSet
    set(handles.ParametersSetting, 'Userdata', 1);
end


% --- Executes on button press in Go.
function Go_Callback(hObject, eventdata, handles)
% hObject    handle to Go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
infoText('Executed ''main function''');

global train_x train_y sample_size_x sample_size_y;
global unit_net;

if isempty(train_x) || isempty(train_y) || isempty(sample_size_x) || isempty(sample_size_y)
    myerrordlg('Samples do not exist in the workspace. Please import samples first.');
    
elseif isempty(unit_net)
    myerrordlg('Architecture undifined. Please select architecture first.');
    
elseif ~get(handles.ParametersSetting, 'Userdata')
    myerrordlg('Training parameters undifined. Please finish ''ParameterSetting'' first.');
    
else
    set(handles.Go, 'FontSize', 20, 'String', 'Running...');
    mainFcn;
    set(handles.Go, 'FontSize', 40, 'String', 'Go!');
    
end


function TextDisp_Callback(hObject, eventdata, handles)
% hObject    handle to TextDisp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TextDisp as text
%        str2double(get(hObject,'String')) returns contents of TextDisp as a double


% --- Executes during object creation, after setting all properties.
function TextDisp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TextDisp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Skin_Callback(hObject, eventdata, handles)
% hObject    handle to Skin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BGNum;
try
    BG = dir('BGP');
    BGNum = BGNum + 1;
    if BGNum > length(BG) - 2
        BGNum = 1;
    end
    axes(handles.BGAxes);
    image(imread(['\BGP\', BG(BGNum + 2).name]));
    axis off;
end
