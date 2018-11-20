function varargout = ParameterSetting(varargin)
% PARAMETERSETTING MATLAB code for ParameterSetting.fig
%      PARAMETERSETTING, by itself, creates a new PARAMETERSETTING or raises the existing
%      singleton*.
%
%      H = PARAMETERSETTING returns the handle to a new PARAMETERSETTING or the handle to
%      the existing singleton*.
%
%      PARAMETERSETTING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARAMETERSETTING.M with the given input arguments.
%
%      PARAMETERSETTING('Property','Value',...) creates a new PARAMETERSETTING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ParameterSetting_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ParameterSetting_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ParameterSetting

% Last Modified by GUIDE v2.5 27-Sep-2018 20:09:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ParameterSetting_OpeningFcn, ...
                   'gui_OutputFcn',  @ParameterSetting_OutputFcn, ...
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


% --- Executes just before ParameterSetting is made visible.
function ParameterSetting_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ParameterSetting (see VARARGIN)

% Choose default command line output for ParameterSetting
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

movegui(gcf, 'center');

global PrmStg;
DefSet(PrmStg, hObject, eventdata, handles);

set(handles.figure1, 'Userdata', 0);
set(handles.CvgDtmBtn, 'Userdata', 0);
set(handles.AclOptBtn, 'Userdata', 0);
% UIWAIT makes ParameterSetting wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ParameterSetting_OutputFcn(hObject, eventdata, handles) 
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
global PrmStg PrmStgTmp;
OK_Check(hObject, eventdata, handles);
if strcmp(get(handles.OK, 'Userdata'), 'OK')
    PrmStg = PrmStgTmp;
    infoText('Finished ''Parameters setting''');
    set(handles.figure1, 'Userdata', 1);
    uiresume(handles.figure1);
end


% --- Executes on button press in Cancel.
function Cancel_Callback(hObject, eventdata, handles)
% hObject    handle to Cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);


function TotalStepEdit_Callback(hObject, eventdata, handles)
% hObject    handle to TotalStepEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TotalStepEdit as text
%        str2double(get(hObject,'String')) returns contents of TotalStepEdit as a double


% --- Executes during object creation, after setting all properties.
function TotalStepEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TotalStepEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function MEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MEdit as text
%        str2double(get(hObject,'String')) returns contents of MEdit as a double


% --- Executes during object creation, after setting all properties.
function MEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function MVEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MVEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MVEdit as text
%        str2double(get(hObject,'String')) returns contents of MVEdit as a double


% --- Executes during object creation, after setting all properties.
function MVEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MVEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function AlphaEdit_Callback(hObject, eventdata, handles)
% hObject    handle to AlphaEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AlphaEdit as text
%        str2double(get(hObject,'String')) returns contents of AlphaEdit as a double


% --- Executes during object creation, after setting all properties.
function AlphaEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AlphaEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in AlphaBtnGrp.
function AlphaBtnGrp_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in AlphaBtnGrp 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected object is changed in RestartBtnGrp.
function RestartBtnGrp_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in RestartBtnGrp 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
if get(handles.RestartRdoBtn, 'Value')
    set(handles.text11, 'Visible', 'on');
    set(handles.EpsilonEdit, 'Visible', 'on');
else
    set(handles.text11, 'Visible', 'off');
    set(handles.EpsilonEdit, 'Visible', 'off');
end


% --- Executes during object creation, after setting all properties.
function OptionalSettingPanel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OptionalSettingPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in LambdaCheck.
function LambdaCheck_Callback(hObject, eventdata, handles)
% hObject    handle to LambdaCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LambdaCheck
if get(handles.LambdaCheck, 'Value')
    set(handles.LambdaEdit, 'Visible', 'on');
else
    set(handles.LambdaEdit, 'Visible', 'off');
end


function LambdaEdit_Callback(hObject, eventdata, handles)
% hObject    handle to LambdaEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LambdaEdit as text
%        str2double(get(hObject,'String')) returns contents of LambdaEdit as a double


% --- Executes during object creation, after setting all properties.
function LambdaEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LambdaEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in MiniBatchCheck.
function MiniBatchCheck_Callback(hObject, eventdata, handles)
% hObject    handle to MiniBatchCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of MiniBatchCheck
if get(handles.MiniBatchCheck, 'Value')
    set(handles.MiniBatchEdit, 'Visible', 'on');
else
    set(handles.MiniBatchEdit, 'Visible', 'off');
end


function MiniBatchEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MiniBatchEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MiniBatchEdit as text
%        str2double(get(hObject,'String')) returns contents of MiniBatchEdit as a double


% --- Executes during object creation, after setting all properties.
function MiniBatchEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MiniBatchEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RateCheckStepCheck.
function RateCheckStepCheck_Callback(hObject, eventdata, handles)
% hObject    handle to RateCheckStepCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RateCheckStepCheck
if get(handles.RateCheckStepCheck, 'Value')
    set(handles.every1, 'Visible', 'on');
    set(handles.RateCheckStepEdit, 'Visible', 'on');
    set(handles.steps1, 'Visible', 'on');
