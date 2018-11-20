function varargout = ConvergenceDetermination(varargin)
% CONVERGENCEDETERMINATION MATLAB code for ConvergenceDetermination.fig
%      CONVERGENCEDETERMINATION, by itself, creates a new CONVERGENCEDETERMINATION or raises the existing
%      singleton*.
%
%      H = CONVERGENCEDETERMINATION returns the handle to a new CONVERGENCEDETERMINATION or the handle to
%      the existing singleton*.
%
%      CONVERGENCEDETERMINATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONVERGENCEDETERMINATION.M with the given input arguments.
%
%      CONVERGENCEDETERMINATION('Property','Value',...) creates a new CONVERGENCEDETERMINATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ConvergenceDetermination_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ConvergenceDetermination_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ConvergenceDetermination

% Last Modified by GUIDE v2.5 13-Sep-2018 17:10:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ConvergenceDetermination_OpeningFcn, ...
                   'gui_OutputFcn',  @ConvergenceDetermination_OutputFcn, ...
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


% --- Executes just before ConvergenceDetermination is made visible.
function ConvergenceDetermination_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ConvergenceDetermination (see VARARGIN)

% Choose default command line output for ConvergenceDetermination
handles.output = hObject;

movegui(gcf, 'center');

global PrmStg PrmStgTmp;

AlphaAutoReduceCheckCbHd = @AlphaAutoReduceCheck_Callback;
setDefChk(handles.AlphaAutoReduceCheck, PrmStgTmp, 'alphaAutoReduceOpt', AlphaAutoReduceCheckCbHd, hObject, eventdata, handles, PrmStg);
setDefNum(handles.JReduceRateEdit, PrmStgTmp, 'JReduceRate', '0.96', PrmStg);
try
    defJReduceCheckStep = num2str(2 * ceil(PrmStgTmp.m / PrmStgTmp.minibatch));
catch
    try
        defJReduceCheckStep = num2str(2 * ceil(PrmStg.m_df / PrmStgTmp.minibatch));
    catch
        defJReduceCheckStep = '10';
    end
end
setDefNum(handles.JReduceCheckStepEdit, PrmStgTmp, 'JReduceCheckStep', defJReduceCheckStep, PrmStg);
setDefNum(handles.AlphaReduceRateEdit, PrmStgTmp, 'alphaReduceRate', '0.3', PrmStg);
AccuracyAimCheckCbHd = @AccuracyAimCheck_Callback;
setDefChk(handles.AccuracyAimCheck, PrmStgTmp, 'acyAimOpt', AccuracyAimCheckCbHd, hObject, eventdata, handles, PrmStg);
setDefNum(handles.AccuracyAimEdit, PrmStgTmp, 'accuracyAim', '0.99', PrmStg);
MinimumAlphaCheckCbHd = @MinimumAlphaCheck_Callback;
setDefChk(handles.MinimumAlphaCheck, PrmStgTmp, 'minAlphaOpt', MinimumAlphaCheckCbHd, hObject, eventdata, handles, PrmStg);
setDefNum(handles.MinimumAlphaEdit, PrmStgTmp, 'minAlpha', '1e-5', PrmStg);

set(handles.figure1, 'Userdata', 0);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ConvergenceDetermination wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ConvergenceDetermination_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = get(handles.figure1, 'Userdata');
delete(gcf);


% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PrmStgTmp;
set(handles.OK, 'Userdata', 'OK');

if get(handles.AlphaAutoReduceCheck, 'Value')
    PrmStgTmpTmp.JReduceRate = getNmlNum(handles.JReduceRateEdit, handles.OK);
    PrmStgTmpTmp.JReduceCheckStep = getIntNum(handles.JReduceCheckStepEdit, handles.OK);
    PrmStgTmpTmp.alphaReduceRate = getNmlNum(handles.AlphaReduceRateEdit, handles.OK);
    PrmStgTmpTmp.alphaAutoReduceOpt = 1;
else
    PrmStgTmpTmp.JReduceRate = 1;
    PrmStgTmpTmp.JReduceCheckStep = inf;
    PrmStgTmpTmp.alphaReduceRate = 1;
    PrmStgTmpTmp.alphaAutoReduceOpt = 0;
end

if get(handles.AccuracyAimCheck, 'Value')
    PrmStgTmpTmp.accuracyAim = getNmlNum(handles.AccuracyAimEdit, handles.OK);
    PrmStgTmpTmp.acyAimOpt = 1;
else
    PrmStgTmpTmp.accuracyAim = 1;
    PrmStgTmpTmp.acyAimOpt = 0;
