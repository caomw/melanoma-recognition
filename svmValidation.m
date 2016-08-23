clc;clear;
load trainData;
p=p';
%% select some of the features and get their inverse
a=[1,4,6,7,9,11,12];
p(a,:)=-p(a,:);
t=t';
%% get true label from t matrix
labels=cell(1,size(t,2));
labels(1,(t(1,:)==0.9))=cellstr('melanoma');
labels(1,~(t(1,:)==0.9))=cellstr('other');
%% set up varibles
k_fold=10;
classResult=cell(4,k_fold);
repeatTimes=20;
%networks=cell(1,k_fold);
malanomaSave=[];
real_label=[];
C=zeros(50*k_fold,2,2);
temp=zeros(repeatTimes,1);
for time=1:repeatTimes
    Indices=crossvalind('Kfold',size(labels,2),k_fold);
    cp = classperf(labels);
    for i=1:k_fold
        %% initialize vars
        oneTimeCp=classperf(labels);
        test_set=(Indices==i);
        train_set=~test_set;
        % validation set
        validation_set_input=p(:,test_set);
        validation_set_output=t(:,test_set);
        % test set
        train_set_input=p(:,train_set);
        train_set_output=t(:,train_set);
        
        svmStruct = svmtrain(train_set_input',train_set_output(1,:));
        T_sim2=svmclassify(svmStruct,train_set_input');
        T_sim=svmclassify(svmStruct,validation_set_input');
        T_sim=T_sim';
        
        %% results
        %if the first score from network is larger than the second, consider it
        %as the first class
        melanoma=(T_sim>0.5);%(T_sim(1,:)>T_sim(2,:));
        %melanomaSave=[melanomaSave,melanoma];
        %real_label=[real_label,(validation_set_output(1,:)==0.9)];
        real_label=(validation_set_output(1,:)==0.9);
        class=cell(1,size(validation_set_output,2));
        class(1,melanoma)=cellstr('melanoma');
        class(1,~melanoma)=cellstr('other');
        
        classperf(cp,class,test_set);
        classperf(oneTimeCp,class,test_set);
        
        classResult{1,i}=cp;%the whole result after kfold
        classResult{2,i}=T_sim;%classification result
        classResult{3,i}=validation_set_output;%true label
        
        
        classResult{4,i}=oneTimeCp;%serprated result of kfold(each one is one of the kfold test)
        
        disp(cp.CorrectRate);
        C((time-1)*k_fold+i,:,:)=confusionmat(real_label,melanoma);
        
    end
    temp(time)=cp.CorrectRate;
end
mean(temp)
std(temp)
meanC=zeros(2,2);
varC=zeros(2,2);
for l=1:size(C,1)
    total=sum(sum(C(l,:,:)));
    for i=1:2
        for j=1:2
            C(l,i,j)=C(l,i,j)/total;
        end
    end
end
for i=1:2
    for j=1:2
        meanC(i,j)=mean(C(:,i,j));
        varC(i,j)=std(C(:,i,j));
    end
end
r=(train_set_output(1,:)==0.9);
plotconfusion(r,(T_sim2'>0.5));
pause
plotconfusion(real_label,melanoma);
save svm_KFoldResult classResult;