else
    set(handles.every1, 'Visible', 'off');
    set(handles.RateCheckStepEdit, 'Visible', 'off');
    set(handles.steps1, 'Visible', 'off');
end


function RateCheckStepEdit_Callback(hObject, eventdata, handles)
% hObject    handle to RateCheckStepEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RateCheckStepEdit as text
%        str2double(get(hObject,'String')) returns contents of RateCheckStepEdit as a double


% --- Executes during object creation, after setting all properties.
function RateCheckStepEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RateCheckStepEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveStepCheck.
function SaveStepCheck_Callback(hObject, eventdata, handles)
% hObject    handle to SaveStepCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SaveStepCheck
if get(handles.SaveStepCheck, 'Value')
    set(handles.every2, 'Visible', 'on');
    set(handles.SaveStepEdit, 'Visible', 'on');
    set(handles.steps2, 'Visible', 'on');
else
    set(handles.every2, 'Visible', 'off');
    set(handles.SaveStepEdit, 'Visible', 'off');
    set(handles.steps2, 'Visible', 'off');
end


function SaveStepEdit_Callback(hObject, eventdata, handles)
% hObject    handle to SaveStepEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SaveStepEdit as text
%        str2double(get(hObject,'String')) returns contents of SaveStepEdit as a double


% --- Executes during object creation, after setting all properties.
function SaveStepEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SaveStepEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CvgDtmBtn.
function CvgDtmBtn_Callback(hObject, eventdata, handles)
% hObject    handle to CvgDtmBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
infoText('Executed ''Convergence determination''');
global PrmStgTmp;
PrmStgTmp.m = str2double(get(handles.MEdit, 'String'));
if get(handles.MiniBatchCheck, 'Value')
    PrmStgTmp.minibatch = str2double(get(handles.MiniBatchEdit, 'String'));
    if PrmStgTmp.minibatch > PrmStgTmp.m
        PrmStgTmp.minibatch = PrmStgTmp.m;
    end
else
    PrmStgTmp.minibatch = PrmStgTmp.m;
end
isCvgDtmFinished = ConvergenceDetermination;
if isCvgDtmFinished
    set(handles.CvgDtmBtn, 'Userdata', 1);
end


% --- Executes on button press in AclOptBtn.
function AclOptBtn_Callback(hObject, eventdata, handles)
% hObject    handle to AclOptBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
infoText('Executed ''Acceleration options''');
isAclOptFinished = AccelerationOptions;
if isAclOptFinished
    set(handles.AclOptBtn, 'Userdata', 1);
end


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function LoadSettings_Callback(hObject, eventdata, handles)
% hObject    handle to LoadSettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PrmStgTmp;
[PrmStgFileName, PrmStgPathName, isFileGot] = uigetfile('ParameterSetting.mat', 'Load Settings');
if isFileGot
    PrmStgTmpTmp = myload([PrmStgPathName, PrmStgFileName]);
    if isstruct(PrmStgTmpTmp)
        PrmStgTmp = PrmStgTmpTmp;
        infoText(['Loaded parameter settings. ', PrmStgPathName, PrmStgFileName]);
        DefSet(PrmStgTmp, hObject, eventdata, handles);
    end
end


