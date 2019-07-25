%Here is the code for interface of Task 1 made by Jinli Jin
%Please run the interface by using this code rater than open the
%"interface_task1.fig" directly
%in the interface, user can choose three input images by pressing the input 
% button. then input the SNR value, then press the estimation button, the
% estimation parameter will be shown. Finally, the output button will shown
% the receive image
function varargout = interface_task1(varargin)
% INTERFACE_TASK1 MATLAB code for interface_task1.fig
%      INTERFACE_TASK1, by itself, creates a new INTERFACE_TASK1 or raises the existing
%      singleton*.
%
%      H = INTERFACE_TASK1 returns the handle to a new INTERFACE_TASK1 or the handle to
%      the existing singleton*.
%
%      INTERFACE_TASK1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE_TASK1.M with the given input arguments.
%
%      INTERFACE_TASK1('Property','Value',...) creates a new INTERFACE_TASK1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interface_task1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interface_task1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interface_task1

% Last Modified by GUIDE v2.5 04-Jan-2019 14:42:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_task1_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_task1_OutputFcn, ...
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


% --- Executes just before interface_task1 is made visible.
function interface_task1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interface_task1 (see VARARGIN)

% Choose default command line output for interface_task1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interface_task1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interface_task1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in input.
function input_Callback(hObject, eventdata, handles)
% hObject    handle to input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filename1;
global filename2;
global filename3;
[filename1 pathname1] =uigetfile('.jpg','Input Image');
[filename2 pathname2] =uigetfile('.jpg','Input Image');
[filename3 pathname3] =uigetfile('.jpg','Input Image');
image1 = imread(filename1);
image2 = imread(filename2);
image3 = imread(filename3);
axes(handles.axes1);  
imshow(image1);
axes(handles.axes2);  
imshow(image2);
axes(handles.axes3);  
imshow(image3);


% --- Executes on button press in estimation.
function estimation_Callback(hObject, eventdata, handles)
% hObject    handle to estimation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filename1;
global filename2;
global filename3;
global image;
[signal1,x1,y1] = fImageSource(filename1,100*100*3*8);
[signal2,x2,y2] = fImageSource(filename2,100*100*3*8);
[signal3,x3,y3] = fImageSource(filename3,100*100*3*8);
%generate m-sequence
D2 = [1;1;0;0;1];%1+D+D4 from c4 to c0
D1 = [1;0;0;1;1];%1+D3+D4 from c4 to c0
mseq1=fMSeqGen(D1);
mseq2=fMSeqGen(D2);
%find out the gold sequence
surname=10; 
firstname=10;
shift = 1+mod(surname+firstname,12);
[GoldSeq1]=fGoldSeq(mseq1,mseq2,shift);
%find out the balance sequence
balance = sum(GoldSeq1);
while (balance~=-1)
    shift = shift+1;
    [GoldSeq1]=fGoldSeq(mseq1,mseq2,shift);
    balance = sum(GoldSeq1);
end
[GoldSeq2]=fGoldSeq(mseq1,mseq2,shift+1);
[GoldSeq3]=fGoldSeq(mseq1,mseq2,shift+2);
%QPSK
phi = surname +  2*firstname;
signal1_input = fDSQPSKModulator(signal1,GoldSeq1,phi);
signal2_input = fDSQPSKModulator(signal2,GoldSeq2,phi);
signal3_input = fDSQPSKModulator(signal3,GoldSeq3,phi);
signal_input = [signal1_input signal2_input signal3_input];%180000*3
%transformation parameters
paths = [1;2;3];
delay = [5;7;12];
beta = [0.4;0.7;0.2];
DOA = [30 0;90 0;150 0];
Snr = get(handles.snr,'string');
SNR = str2num(Snr);
% SNR = 40;
array = [];

[symbolsOut]=fChannel(paths,signal_input.',delay,beta,DOA,SNR,array);
[delay_estimate1, DOA_estimate1, beta_estimate1] = fChannelEstimation(symbolsOut, GoldSeq1);
set(handles.edit1,'string',delay_estimate1);
[bitsout]=fDSQPSKDemodulator(symbolsOut,GoldSeq1,phi,delay_estimate1);
%error judge
error = 0;
P = x1*y1*8*3;
for i = 1:P-6
    if bitsout(i,1)~= signal1(i,1)
       error = error+1;
    end
end
Q = x1*y1*8*3;
image = imagereceive(bitsout,Q,x1,y1);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in output.
function output_Callback(hObject, eventdata, handles)
% hObject    handle to output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image;
axes(handles.axes4);
imshow(image);



function snr_Callback(hObject, eventdata, handles)
% hObject    handle to snr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of snr as text
%        str2double(get(hObject,'String')) returns contents of snr as a double


% --- Executes during object creation, after setting all properties.
function snr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to snr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
