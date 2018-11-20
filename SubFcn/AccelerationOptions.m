function varargout = AccelerationOptions(varargin)
% ACCELERATIONOPTIONS MATLAB code for AccelerationOptions.fig
%      ACCELERATIONOPTIONS, by itself, creates a new ACCELERATIONOPTIONS or raises the existing
%      singleton*.
%
%      H = ACCELERATIONOPTIONS returns the handle to a new ACCELERATIONOPTIONS or the handle to
%      the existing singleton*.
%
%      ACCELERATIONOPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ACCELERATIONOPTIONS.M with the given input arguments.
%
%      ACCELERATIONOPTIONS('Property','Value',...) creates a new ACCELERATIONOPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AccelerationOptions_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AccelerationOptions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AccelerationOptions

% Last Modified by GUIDE v2.5 17-Sep-2018 16:34:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AccelerationOptions_OpeningFcn, ...
                   'gui_OutputFcn',  @AccelerationOptions_OutputFcn, ...
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


% --- Executes just before AccelerationOptions is made visible.
function AccelerationOptions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AccelerationOptions (see VARARGIN)

% Choose default command line output for AccelerationOptions
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

movegui(gcf, 'center');

global PrmStg PrmStgTmp;

setDefChk(handles.GPUOpt, PrmStgTmp, 'GPUOpt', PrmStg);
MultiCoreOptHd = @MultiCoreOpt_Callback;
setDefChk(handles.MultiCoreOpt, PrmStgTmp, 'MultiCoreOpt', MultiCoreOptHd, hObject, eventdata, handles, PrmStg);
setDefNum(handles.coreNumEdit, PrmStgTmp, 'coreNum', '4', PrmStg);

set(handles.figure1, 'Userdata', 0);
% UIWAIT makes AccelerationOptions wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = AccelerationOptions_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = get(handles.figure1, 'Userdata');
delete(gcf);


% --- Executes on button press in GPUOpt.
function GPUOpt_Callback(hObject, eventdata, handles)
% hObject    handle to GPUOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GPUOpt


% --- Executes on button press in MultiCoreOpt.
function MultiCoreOpt_Callback(hObject, eventdata, handles)
% hObject    handle to MultiCoreOpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MultiCoreOpt
if get(handles.MultiCoreOpt, 'Value')
    set(handles.text1, 'Visible', 'on');
    set(handles.coreNumEdit, 'Visible', 'on');
else
    set(handles.text1, 'Visible', 'off');
    set(handles.coreNumEdit, 'Visible', 'off');
end


function coreNumEdit_Callback(hObject, eventdata, handles)
% hObject    handle to coreNumEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of coreNumEdit as text
%        str2double(get(hObject,'String')) returns contents of coreNumEdit as a double


% --- Executes during object creation, after setting all properties.
function coreNumEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to coreNumEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PrmStgTmp;
set(handles.OK, 'Userdata', 'OK');

if get(handles.GPUOpt, 'Value')
    PrmStgTmpTmp.GPUOpt = 1;
else
    PrmStgTmpTmp.GPUOpt = 0;
end

if get(handles.MultiCoreOpt, 'Value')
    PrmStgTmpTmp.MultiCoreOpt = 1;
    PrmStgTmpTmp.coreNum = getIntNum(handles.coreNumEdit, handles.OK);
else
    PrmStgTmpTmp.MultiCoreOpt = 0;
    PrmStgTmpTmp.coreNum = 0;
end

if strcmp(get(handles.OK, 'Userdata'), 'OK')
    fn = fieldnames(PrmStgTmpTmp);
    for ii = 1 : length(fn)
        PrmStgTmp.(fn{ii}) = PrmStgTmpTmp.(fn{ii});
    end
    infoText('Finished ''Acceleration options''');
    set(handles.figure1, 'Userdata', 1);
    uiresume(handles.figure1);
end


% --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
uiresume(handles.figure1);
