function varargout =IrisRecognitionSecuritySystem(varargin) 
global v vh hfig
if nargin==0; 
close all % close all figures (windows) 
hfig=openfig(mfilename,'reuse','visible'); 
set(hfig,'handlevisibility','on','doublebuffer','on') 
vh=guihandles(hfig);
guidata(hfig,vh)
setappdata(0,'hfig',vh)
vh.menu=uimenu('label','About What this GUI?');
vh.menu(2)=uimenu(vh.menu(1),'label','This is a simplified GUI designed for Iris Recognition purpose,it is consists of many pushbuttons ,and one axes to display the image on it.');
uistack(vh.axes1,'bottom');
img=imread('newtech1.jpg');
eye=image(img);
set(eye,'alphadata',.80)
set(vh.axes1,'handlevisibility','off','visible','off')

if nargout>0;
    varargout{1}=hfig;
end 

elseif ischar(varargin{1}) 
try; if (nargout); [varargout{1:nargout}] = feval(varargin{:}); 
else; feval(varargin{:}); end 
catch; disp(lasterr); end 
end % nargin
%---------------------------------------------------------------------
function Exit(varargin) % callback for close pushbutton 
global v vh hfig % declare global variables 
pos_size=get(IrisRecognitionSecuritySystem,'Position');
user_response= modaldlg('Title', 'Confirm Close');
switch user_response
    case ('No')
        %take no action
    case 'Yes'
        %prepare to close GUI application window
        %
        %
        %
        delete(IrisRecognitionSecuritySystem)
        setappdata(0,'hfig',[])
end
%------------------------------------------------------------------ 
function Capture(varargin) 
global v vh hfig
set(vh.uipanel2,'visible','off');
set(vh.pushbutton2,'enable','off');
set(vh.pushbutton3,'enable','off');
set(vh.pushbutton4,'enable','off');
set(vh.pushbutton5,'enable','off');
set(vh.pushbutton6,'enable','off');
set(vh.pushbutton7,'enable','off');
set(vh.pushbutton9,'enable','off');
imaqreset
vid=videoinput('winvideo',1);
preview(vid)
%
%
%
%
%
%
pause(7)

v.Im = getsnapshot(vid);
closepreview
position=get(vh.axes6,'Position');
axes(vh.axes6);
image(v.Im);
set(gca,'position', [ position(1:2) 480 640],'visible','off');

set(vh.pushbutton2,'enable','on');
set(vh.pushbutton3,'enable','on');
set(vh.pushbutton4,'enable','on');
set(vh.pushbutton5,'enable','on');
set(vh.pushbutton6,'enable','on');
set(vh.pushbutton7,'enable','on');
set(vh.pushbutton9,'enable','on');
delete(vid)
%------------------------------------------------------------------
function ADD(varargin) 
global v vh hfig
clc
set(vh.uipanel2,'visible','off');
logindlg;
TrainDatabasePath = 'D:\Nedaa Project\Traindatabase';
cd(TrainDatabasePath) %change directory
cd('D:\Nedaa Project') % go back to the original directory

TrainFiles = dir(TrainDatabasePath);
Train_Number = 0;

for i = 1:size(TrainFiles,1)
    if not(strcmp(TrainFiles(i).name,'.')|strcmp(TrainFiles(i).name,'..')|strcmp(TrainFiles(i).name,'Thumbs.db'))
       Train_Number =Train_Number + 1; % Number of all images in the training database
    end