end    

if get(handles.MinimumAlphaCheck, 'Value')
    PrmStgTmpTmp.minAlphaOpt = 1;
    if get(handles.AlphaAutoReduceCheck, 'Value')
        PrmStgTmpTmp.minAlpha = getNum(handles.MinimumAlphaEdit, handles.OK);
    else
        PrmStgTmpTmp.minAlpha = 0;
    end
else
    PrmStgTmpTmp.minAlphaOpt = 0;
end

if strcmp(get(handles.OK, 'Userdata'), 'OK')
    fn = fieldnames(PrmStgTmpTmp);
    for ii = 1 : length(fn)
        PrmStgTmp.(fn{ii}) = PrmStgTmpTmp.(fn{ii});
    end
    infoText('Finished ''Convergence determination''');
    set(handles.figure1, 'Userdata', 1);
    uiresume(handles.figure1);
end

% --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);


% --- Executes on button press in AlphaAutoReduceCheck.
function AlphaAutoReduceCheck_Callback(hObject, eventdata, handles)
% hObject    handle to AlphaAutoReduceCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AlphaAutoReduceCheck
if get(handles.AlphaAutoReduceCheck, 'Value')
    set(handles.JReduceRateEdit, 'Enable', 'on');
    set(handles.JReduceCheckStepEdit, 'Enable', 'on');
    set(handles.AlphaReduceRateEdit, 'Enable', 'on');
    set(handles.MinimumAlphaCheck, 'Enable', 'on');
else
    set(handles.JReduceRateEdit, 'Enable', 'off');
    set(handles.JReduceCheckStepEdit, 'Enable', 'off');
    set(handles.AlphaReduceRateEdit, 'Enable', 'off');
    set(handles.MinimumAlphaCheck, 'Enable', 'off');
end
if get(handles.AlphaAutoReduceCheck, 'Value') && get(handles.MinimumAlphaCheck, 'Value')
    set(handles.MinimumAlphaEdit, 'Enable', 'on');
else
    set(handles.MinimumAlphaEdit, 'Enable', 'off');
end


% --- Executes during object creation, after setting all properties.
function JReduceRateEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to JReduceRateEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function JReduceRateEdit_Callback(hObject, eventdata, handles)
% hObject    handle to JReduceRateEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of JReduceRateEdit as text
%        str2double(get(hObject,'String')) returns contents of JReduceRateEdit as a double


% --- Executes during object creation, after setting all properties.
function JReduceCheckStepEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to JReduceCheckStepEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function JReduceCheckStepEdit_Callback(hObject, eventdata, handles)
% hObject    handle to JReduceCheckStepEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of JReduceCheckStepEdit as text
%        str2double(get(hObject,'String')) returns contents of JReduceCheckStepEdit as a double


% --- Executes during object creation, after setting all properties.
function AlphaReduceRateEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AlphaReduceRateEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function AlphaReduceRateEdit_Callback(hObject, eventdata, handles)
% hObject    handle to AlphaReduceRateEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AlphaReduceRateEdit as text
%        str2double(get(hObject,'String')) returns contents of AlphaReduceRateEdit as a double


% --- Executes on button press in AccuracyAimCheck.
function AccuracyAimCheck_Callback(hObject, eventdata, handles)
% hObject    handle to AccuracyAimCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of AccuracyAimCheck
if get(handles.AccuracyAimCheck, 'Value')
    set(handles.AccuracyAimEdit, 'Enable', 'on');
else
    set(handles.AccuracyAimEdit, 'Enable', 'off');
end


% --- Executes during object creation, after setting all properties.
function AccuracyAimEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AccuracyAimEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function AccuracyAimEdit_Callback(hObject, eventdata, handles)
% hObject    handle to AccuracyAimEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AccuracyAimEdit as text
%        str2double(get(hObject,'String')) returns contents of AccuracyAimEdit as a double


% --- Executes on button press in MinimumAlphaCheck.
function MinimumAlphaCheck_Callback(hObject, eventdata, handles)
% hObject    handle to MinimumAlphaCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MinimumAlphaCheck
if get(handles.MinimumAlphaCheck, 'Value')
    set(handles.MinimumAlphaEdit, 'Enable', 'on');
else
    set(handles.MinimumAlphaEdit, 'Enable', 'off');
end


% --- Executes during object creation, after setting all properties.
function MinimumAlphaEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinimumAlphaEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function MinimumAlphaEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MinimumAlphaEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MinimumAlphaEdit as text
%        str2double(get(hObject,'String')) returns contents of MinimumAlphaEdit as a double
