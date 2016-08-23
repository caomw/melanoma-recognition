function [X] = getSegment( imgFilename,printImage )
%
%   Use median filter to filter the image first. Then we use the active contour without edges algorithm to get the lesion area curve. 
%   After these, this function will set the area out of the curve to be blank and return this image.

tic
Img=imread(imgFilename);
% Img = dicomread(imgFilename);
ImgBak=Img;
% subplot(121);
% imshow(ImgBak);
Img=double(rgb2gray(Img));
Img(:)=(Img(:)-mean(mean(Img)))/std(std(Img));
% Img=double(Img);
% title('original image');
%Img=medfilt2(Img,[15,15]);
% subplot(122);
% imshow(uint8(Img));title('filtered image');
X=Img;
% return;
% toc
% tic
[nx,ny]=size(Img);
%%- set init curve C as a circle
ic=floor(nx/2);         % compute init circle center
jc=floor(ny/2);
r=ic/2;                 % radius

%%- init u as the distance function
u = zeros([nx,ny]);
for i=1:nx
    for j=1:ny
        u(i,j)= r-sqrt((i-ic).^2+(j-jc).^2);
    end
end
%%- draw init curve on the picture
% figure(1);
% subplot(151);
% imshow(uint8(Img));
% title('initial curve');
% hold on;
%[c,h] = contour(u,[0 0],'r');

%%- init parameter
epsilon=1.5;            % Heaviside parameter setting
nu=2500;
delta_t=0.1;

nn=1;
iter=800;
%%- iter begin
for n=1:iter
    %%- regularization of Heavside
    H_u = 0.5*(1+(2/pi)*atan(u/epsilon));
    
    %%- compute c1 and c2 according to u
    c1=sum(sum(H_u.*Img))/sum(sum(H_u));
    c2=sum(sum((1-H_u).*Img))/sum(sum(1-H_u));
    %nu=1/min(c1,c2);
    %c1=c1.^0.5;c2=c2.^0.5;
    
    %%- use c1 and c2 to update u
    delta_H = (1/pi)*epsilon./(epsilon^2+u.^2);
    m=delta_t*delta_H;
    C_1 = 1./sqrt(eps+(u(:,[2:ny,ny])-u).^2+0.25*(u([2:nx,nx],:)-u([1,1:nx-1],:)).^2);
    C_2 = 1./sqrt(eps+(u-u(:,[1,1:ny-1])).^2+0.25*(u([2:nx,nx],[1,1:ny-1])-u([1,1:nx-1],[1,1:ny-1])).^2);
    C_3 = 1./sqrt(eps+(u([2:nx,nx],:)-u).^2+0.25*(u(:,[2:ny,ny])-u(:,[1,1:ny-1])).^2);
    C_4 = 1./sqrt(eps+(u-u([1,1:nx-1],:)).^2+0.25*(u([1,1:nx-1],[2:ny,ny])-u([1,1:nx-1],[1,1:ny-1])).^2);
    C = 1+nu*m.*(C_1+C_2+C_3+C_4);
    u = (u+nu*m.*(C_1.*u(:,[2:ny,ny])+C_2.*u(:,[1,1:ny-1])+C_3.*u([2:nx,nx],:)+C_4.*u([1,1:nx-1],:) )+...
        m.*((Img-c2).^2-(Img-c1).^2))./C;
    
    %%- show the curve and image
%     if mod(n,iter/4)==0
%         nn=nn+1;
%         f=Img;
%         f(u>0)=c1;
%         f(u<0)=c2;
% %         subplot(2,2,nn);imshow(uint8(f));
%         subplot(1,5,nn); imshow(uint8(Img));title(sprintf('iteration = %d',(nn-1)*iter/4));
%         hold on;
%         [c,h] = contour(u,[0 0],'r');
%         hold off;
%     end
end
% toc
f=ImgBak;
for i=1:nx
    for j=1:ny
        if(u(i,j)<0)
            f(i,j,:)=255;            
        end
    end
end

% row=find(sum(f,2));
% col=find(sum(f,1));
% row=row(1):row(end);
% col=col(1):col(end);
% a=a(row,col)
% if printImage
% figure(1);
%     subplot(2,2,1);imshow(ImgBak);title('origin');
% %     subplot(2,2,2);imshow(f);title('segment');
%     subplot(2,2,3); imshow(uint8(Img));title('filtered');
% end
X=f;
end

