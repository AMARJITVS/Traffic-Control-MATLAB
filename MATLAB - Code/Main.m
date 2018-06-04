clc;
if ~isempty(instrfind)
    disp("Closing open connections...");
     fclose(instrfind);
      delete(instrfind);
end

cam=webcam(1);
ref=snapshot(cam);
clear cam;
imwrite(ref,'E:\MATLAB Projects\Traffic Control\Test\Reference.jpg')

%ref=imread('Test/Ref_0.jpg');

pic1=imresize(ref,[300 300]);

arduino=serial('COM3','BaudRate',115200); % create serial communication object 
fclose(arduino);
fopen(arduino); % initiate arduino communication
c=15;
while c>=0
    clc;
    disp(c);
    c=c-1;
     pause(1);
end
clc;
while true
    disp("------------------------------------------------");
    disp("Image capure initiated!!!");
    
cam=webcam(1);
img=snapshot(cam);
clear cam;
disp("Image captured");
imwrite(img,'E:\MATLAB Projects\Traffic Control\Test\Image.jpg')
pic2=imresize(img,[300 300]);

[~,~,z] = size(pic1);
if(z==1)
     
else
    pic1 = rgb2gray(pic1);
end
[~,~,z] = size(pic2);
if(z==1)
    
else
    pic2 = rgb2gray(pic2);
end
Ig1 = imgaussfilt(pic1,2);
Ig2 = imgaussfilt(pic2,2);

%applying edge detection on first picture
%so that we obtain white and black points and edges of the objects present
%in the picture.
edge_det_pic1 = edge(Ig1, 'canny');

%%applying edge detection on second picture
%so that we obtain white and black points and edges of the objects present
%in the picture.

edge_det_pic2 = edge(Ig2,'canny');
disp("Canny edge detection done");

result = immse(pic2,pic1);

val=round(result/10);
disp("Comparison value = "+val);
if val<=30
    data="20";
elseif val<=50
    data="40";
else
    data="50";
end
disp("Alloted time = "+data);      
%imshowpair(edge_det_pic1,edge_det_pic2,'montage');

disp("Data sent to Arduino...");
pause(2);
fprintf(arduino,data);
a=fscanf(arduino);
while a(1)~="1"
a=fscanf(arduino);
end
disp("Finish!!!");
c=c+1;
end