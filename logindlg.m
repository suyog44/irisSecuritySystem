function [varargout]=logindlg(varargin)
global v vh hfig
% Number of inputs check
if nargin ==  0 || nargin == 2 || nargin == 4
else
    error('Incorrect number of input arguments.')
end

% Input Type Check
for i=1:1:length(varargin)
    if ~ischar(varargin{i})
        error('Inputs must be strings.')
    end
end

% Title Option
if nargin == 0
    Title = 'Login';
elseif nargin == 2 && ~isempty(strmatch('title',lower(varargin)))
    Title = varargin{2};
elseif nargin == 2 && isempty(strmatch('title',lower(varargin)))
    Title = 'Login';
elseif nargin == 4 && ~isempty(strmatch('title',lower(varargin)))
    S = strmatch('title',lower(varargin));
    if S == 1
        Title = varargin{2};
    elseif S == 3
        Title = varargin{4};
    else
        error('Invalid title.')
    end
else
    error('Invalid title.')
end

% Password Option
if nargin == 0
    Pass = 0;
elseif nargin == 2 && ~isempty(strmatch('password',lower(varargin{1}))) && ~isempty(strmatch('only',lower(varargin{2})))
    Pass = 1;
elseif nargin == 4 && ~isempty(strmatch('password',lower(varargin))) && ~isempty(strmatch('only',lower(varargin)))
    P = strmatch('password',lower(varargin));
    O = strmatch('only',lower(varargin));
    if P == 1 && O == 2
        Pass = 1;
    elseif P == 3 && O == 4
        Pass = 1;
    end
elseif nargin == 2 && isempty(strmatch('password',lower(varargin))) == 1
    Pass = 0;
else
    error('Invalid password option.')
end

% Output Error Check
if nargout > 1 && Pass == 1 || nargout > 2
    error('Too many output arguments.')
end

% Get Properties
Color = get(0,'DefaultUicontrolBackgroundcolor');

% Determine the size and position of the login interface
if Pass == 0
    Height = 9.5;
else
    Height = 5.5;
end
set(0,'Units','characters')
Screen = get(0,'screensize');
Position = [Screen(3)/2-17.5 Screen(4)/2-4.75 35 Height];
set(0,'Units','pixels')

% Create the GUI
gui.main = dialog('HandleVisibility','on',...
    'IntegerHandle','off',...
    'Menubar','none',...
    'NumberTitle','off',...
    'Name','Login',...
    'Tag','logindlg',...
    'Color',Color,...
    'Units','characters',...
    'Userdata','logindlg',...
    'Position',Position);

% Set the title
if ischar(Title) == 1
    set(gui.main,'Name',Title,'Closerequestfcn',{@Cancel,gui.main})
end

% Texts
if Pass == 0
    gui.login_text = uicontrol(gui.main,'Style','text','FontSize',8,'HorizontalAlign','left','Units','characters','String','Login','Position',[1 7.65 20 1]);
end
gui.password_text = uicontrol(gui.main,'Style','text','FontSize',8,'HorizontalAlign','left','Units','characters','String','Password','Position',[1 4.15 20 1]);

% Edits
if Pass == 0
    gui.edit1 = uicontrol(gui.main,'Style','edit','FontSize',8,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String','','Position',[1 6.02 33 1.7],'fontweight','bold');
end
gui.edit2 = uicontrol(gui.main,'Style','edit','FontSize',14,'HorizontalAlign','left','BackgroundColor','white','Units','characters','String','','Position',[1 2.52 33 1.7],'KeyPressfcn',{@KeyPress_Function,gui.main},'Userdata','','fontweight','bold');

% Buttons
gui.OK = uicontrol(gui.main,'Style','push','FontSize',8,'Units','characters','String','OK','Position',[12 .2 10 1.7],'Callback',{@OK,gui.main});
gui.Cancel = uicontrol(gui.main,'Style','push','FontSize',8,'Units','characters','String','Cancel','Position',[23 .2 10 1.7],'Callback',{@Cancel,gui.main});

setappdata(0,'logindlg',gui) % Save handle data
setappdata(gui.main,'Check',0) % Error check setup. If Check remains 0 an empty cell array will be returned

if Pass == 0
    uicontrol(gui.edit1) % Make the first edit box active
else
    uicontrol(gui.edit2)  % Make the second edit box active if the first isn't present
end

% Pause the GUI and wait for a button to be pressed
uiwait(gui.main)

Check = getappdata(gui.main,'Check'); % Check to see if a button was pressed

% Format output
if Check == 1
    if Pass == 0
        Login = get(gui.edit1,'String');
    end
    Password = get(gui.edit2,'Userdata');
    
    if nargout == 1 % If only one output specified output Password
        varargout(1) = {Password};
    elseif nargout == 2 % If two outputs specified output both Login and Password
        varargout(1) = {Login};
        varargout(2) = {Password};
        if strcmpi('admin',char(Login)) 
            if strcmpi('123',char(Password))
            else
                errordlg('Invalied User ID or Password ! Try Again')
                pause(2)
                delete (gui.main)
                setappdata(0,'logindlg',[]) % Erase handles from memory
            end
        else
            errordlg('Invalied User ID or Password ! Try Again')
            pause(1.5)
            delete(gui.main) % Close the GUI
            setappdata(0,'logindlg',[]) % Erase handles from memory
        end
    end
else % If OK wasn't pressed output nothing
    if nargout == 1
        varargout(1) = {[]};
    elseif nargout == 2
        varargout(1) = {[]};
        varargout(2) = {[]};
    end
    delete(gui.main) % Close the GUI
    setappdata(0,'logindlg',[]) % Erase handles from memory
end

delete(gui.main) % Close the GUI
setappdata(0,'logindlg',[]) % Erase handles from memory

%% Hide Password
function KeyPress_Function(h,eventdata,fig)
% Function to replace all characters in the password edit box with
% asterixes
password = get(h,'Userdata');
key = get(fig,'currentkey');

switch key
    case 'backspace'
        password = password(1:end-1); % Delete the last character in the password
    case 'return'  % This cannot be done through callback without making tab to the same thing
        gui = getappdata(0,'logindlg');
        OK([],[],gui.main);
    case 'tab'  % Avoid tab triggering the OK button
        gui = getappdata(0,'logindlg');
        uicontrol(gui.OK);
    otherwise
        password = [password get(fig,'currentcharacter')]; % Add the typed character to the password
end

SizePass = size(password); % Find the number of asterixes
if SizePass(2) > 0
    asterix(1,1:SizePass(2)) = '*'; % Create a string of asterixes the same size as the password
    set(h,'String',asterix) % Set the text in the password edit box to the asterix string
else
    set(h,'String','')
end

set(h,'Userdata',password) % Store the password in its current state

%% Cancel
function Cancel(h,eventdata,fig)
uiresume(fig)

%% OK
function OK(h,eventdata,fig)
% Set the check and resume
setappdata(fig,'Check',1)
 
uiresume(fig)




