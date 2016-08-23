function [myNet,trainNumberOfCancer,trainNumberOfOther ] = trainMyNetwork(numberofCancer,numberofOther,retrainFea,retrainNetwork)
%%
% This .m file can recompute all the image files' feature (by calling getSegment.m) 
% and set up and retrain the Neural Network(using some of the images as the trainning data set).
% 

trainNumberOfCancer=58;%means using how many images of cancer to train the network,if not reverse.
                        %If reverse, that this is the test case number
trainNumberOfOther=55; %means using how many images of other to train the network
myNet=1;
p=zeros(13,0);
t=zeros(1,0);
files=cell(1,numberofCancer+3);
oriimgs=cell(1,numberofCancer+3);
imgs=cell(1,numberofCancer+3);

%% Load the features or recompute the features
interval=60;
if ~retrainFea && exist('trainData.mat','file')
    load trainData p t files;   
else
    readDir = './dataset/cancer';%change / to \ if you are using windows OS
    readPath = [readDir '/*.jpg']
    readList = dir(readPath);
%     matlabpool open 8;
%     disp(readList);
    tic
    for i=1:numberofCancer      
         picName= readList(i, 1).name;
         readPath = [readDir '/' picName];
         files{1,i}=readPath;
         oriimgs{1,i}=imread(readPath);
         tocom=getSegment(readPath,false);
         imgs{1,i}=tocom;
         fea=featureExtra(tocom);
         p=[p fea];%p(:,i)=fea;
         t=[t [0.9;0.1]];%t(1,i)=1; 
         disp(i),disp('/'),disp(numberofCancer);
         if i~=numberofCancer
             pause(interval);
         end
    end
    toc
    readDir = './dataset/normal';
    readPath = [readDir '/*.jpg']
    readList = dir(readPath);
    tic
    for i=1:numberofOther     
         picName= readList(i, 1).name;
         readPath = [readDir '/' picName];
         files{1,i+numberofCancer}=readPath;
         oriimgs{1,i+numberofCancer}=imread(readPath);
         tocom=getSegment(readPath,false);
         imgs{1,i+numberofCancer}=tocom;
         fea=featureExtra(tocom);
         p=[p fea];%p(:,i)=fea;
         t=[t [0.1;0.9]];%t(1,i)=1;    
         disp(picName);
         disp(i),disp('/'),disp(numberofOther);
         if i~=numberofOther
             pause(interval);
         end
    end
    toc;
    p=p';
    t=t';
    save trainData_standard_nomedian p t files imgs;
end

% diseaseLabel={'melanoma','other'};
% disease=cell(1,size(t,1));
% for i=1:size(t,1)
%     if t(i,1)==0.9
%         disease{1,i}=diseaseLabel{1};
%     else
%         disease{1,i}=diseaseLabel{2};
%     end
% end
% disease=disease';
% K=10;
% indices = crossvalind('Kfold',disease,K);
% cp = classperf(disease);
% for i=1:K
%     test = (indices == i); train = ~test;
%     class = classify(p(test,:),p(train,:),disease(train,:));   
%     classperf(cp,class,test);
% end
% cp.CorrectRate
% return;

%%retrain the network
if retrainNetwork    
    myNet=newff(minmax(p),[50,2],{'tansig' 'tansig'},'trainlm');
    myNet.trainParam.lr=0.05;
    myNet.trainParam.goal = 0.01;
    myNet.trainParam.epochs = 10000; %max iteration loop number
%     temp1=p(:,[1:trainNumberOfCancer numberofCancer+1:numberofCancer+trainNumberOfOther]);
%     temp2=t(:,[1:trainNumberOfCancer numberofCancer+1:numberofCancer+trainNumberOfOther]);
    temp1=p(:,[trainNumberOfCancer+1:numberofCancer numberofCancer+trainNumberOfOther+1:numberofCancer+numberofOther]); %for exchanging train data and test data  
    temp2=t(:,[trainNumberOfCancer+1:numberofCancer numberofCancer+trainNumberOfOther+1:numberofCancer+numberofOther]);
    [myNet,tr]=train(myNet,temp1,temp2);
    save nelNetwork myNet;
else
    load KFoldResult_9027_5000_sim_50node myNet;
end
end

