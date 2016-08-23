function [outputX] = featureExtra( inputImage )
% featureExtra Extra the features of an image
%   return a 13*1 vector of the feature

% testPic=imread(imgFileName);
testPic=inputImage;
pic2=rgb2gray(testPic);
pic2=im2double(pic2);
for i=1:3
    testPic(:,:,i)=medfilt2(testPic(:,:,i),[15 15]);
end
[M,N,Z2]=size(testPic);
meanC=zeros(3,1);
covC=zeros(3,1);
thirdCovC=zeros(3,1);
%% compute the first three color features for each color channel
for z=1:3
    %         meanC(z,1)=sum(sum(testPic(:,:,z)));
    %         meanC(z,1)=meanC(z,1)/M/N;
    meanC(z,1)=mean(mean(testPic(:,:,z)));
    %         disp(meanC(z,1));
    covC(z,1)=sum(sum((testPic(:,:,z)-meanC(z,1)).^2));
    covC(z,1)=nthroot((covC(z,1)/M/N),2);
    %         disp(covC(z,1));
    thirdCovC(z,1)=sum(sum((testPic(:,:,z)-meanC(z,1)).^3));
    thirdCovC(z,1)=nthroot((thirdCovC(z,1)/M/N),3);
%     disp(thirdCovC(z,1));
end
%% get grey co-matrix
pic2=rgb2gray(testPic);
[glcms,SI]=graycomatrix(pic2);
stats = graycoprops(glcms,'Contrast Homogeneity Energy');
% save temp glcms;
outputX=zeros(13,1);
count=1;
%% save the three color features for each color chennel to output
for i=1:3
    outputX(count,1)=meanC(i,1);
    count=count+1;
    outputX(count,1)=covC(i,1);
    count=count+1;
    outputX(count,1)=thirdCovC(i,1);
    count=count+1;
end
%% get 4 texture features into output
outputX(count,1)=entropy(glcms);
outputX(count+1,1)=stats.Energy;
outputX(count+2,1)=stats.Homogeneity;
outputX(count+3,1)=stats.Contrast;
% disp(outputX);
end

