function varargout = IRFinalProject(varargin)
% IRFINALPROJECT MATLAB code for IRFinalProject.fig
%      IRFINALPROJECT, by itself, creates a new IRFINALPROJECT or raises the existing
%      singleton*.
%
%      H = IRFINALPROJECT returns the handle to a new IRFINALPROJECT or the handle to
%      the existing singleton*.
%
%      IRFINALPROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IRFINALPROJECT.M with the given input arguments.
%
%      IRFINALPROJECT('Property','Value',...) creates a new IRFINALPROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before IRFinalProject_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to IRFinalProject_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help IRFinalProject

% Last Modified by GUIDE v2.5 02-Jan-2017 15:44:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @IRFinalProject_OpeningFcn, ...
                   'gui_OutputFcn',  @IRFinalProject_OutputFcn, ...
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


% --- Executes just before IRFinalProject is made visible.
function IRFinalProject_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to IRFinalProject (see VARARGIN)

% Choose default command line output for IRFinalProject
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes IRFinalProject wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = IRFinalProject_OutputFcn(hObject, eventdata, handles) 
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
vocab_size = 500;
data_path = 'E:/CaoHoc/ComputerVision/source code/dataset';
vl_feat = 'E:/CaoHoc/ComputerVision/source code/vlfeat-0.9.20/toolbox/vl_setup';
[filename, pathname] = uigetfile( ...
{'*.jpg;*.mlx;*.fig;*.mat;*.slx;*.mdl',...
   'All Files (*.*)'},'mytitle',...
          'E:/CaoHoc/ComputerVision/source code/dataset');
imgQueryPath = fullfile(pathname, filename);
Selected_Image = imread(imgQueryPath);
imshow(Selected_Image, 'Parent', handles.axes1);
run(vl_feat);
imgListPath = getTrainImgPath(data_path);
listDatasetImage = getDatasetImgPath(data_path);
db_size = size(listDatasetImage,1);
%build visual vocabulary
if ~exist('visualVocabulary.mat', 'file')
    fprintf('Create visual word vocabulary \n')
    vocab = createTrainVocabulary(imgListPath, vocab_size );
    save('visualVocabulary.mat', 'vocab')
end

%build vetors space model
if ~exist('imgvectors.mat', 'file')
    fprintf('Create vector frequency...\n')
    [imgvectors, vocab_frequencies_in_DB] = createVisualWord(listDatasetImage);
    save('imgvectors.mat', 'imgvectors');
    save('vocaFrequen.mat', 'vocab_frequencies_in_DB');
end

load('imgvectors.mat');
query_vector = createQueryVector(imgQueryPath, db_size);

%get ranked list result
ranked_list =  getCosineValue(imgListPath, query_vector, db_size);
[Y,I]=sort([ranked_list{2,:}], 'descend');
descending_ranked_list = ranked_list(:,I);

rankValue=descending_ranked_list(2,:);  
listImg=descending_ranked_list(1,:);
position=[handles.text2, handles.text3, handles.text4, handles.text5, handles.text6, handles.text7, handles.text8, handles.text9, handles.text10];
images=[handles.axes2, handles.axes3, handles.axes4, handles.axes5, handles.axes6, handles.axes7, handles.axes8, handles.axes9, handles.axes10]

for n=1:9
    abc=rankValue{n};
    textLabel = sprintf('%d', abc);
    set(position(n), 'String', textLabel);
    imagePath = listImg{n};
    Selected_Image = imread(imagePath);
    imshow(Selected_Image, 'Parent', images(n));
end
