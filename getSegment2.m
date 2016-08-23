function [X] = getSegment( imgFilename,printImage )
%
%   Use median filter to filter the image first. Then we use the active contour without edges algorithm to get the lesion area curve. 
%   After these, this function will set the area out of the curve to be blank and return this image.
%
%   Use median filter to filter the image first. Then we use the active contour without edges algorithm to get the lesion area curve. 
%   After these, this function will set the area out of the curve to be blank and return this image.

tic
Img=imread(imgFilename);
% Img = dicomread(imgFilename);
ImgBak=Img;


% subplot(121);
% imshow(ImgBak);
% Img=double(rgb2gray(Img));
% 
% Img=medfilt2(Img,[15,15]);
% subplot(122);
% imshow(uint8(Img));title('filtered image');
X=Img;

% BW1 = edge(Img,'canny');  % 调用canny函数  
% figure,imshow(BW1);     % 显示分割后的图像，即梯度图像  
% title('matlab canny') 
  
a=rgb2gray(Img);
% Img=double(Img);
% title('original image');
a=medfilt2(a,[15,15]);  
level = graythresh(a);  
a=im2bw(a,level);  
[nx,ny]=size(a);
%imshow(a,[]);  
%ImgBak=a;
for i=1:nx
    for j=1:ny
        if a(i,j)==1
            ImgBak(i,j,:)=255;
        end
    end
end
%figure(2)
%imshow(ImgBak);

% I=X;
% q=imadjust(I,[.2 .3 0;.6 .7 1],[]); %增强图像的对比度
% j=rgb2gray(q);    %彩色图像变灰度图像
% j1=im2bw(q,230/255);%二值化
% se90=strel('line',3,90);    %构造元素
% se0=strel('line',3,0);    %同上
% BW2=imdilate(j1,[se90 se0]);   % 用构造的元素膨胀
%  BW3=bwareaopen(BW2,100);%开操作
% BW3=~BW3;%取反
%  BW4=bwareaopen(BW3,20);%开
% BW5=bwperim(BW4);%计算BW4周长
% [imx,imy]=size(BW5);%计算长宽
%  L=bwlabel(BW5,8);%用不同的数字根据是否连通标记图像，
% a=max(max(L));%得到L图像中标记结果的最大值
%  BW6=bwfill(BW5,'hole');%填充背景
%  I2=I;          
%  for i=1:3; I2(:,:,i)=I2(:,:,i).*uint8(BW6);
%  end
%  imshow(I2);

f=ImgBak;
X=f;
end



