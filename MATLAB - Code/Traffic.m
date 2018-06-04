clc;
clear all;

oq=imread('Test/Ref_0.jpg');
pic1=imresize(oq,[300 300]);

%cam=webcam(2);
%sw=snapshot(cam);
sw=imread('Test/Ref_8.jpg');
pic2=imresize(sw,[300 300]);

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
Ib1 = imgaussfilt(pic1,2);
Ib2 = imgaussfilt(pic2,2);
%applying edge detection on first picture
%so that we obtain white and black points and edges of the objects present
%in the picture.

edge_det_pic1 = edge(Ib1, 'canny');

%%applying edge detection on second picture
%so that we obtain white and black points and edges of the objects present
%in the picture.

edge_det_pic2 = edge(Ib2,'canny');

ssimval = ssim(pic2,pic1);
peaksnr = psnr(pic2,pic1);
err = immse(pic2,pic1);


matches = edge_det_pic1 == edge_det_pic2;
p = 100 * sum(matches(:)) / numel(matches);

i3 = xor(edge_det_pic1, edge_det_pic2);

%imagesc(i3);

% and for some relative measure

d = sum(i3(:)) / numel(i3);

disp(ssimval);

disp(peaksnr);

disp(err);

disp(d);

imshowpair(edge_det_pic1,edge_det_pic2,'montage');