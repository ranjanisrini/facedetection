function varargout = MAIN_Program(varargin)
% MAIN_PROGRAM MATLAB code for MAIN_Program.fig
%      MAIN_PROGRAM, by itself, creates a new MAIN_PROGRAM or raises the existing
%      singleton*.
%
%      H = MAIN_PROGRAM returns the handle to a new MAIN_PROGRAM or the handle to
%      the existing singleton*.
%
%      MAIN_PROGRAM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_PROGRAM.M with the given input arguments.
%
%      MAIN_PROGRAM('Property','Value',...) creates a new MAIN_PROGRAM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MAIN_Program_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MAIN_Program_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MAIN_Program

% Last Modified by GUIDE v2.5 13-Mar-2017 02:13:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MAIN_Program_OpeningFcn, ...
                   'gui_OutputFcn',  @MAIN_Program_OutputFcn, ...
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


% --- Executes just before MAIN_Program is made visible.
function MAIN_Program_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MAIN_Program (see VARARGIN)

% Choose default command line output for MAIN_Program
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MAIN_Program wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MAIN_Program_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[ vfilename, vpathname ] = uigetfile( 'dataset\*.avi', 'Select an video' );
I=VideoReader(strcat( vpathname, vfilename ));
nFrames = I.numberofFrames;
handles.nFrames=nFrames;
handles.I=I;
handles.vpathname=vpathname;
handles.vfilename=vfilename;
guidata(hObject, handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nFrames=handles.nFrames;
I=handles.I;
vpathname=handles.vpathname;
vfilename=handles.vfilename;
vidHeight =  I.Height;
vidWidth =  I.Width;
mov(1:nFrames) = ...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
           'colormap', []);
for k = 1: nFrames
    mov(k).cdata = read( I, k);
   mov(k).cdata = imresize(mov(k).cdata,[256,256]);
    imwrite(mov(k).cdata,['Frames\',num2str(k),'.jpg']);
end
mov(1:nFrames) = ...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
           'colormap', []);
for k = 1: nFrames
    mov(k).cdata = read( I, k);
    imwrite(mov(k).cdata,['Frames\',num2str(k),'.jpg']);
 end
for i = 1:80
    im=imread(['Frames\',num2str(i),'.jpg']); 
    figure(1)
    subplot(8,10,i),imshow(im);
    axis off;
end
title('Frame conversion');
for i = 1: 1
 im=imread(['Frames\',num2str(i),'.jpg']); 
axes(handles.one);
imshow(im);
end
title('Original Image');
faceDetector = vision.CascadeObjectDetector;

for i = 1: nFrames
 im=imread(['Frames\',num2str(i),'.jpg']);
 bbox= step(faceDetector, im);
 Faces = insertObjectAnnotation(im, 'rectangle', bbox, 'Face');
   axes(handles.two); imshow(Faces),title('Detected faces');
end

handles.i=i;
handles.bbox=bbox;
handles.im=im;
handles.Faces=Faces;
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

im=handles.im;
bbox=handles.bbox;
Faces=handles.Faces;
a=imread(['Frames\',num2str(3),'.jpg']);
G=imcrop(im,bbox);axes(handles.three);imshow(G);title('Cropped Face');
b=a;
handles.b=b;
guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
vpathname=handles.vpathname;
vfilename=handles.vfilename;
b=handles.b;
kalmanFilter(vpathname, vfilename);
A = imnoise(b,'salt & pepper', 0.05);
redChannel = A(:, :, 1);
greenChannel =A(:, :, 2);
blueChannel = A(:, :, 3);
redMF = medfilt2(redChannel, [3 3]);
greenMF = medfilt2(greenChannel, [3 3]);
blueMF = medfilt2(blueChannel, [3 3]);
x=fft(redMF);
y=fft(greenMF);
z=fft(blueMF);
M=mean(x);M1=mean(y);M2=mean(z);
BCG=(mean([M,M1,M2]-80));
handles.BCG=BCG;
guidata(hObject, handles);




% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
b=handles.b;
vfilename=handles.vfilename;
BCG=handles.BCG;
red = b(:,:,1);
green =b(:,:,2); 
blue = b(:,:,3);
a = zeros(size(b, 1), size(b, 2));
just_red = cat(3, red, a, a);
just_green = cat(3, a, green, a);
just_blue = cat(3, a, a, blue);
axes(handles.one); imshow(just_red), title('Red plane');
axes(handles.two); imshow(just_green), title('Green plane');
axes(handles.three); imshow(just_blue), title('Blue plane');
R=mean2(just_red);
G=mean2(just_green);
B=mean2(just_green);
PPG=(R+G);
PPG
handles.b=b;
handles.red=red;
handles.green=green;
handles.blue=blue;
guidata(hObject, handles);
filename = 'Database.xls';
A = {'BCG:',BCG;'PPG:',PPG;};
sheet = vfilename;
xlRange = 'A2';
xlswrite(filename,A,sheet,xlRange)
msgbox(sprintf('BCG= %2.3g\nPPG = %2.3g',BCG,PPG),'BCG&PPG')
if(BCC>120||PPG>110);
    {
        warndlg('BCG or PPG high Please Check','!! Warning !!')
}
else
    {
        msgbox(sprintf('BCG= %2.3g\nPPG = %2.3g',BCG,PPG),'BCG&PPG')
        }
end




% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
clear all;
close all;
