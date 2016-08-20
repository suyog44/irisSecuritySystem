function T = CreateDatabase(TrainDatabasePath)
% Align a set of face images (the training set T1, T2, ... , TM )
%
% Description: This function reshapes all 2D images of the training database
% into 1D column vectors. Then, it puts these 1D column vectors in a row to 
% construct 2D matrix 'T'.
%  
% 
% Argument:     TrainDatabasePath      - Path of the training database
%
% Returns:      T                      - A 2D matrix, containing all 1D image vectors.
%                                        Suppose all P images in the training database 
%                                        have the same size of MxN. So the length of 1D 
%                                        column vectors is MN and 'T' will be a MNxP 2D matrix.
%

%%%%%%%%%%%%%%%%%%%%%%%% File management
global v vh
TrainFiles = dir(TrainDatabasePath);
Train_Number = 0;

for i = 1:size(TrainFiles,1)
    if not(strcmp(TrainFiles(i).name,'.')|strcmp(TrainFiles(i).name,'..')|strcmp(TrainFiles(i).name,'Thumbs.db'))
        Train_Number = Train_Number + 1; % Number of all images in the training database
    end
end

%%%%%%%%%%%%%%%%%%%%%%%% Construction of 2D matrix from 1D image vectors
T = [];

 for i = 1 : Train_Number
    
    % I have chosen the name of each image in databases as a corresponding
    % number. However, it is not mandatory!
    str = int2str(i);
    str = strcat('\',str,'.bmp');
    str = strcat(TrainDatabasePath,str);
    str = imread(str);
    %str = rgb2gray(str);
    v.R=houghcircles(str,50,150);
   str=imresize(str,[240 320]);
    pos=get(vh.axes6,'position');
    axes(vh.axes6)
    imshow(str)
    set(gca,'position',[pos(1:2) 320 240],'visible','off');
    hold on;
  for i = 1:size(v.R,1)
    x = v.R(i,1)-v.R(i,3);
    y = v.R(i,2)-v.R(i,3);
    w = 2*v.R(i,3);
    rectangle('Position', [x y w w], 'EdgeColor', 'yellow', 'Curvature', [1 1]);
  end
  hold off;
    
    pause(0.05)
    [irow icol] = size(v.R);
    temp = reshape(v.R',irow*icol,1);   % Reshaping 4D images into 1D image vectors
   
   

    T = [T temp]; % 'T' grows after each turn

 end 

