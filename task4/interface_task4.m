%Here is the code for interface of Task 1 made by Jinli Jin
%Please run the interface by using this code rater than open the
%"interface_task1,fig" directly
%Firstly, the user should press the estimate button, the estimation
%parameters value will be shown. Then, press the output button, the receive
%message will be shown.
function varargout = interface_task4(varargin)
% INTERFACE_TASK4 MATLAB code for interface_task4.fig
%      INTERFACE_TASK4, by itself, creates a new INTERFACE_TASK4 or raises the existing
%      singleton*.
%
%      H = INTERFACE_TASK4 returns the handle to a new INTERFACE_TASK4 or the handle to
%      the existing singleton*.
%
%      INTERFACE_TASK4('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE_TASK4.M with the given input arguments.
%
%      INTERFACE_TASK4('Property','Value',...) creates a new INTERFACE_TASK4 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interface_task4_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interface_task4_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interface_task4

% Last Modified by GUIDE v2.5 04-Jan-2019 15:40:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_task4_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_task4_OutputFcn, ...
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


% --- Executes just before interface_task4 is made visible.
function interface_task4_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interface_task4 (see VARARGIN)

% Choose default command line output for interface_task4
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interface_task4 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interface_task4_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function delay_Callback(hObject, eventdata, handles)
% hObject    handle to delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delay as text
%        str2double(get(hObject,'String')) returns contents of delay as a double


% --- Executes during object creation, after setting all properties.
function delay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DOA_Callback(hObject, eventdata, handles)
% hObject    handle to DOA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DOA as text
%        str2double(get(hObject,'String')) returns contents of DOA as a double


% --- Executes during object creation, after setting all properties.
function DOA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DOA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DOA2_Callback(hObject, eventdata, handles)
% hObject    handle to DOA2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DOA2 as text
%        str2double(get(hObject,'String')) returns contents of DOA2 as a double


% --- Executes during object creation, after setting all properties.
function DOA2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DOA2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in estimation.
function estimation_Callback(hObject, eventdata, handles)
% hObject    handle to estimation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Message;
load('jj4218.mat');
[m,n] = size(Xmatrix);
D1 = [1;0;0;1;0;1];
D2 = [1;0;1;1;1;1];
mseq1=fMSeqGen(D1);
mseq2=fMSeqGen(D2);
[GoldSeq]=fGoldSeq(mseq1,mseq2,phase_shift);
Nc = length(GoldSeq);
co=0.5/sin(frad(36));
array = [];
for i=1:5
	gamma=frad(30+72*(i-1));
    array=[array;co*cos(gamma),co*sin(gamma),0 ];
end
%estimation
[delay_estimate, DOA_estimate] = fChannelEstimation_t4(Xmatrix,GoldSeq,array);
delay_str = num2str(delay_estimate');
set(handles.delay,'string',delay_str);
DOA_str = num2str(DOA_estimate(:,1)');
set(handles.DOA,'string',DOA_str);
DOA2_str = num2str(DOA_estimate(:,2)');
set(handles.DOA2,'string',DOA2_str);
%spatiotemporal beamformers
J = [zeros(2*Nc-1,1)' 0; eye(2*Nc-1) zeros(2*Nc-1,1)];
c = [GoldSeq;zeros(Nc,1)];
S1 = spv(array,DOA_estimate(1,:));
S2 = spv(array,DOA_estimate(2,:));
S3 = spv(array,DOA_estimate(3,:));
Jc1 = J^delay_estimate(1)*c;
Jc2 = J^delay_estimate(2)*c;
Jc3 = J^delay_estimate(3)*c;
h1 = kron(S1,Jc1);
h2 = kron(S2,Jc2);
h3 = kron(S3,Jc3);
H = [h1,h2,h3];
w = H*Beta_1;
coe1 = 2*Nc*1;
for i=1:m
    temp=reshape(Xmatrix(i,:),[Nc,n/Nc]);
    expand_s=kron(temp,ones(1,2));
    X(coe1*(i-1)+1:coe1*i,:)=reshape(expand_s(:,2:end-1),[coe1,(n-Nc)/Nc]);
end
signal = w'*X;
%demodulator
[bitsout]=Demodulator(signal.',GoldSeq,phi_mod);
Q = length(bitsout);
bit = reshape(bitsout,[8,60]);
ASC = bi2de(bit','left-msb');
message = char(ASC);
Message = message';


% --- Executes on button press in output.
function output_Callback(hObject, eventdata, handles)
% hObject    handle to output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Message;
set(handles.message,'string',Message);


function message_Callback(hObject, eventdata, handles)
% hObject    handle to message (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of message as text
%        str2double(get(hObject,'String')) returns contents of message as a double


% --- Executes during object creation, after setting all properties.
function message_CreateFcn(hObject, eventdata, handles)
% hObject    handle to message (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
