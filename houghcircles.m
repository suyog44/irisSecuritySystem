function circles = houghcircles(im, minR, maxR, thresh, delta)
global hfig vh v
% Check input arguments
if nargin==3
  thresh = 0.33;   
  delta = 12;      
elseif nargin==4
  delta = 12;
end
if minR<0 || maxR<0 || minR>maxR || thresh<0 || thresh>1 || delta<0
  disp('Input conditions: 0<minR, 0<maxR, minR<=maxR, 0<thresh<=1, 0<delta');
  return;
end

% Turn a color image into gray
im=imresize(im,[240 320]);
origim = im;

if length(size(im))>2
  im = rgb2gray(im);   
end

% Create a 3D Hough array with the first two dimensions specifying the
% coordinates of the circle centers, and the third specifying the radii.
% To accomodate the circles whose centers are out of the image, the first
% two dimensions are extended by 2*maxR.
maxR2 = 2*maxR;
hough = zeros(size(im,1)+maxR2, size(im,2)+maxR2, maxR-minR+1);

[X Y] = meshgrid(0:maxR2, 0:maxR2);
Rmap = round(sqrt((X-maxR).^2 + (Y-maxR).^2));
Rmap(Rmap<minR | Rmap>maxR) = 0;
edgeim = edge(im, 'canny', [0.01 0.09]);
%pos=get(vh.axes6,'position');
%axes(vh.axes6)
%imshow(edgeim)
%set(gca,'position',[pos(1:2) 320 240],'visible','off');

[Ey Ex] = find(edgeim);
[Cy Cx R] = find(Rmap);
for i = 1:length(Ex);
  Index = sub2ind(size(hough), Cy+Ey(i)-1, Cx+Ex(i)-1, R-minR+1);
  hough(Index) = hough(Index)+1;
end
twoPi = 0.9*2*pi;
circles = zeros(0,4);    % Format: (x y r t)
for radius = minR:maxR   % Loop from minimal to maximal radius
  slice = hough(:,:,radius-minR+1);  % Offset by minR
  twoPiR = twoPi*radius;
  slice(slice<twoPiR*thresh) = 0;  % Clear pixel count < 0.9*2*pi*R*thresh
  [y x count] = find(slice);
  circles = [circles; [x-maxR, y-maxR, radius*ones(length(x),1), count/twoPiR]];
end

% Delete similar circles
circles = sortrows(circles,-4);  % Descending sort according to ratio
i = 1;
while i<size(circles,1)
  j = i+1;
  while j<=size(circles,1)
    if sum(abs(circles(i,1:3)-circles(j,1:3))) <= delta
      circles(j,:) = [];
    else
      j = j+1;
    end
  end
  i = i+1;
end

%if nargout==0   % Draw circles
%pos=get(vh.axes6,'position');
%axes(vh.axes6)
%imshow(origim)
%set(gca,'position',[pos(1:2) 320 240],'visible','off');
%hold on;
%  for i = 1:size(circles,1)
%    x = circles(i,1)-circles(i,3);
 %   y = circles(i,2)-circles(i,3);
  %  w = 2*circles(i,3);
   % rectangle('Position', [x y w w], 'EdgeColor', 'yellow', 'Curvature', [1 1]);
  %end
  %hold off;
%end
%pupilimg=origim(10:220,10:220);
%figure;imshow(pupilimg)