% --------------------------------------------------------------------
function SaveSettings_Callback(hObject, eventdata, handles)
% hObject    handle to SaveSettings (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PrmStgTmp;
OK_Check(hObject, eventdata, handles);
if strcmp(get(handles.OK, 'Userdata'), 'OK')
    [PrmStgFileName, PrmStgPathName, isFilePut] = uiputfile('*.mat', 'Save Settings', [pwd, '\PrmStg\ParameterSetting']);
    if isFilePut
        save([PrmStgPathName, PrmStgFileName], 'PrmStgTmp');
        infoText(['Saveed parameter settings. ', PrmStgPathName, PrmStgFileName]);
    end
end


function EpsilonEdit_Callback(hObject, eventdata, handles)
% hObject    handle to EpsilonEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EpsilonEdit as text
%        str2double(get(hObject,'String')) returns contents of EpsilonEdit as a double


% --- Executes during object creation, after setting all properties.
function EpsilonEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EpsilonEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Default.
function Default_Callback(hObject, eventdata, handles)
% hObject    handle to Default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DefSet({}, hObject, eventdata, handles);

function DefSet(PrmStg, hObject, eventdata, handles)
setDefNum(handles.TotalStepEdit, PrmStg, 'totalStep', 'Inf');
setDefNum(handles.MEdit, PrmStg, 'm', '', PrmStg, 'm_df');
setDefNum(handles.MVEdit, PrmStg, 'm_v', '', PrmStg, 'm_v_df');
setDefNum(handles.AlphaEdit, PrmStg, 'alpha', '0.01');
setDefRdo(handles.AlphaAvgBtn, handles.AlphaSumBtn, 'alphaMode', 'Average');
setDefRdo(handles.RestartRdoBtn, handles.ResumeRdoBtn, 'restartMode', 'Restart');
RestartBtnGrp_SelectionChangeFcn(hObject, eventdata, handles);
setDefNum(handles.EpsilonEdit, PrmStg, 'epsilon', '0.1');
LambdaCheckCbHd = @LambdaCheck_Callback;
setDefChk(handles.LambdaCheck, PrmStg, 'lambdaOpt', LambdaCheckCbHd, hObject, eventdata, handles);
setDefNum(handles.LambdaEdit, PrmStg, 'lambda');
MiniBatchCheckCbHd = @MiniBatchCheck_Callback;
setDefChk(handles.MiniBatchCheck, PrmStg, 'minibatchOpt', MiniBatchCheckCbHd, hObject, eventdata, handles);
setDefNum(handles.MiniBatchEdit, PrmStg, 'minibatch', '64');
RateCheckStepCheckCbHd = @RateCheckStepCheck_Callback;
setDefChk(handles.RateCheckStepCheck, PrmStg, 'rateCheckOpt', RateCheckStepCheckCbHd, hObject, eventdata, handles);
setDefNum(handles.RateCheckStepEdit, PrmStg, 'rateCheckStep', '10');
SaveStepCheckCbHd = @SaveStepCheck_Callback;
setDefChk(handles.SaveStepCheck, PrmStg, 'autoSaveOpt', SaveStepCheckCbHd, hObject, eventdata, handles);
setDefNum(handles.SaveStepEdit, PrmStg, 'saveStep', '20');

function OK_Check(hObject, eventdata, handles)
global PrmStgTmp;
global sample_num;

if isempty(sample_num)
    SampleNum = sample_num;
else
    SampleNum = inf;
end

set(handles.OK, 'Userdata', 'OK');

PrmStgTmp.totalStep = getIntNum(handles.TotalStepEdit, handles.OK);

PrmStgTmp.m = getIntNum(handles.MEdit, handles.OK);
if strcmp(get(handles.OK, 'Userdata'), 'OK')
    if PrmStgTmp.m > SampleNum
        myerrordlg('The number of samples planned to be used as training set is higher than the total number of samples already in possession!');
        set(handles.OK, 'Userdata', 'WRONG');
    end
end

PrmStgTmp.m_v = getIntNum(handles.MVEdit, handles.OK);
if strcmp(get(handles.OK, 'Userdata'), 'OK')
    if PrmStgTmp.m_v > SampleNum
        myerrordlg('The number of samples planned to be used as validation set is higher than the total number of samples already in possession!');
        set(handles.OK, 'Userdata', 'WRONG');
    end
    if PrmStgTmp.m + PrmStgTmp.m_v > SampleNum
        mywarndlg(['The total number of samples in the training and validation sets exceeds the total number of samples already in possession,' ...
            'which causes the samples of the training and validation sets to overlap.']);
        set(handles.OK, 'Userdata', 'WRONG');
    end
end

PrmStgTmp.alpha = getNum(handles.AlphaEdit, handles.OK);
if get(handles.AlphaSumBtn, 'Value')
	PrmStgTmp.alphaDis = PrmStgTmp.alpha * PrmStgTmp.m;
    PrmStgTmp.alphaMode = 'Sum';
else
    PrmStgTmp.alphaDis = PrmStgTmp.alpha;
    PrmStgTmp.alphaMode = 'Average';
end

if get(handles.RestartRdoBtn, 'Value')
    PrmStgTmp.restart = 1;
    PrmStgTmp.restartMode = 'Restart';
else
    PrmStgTmp.restart = 0;
    PrmStgTmp.restartMode = 'Resume';
end

PrmStgTmp.epsilon = getNmlNum(handles.EpsilonEdit, handles.OK);

if get(handles.LambdaCheck, 'Value')
    PrmStgTmp.lambda = getNmlNum(handles.LambdaEdit, handles.OK);
    PrmStgTmp.lambdaOpt = 1;
else
    PrmStgTmp.lambda = 0;
    PrmStgTmp.lambdaOpt = 0;
end

if get(handles.MiniBatchCheck, 'Value')
    PrmStgTmp.minibatch = getIntNum(handles.MiniBatchEdit, handles.OK);
    PrmStgTmp.minibatchOpt = 1;
    if  strcmp(get(handles.OK, 'Userdata'), 'OK') 
        if PrmStgTmp.minibatch > PrmStgTmp.m
            mywarndlg('The value of Mini-Batch is higher than the number of samples in the training set.');
            set(handles.OK, 'Userdata', 'WRONG');
        end
    end
else
    PrmStgTmp.minibatch = PrmStgTmp.m;
    PrmStgTmp.minibatchOpt = 0;
end

if get(handles.RateCheckStepCheck, 'Value')
    PrmStgTmp.rateCheckStep = getIntNum(handles.RateCheckStepEdit, handles.OK);
    PrmStgTmp.rateCheckOpt = 1;
else
    PrmStgTmp.rateCheckStep = PrmStgTmp.m + 1;
    PrmStgTmp.rateCheckOpt = 0;
end

if get(handles.SaveStepCheck, 'Value')
    PrmStgTmp.saveStep = getIntNum(handles.SaveStepEdit, handles.OK);
    PrmStgTmp.autoSaveOpt = 1;
else
    PrmStgTmp.saveStep = PrmStgTmp.m + 1;
    PrmStgTmp.autoSaveOpt = 0;
end
