clc;
clear;
% tocom=getSegment('dataset/cancer/pic_006.jpg',false);
% fea=featureExtra(tocom);
% tocom2=getSegment('dataset/normal/Congential Nevus.jpg',false);
% % tocom2=getSegment('dataset/normal/6.jpg',false);
% fea2=featureExtra(tocom2);
% fea=[fea fea2];
% figure(1);
% % subplot(221);imshow(tocom);title('segmented Melanoma image');
% % subplot(222);imshow(tocom2);title('segmented Congential Nevus image');
% % subplot(223);
% title('Feature comparation');
% b=bar(fea);
% ch = get(b,'children');
% % set(ch,'FaceVertexCData',[0 1 1;1 0 1;]);
% % legend('Melanoma image features','Healthy skin image features');  
% legend('Melanoma image features','Congential Nevus image features'); 
% cancer=getSegment('000284.dcm',false);
cancer=getSegment('dataset/cancer/pic_001.jpg',false);
% cancer=getSegment('dataset/normal/Basal Cell Carcinoma2.jpg',false);
% fea=featureExtra(cancer);