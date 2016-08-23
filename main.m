%% this script now compute the roc for each feature
clc;
clear;

numberofCancer=58;%use how many cases of cancer to make up the data ,should be equal to the number of jpgs in dataset\cancer\
numberofOther=55;%use how many cases of other to make up the data ,should be equal to the number of jpgs in dataset\normal\
reComputeFeature=true;
reTrainNetwork=false;

[myNet,trainNumberOfCancer,trainNumberOfOther ]=trainMyNetwork(numberofCancer,numberofOther,reComputeFeature,reTrainNetwork);
load trainData_standard_nomedian;
p=p';
t=t';
% % ptestRange=1+trainNumberOfCancer:numberofCancer;
% ptestRange=1:trainNumberOfCancer; %for exchanging train data and test data  
% ptest=p(:,ptestRange);
% testsize=size(ptest,2);
% % pOutput=cell(1,testsize+size(numberofCancer+1:numberofCancer+trainNumberOfOther,1)-1); 
% pOutput=zeros(2,testsize+size(numberofCancer+1:numberofCancer+trainNumberOfOther,1)-1);
pTarget=cell(1,size(t,2)); 
% ttest=zeros(13,0);
% hitnumber=0;
% p2=ptest;
% for i=1:size(ptest,2)    
%     ttest=[ttest sim(myNet,ptest(:,i))];
%     if t(1,i)==0.9
%         pTarget{1,i}='melanoma';
%     else
%         pTarget{1,i}='other';
%     end
%     pOutput(:,i)=ttest(:,i);
%     if(ttest(1,i)>ttest(2,i))
% %         pOutput{1,i}='melanoma'; 
% %       if t(1,trainNumberOfCancer+i)==0.9
%         if t(1,i)==0.9%for reverse test
%             hitnumber=hitnumber+1;
%         end
%     else
% %         pOutput{1,i}='other'; 
% %         p2=[p2 0];
% %         if t(2,trainNumberOfCancer+i)==0.9
%         if t(2,i)==0.9%for reverse test
%             hitnumber=hitnumber+1;
%         end  
%     end
% end
% disp('part 1 test size:');
% disp(size(ptest,2));
% % ptestRange=numberofCancer+trainNumberOfOther+1:numberofCancer+numberofOther;
% ptestRange=numberofCancer+1:numberofCancer+trainNumberOfOther; %for exchanging train data and test data  
% ptest=p(:,ptestRange);
% ttest=zeros(13,0);
% testsize=testsize+size(ptest,2);
% disp(size(ptest,2));
% p2=[p2 ptest];
% for i=1:size(ptest,2)    
%     ttest=[ttest sim(myNet,ptest(:,i))];
%     if t(1,numberofCancer+i)==0.9
%        pTarget{1,i+trainNumberOfCancer}='melanoma';
%     else
%        pTarget{1,i+trainNumberOfCancer}='other';
%     end
%     pOutput(:,i+trainNumberOfCancer)=ttest(:,i);
%     if(ttest(1,i)>ttest(2,i))
% %         pOutput{1,i+trainNumberOfCancer}='melanoma';
% %         if t(1,numberofCancer+trainNumberOfOther+i-1)==0.9  
%         if t(1,numberofCancer+i)==0.9  %for reverse test
%             hitnumber=hitnumber+1;
%         end
%     else
% %         pOutput{1,i+trainNumberOfCancer}='other';
% %         p2=[p2 0];
% %         if t(2,numberofCancer+trainNumberOfOther+i-1)==0.9
%         if t(2,numberofCancer+i)==0.9  %for reverse test
%             hitnumber=hitnumber+1; 
%         end
%     end
% end
% testsize;
% hitnumber;
% percentage=hitnumber/testsize*100;
% plotroc(pTarget,pOutput);
% p2=p2';
p2=p;
for index=1:size(t,2)
    if t(1,index)==0.9
       pTarget{1,index}='melanoma';
    else
       pTarget{1,index}='other';
    end
end
featureIndex=13;
[X,Y,T,AUC,OPTROCPT,SUBY,SUBYNAMES] = perfcurve(pTarget,p2(featureIndex,:),'melanoma'); 
plot(X,Y,'o--'); 
xlabel('False positive rate'); 
ylabel('True positive rate'); 
title([sprintf('ROC for Classification by feature %d  = ',featureIndex), num2str(AUC)]);