end
j=Train_Number + 1;
str = int2str(j);
str = strcat('\',str,'.jpg');
str = strcat(TrainDatabasePath,str);
%imwrite(v.Im,str,'jpg'); 
%%%%%Now enter the Personal Data that refer to this iris's holder   
prompt={'Name :','Gender :','PIN :','Date of Birth :','Eye :','Iris color :','Address :'};
num_lines=1;
defans={'','','','','','',''};
person=inputdlg(prompt,'Enter User Details',num_lines,defans);
if ~isempty(person)
    person=person';
    logintimeout(5);
    conn = database('MS Access Database', '', '');
    ping(conn);
    colnames={'Name';'Gender';'PIN';'Date of Birth';'Eye';'Iris color';'Address'};
    exdata(1,1)=person(1,1) ; 
    exdata(1,2)=person(1,2) ;
    exdata(1,3)=person(1,3) ;
    exdata(1,4)=person(1,4) ;
    exdata(1,5)=person(1,5) ;
    exdata(1,6)=person(1,6) ;
    exdata(1,7)=person(1,7) ;
    %auto= get(conn,'AutoCommit')
    insert(conn, 'Table1', colnames, exdata)
    close(conn)
end

%-------------------------------------------------------------------
function Edit(varargin) 
global v vh hfig
set(vh.uipanel2,'visible','off');
logindlg;
i=v.Recognized_index;
D=char(v.A(i,1));
prompt={'Address :'};
num_lines=1;
defans={''};
person=inputdlg(prompt,'Edit Personal Information',num_lines,defans);
if ~isempty(person)
    person=person';
    logintimeout(5);
    conn = database('MS Access Database', '', '');
    ping(conn);
    colnames={'Address'};
    exdata(1,1)=person(1,1) ;
    insert(conn, 'UserData', colnames, exdata);
    %update(conn, 'Table2', colnames, exdata, 'where Name = ''D''');
    close(conn)
end
%------------------------------------------------------------------
function Save(varargin) 
global v vh hfig
set(vh.uipanel2,'visible','off');
set(vh.pushbutton8,'enable','off');
set(vh.pushbutton3,'enable','off');
set(vh.pushbutton4,'enable','off');
set(vh.pushbutton5,'enable','off');
set(vh.pushbutton6,'enable','off');
set(vh.pushbutton7,'enable','off');
set(vh.pushbutton9,'enable','off');
pause(2)
TestDatabasePath = 'D:\Nedaa Project';
cd(TestDatabasePath) %change directory
cd('D:\Nedaa Project') % go back to the original directory

TestFiles = dir(TestDatabasePath);
Test_Number = 0;
for i = 1:size(TestFiles,1)
    if not(strcmp(TestFiles(i).name,'.')|strcmp(TestFiles(i).name,'..')|strcmp(TestFiles(i).name,'Thumbs.db'))
      Test_Number =Test_Number + 1; % Number of all images in the test database
    end
end

j = Test_Number + 1;
str = int2str(j);
str = strcat('\',str,'.bmp');
str = strcat(TestDatabasePath,str)
%////////////////////////////////////////imwrite(v.Im,str,'jpg') 
 
set(vh.pushbutton8,'enable','on');
set(vh.pushbutton3,'enable','on');
set(vh.pushbutton4,'enable','on');
set(vh.pushbutton5,'enable','on');
set(vh.pushbutton6,'enable','on');
set(vh.pushbutton7,'enable','on');
set(vh.pushbutton9,'enable','on');
msgbox('     Your Picture is saved.......')

%------------------------------------------------------------------
function Delete(varargin) 
global v vh hfig
clc
set(vh.uipanel2,'visible','off');
%logindlg;
[v.file, path]=uigetfile('D:\Nedaa Project\TestDatabase\*.bmp','Open a file');
TestImage=strcat(path,v.file);
[pathstr,v.name,ext] = fileparts(TestImage);
v.name1=str2double(v.name).*2;
v.str=v.name1-1;
v.picture1=TestImage;
TrainDatabasePath = 'D:\Nedaa Project\Traindatabase';
warndlg('Continuing this operation will delete the choosen file permanently','!!Warning!!')
pause(3)
delete(v.picture1)
%TestDatabasePath = 'D:\Nedaa Project\Testdatabase';
%cd(TestDatabasePath) %change directory
%cd('D:\Nedaa Project') % go back to the original directory
%TestFiles = dir(TestDatabasePath);
%Test_Number = 0;

%for i = 1:size(TestFiles,1)
 %   if not(strcmp(TestFiles(i).name,'.')|strcmp(TestFiles(i).name,'..')|strcmp(TestFiles(i).name,'Thumbs.db'))
  %    axes(vh.axes6)
   %   imshow(strcat(TestDatabasePath,'\',TestFiles(i).name))
    %  c = getimage(vh.axes6);
     % pause(0.2)
      %Test_Number =Test_Number + 1; % Number of all images in the test database
      %str = int2str(Test_Number);
      %str = strcat('\',str,'.bmp');
      %str = strcat(TestDatabasePath,str);
      %imwrite(c,str,'bmp') 
    
    %end
%end
Train_image1=strcat(TrainDatabasePath,'\',num2str(v.name1),'.bmp');
delete(Train_image1)
Train_image2=strcat(TrainDatabasePath,'\',num2str(v.str),'.bmp');
delete(Train_image2)
cd(TrainDatabasePath) %change directory
cd('D:\Nedaa Project') % go back to the original directory
TrainFiles = dir(TrainDatabasePath);
Train_Number = 0;

for i = 1:size(TrainFiles,1)
    if not(strcmp(TrainFiles(i).name,'.')|strcmp(TrainFiles(i).name,'..')|strcmp(TrainFiles(i).name,'Thumbs.db'))
      axes(vh.axes6)
      imshow(strcat(TrainDatabasePath,'\',TrainFiles(i).name))
      c = getimage(vh.axes6);
      pause(0.4)
      Train_Number =Train_Number + 1; % Number of all images in the training database
      str = int2str(Train_Number);
      str = strcat('\',str,'.bmp');
      str = strcat(TrainDatabasePath,str);
      imwrite(c,str,'bmp') 
    
    end
end
msgbox('Delete operation is completed');
%------------------------------------------------------------------ 
function Identify(varargin) 
global v vh hfig
set(vh.uipanel2,'visible','off');
clc

logindlg;

[v.file, path]=uigetfile('D:\Nedaa Project\Traindatabase\*.bmp','Open a file');
TestImage=strcat(path,v.file);
TrainDatabasePath = 'D:\Nedaa Project\Traindatabase';
cd(TrainDatabasePath) %change directory
cd('D:\Nedaa Project') % go back to the original directory
T = CreateDatabase1(TrainDatabasePath);
[m, A, Eigenfaces] = EigenfaceCore1(T);
OutputName = Recognition1(TestImage, m, A, Eigenfaces);
SelectedImage = strcat(TrainDatabasePath,'\',OutputName)
%info=imfinfo(SelectedImage);
SelectedImage=imread(SelectedImage);
Image1=imresize(SelectedImage,[240 320]);
i=v.Recognized_index;
logintimeout(5);
conn = database('MS Access Database', '', '');
curs=exec(conn,'select * from UserData');
curs=fetch(curs);
v.A=curs.Data;
close(conn)
% to get information about user using his index
set(vh.uipanel2,'visible','on');
set(vh.text7,'string',v.A(i,1));
set(vh.text8,'string',v.A(i,2));
set(vh.text10,'string',v.A(i,3));
set(vh.text9,'string',v.A(i,4));
set(vh.text17,'string',v.A(i,5));
set(vh.text13,'string',v.A(i,6));
set(vh.text15,'string',v.A(i,7));

%set(vh.text1,'visible','off');

pos=get(vh.axes6,'position');
axes(vh.axes6)
imshow(Image1)
set(vh.axes6,'visible','off','position',[pos(1:2) 320 240])
%------------------------------------------------------------------ 

function Verify(varargin) 
global v vh hfig
set(vh.uipanel2,'visible','off');
[v.file, path]=uigetfile('D:\Nedaa Project\Testdatabase\*.bmp','Open a file');
%[v.file, path]=uigetfile({'*.bmp';'*.jpg';'*.tif'},'Open a file');
TestImage=strcat(path,v.file);
%TestImage=v.Im;
TrainDatabasePath = 'D:\Nedaa Project\Traindatabase';
cd(TrainDatabasePath) %change directory
cd('D:\Nedaa Project') % go back to the original directory
T = CreateDatabase(TrainDatabasePath);
[m, A, Eigenfaces] = EigenfaceCore(T);
OutputName = Recognition(TestImage, m, A, Eigenfaces);

SelectedImage = strcat(TrainDatabasePath,'\',OutputName)

%msgbox(SelectedImage)

%------------------------------------------------------------------
