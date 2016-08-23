load trainData p t;
%% inital values
p=p';
t=t';
%use how many cases of cancer to make up the data ,should be equal to the number of jpgs in dataset\cancer\
numberofCancer=58;
%use how many cases of other to make up the data ,should be equal to the number of jpgs in dataset\normal\
numberofOther=55;
featuresOfCancer=zeros(13,numberofCancer);
featuresOfOther=zeros(13,numberofOther);
Pvalue=zeros(13,1);
Hvalue=zeros(13,1);
%% divide the total data feature matrix into two sub matrix,one is for cancer the other is for none cancer
for i=1:size(featuresOfCancer,1)
    featuresOfCancer(i,:)=p(i,1:numberofCancer);
    featuresOfOther(i,:)=p(i,numberofCancer+1:numberofCancer+numberofOther);
    [H1,P1,CI]=ttest2(featuresOfCancer(i,1:numberofOther),featuresOfOther(i,1:numberofOther));
    Pvalue(i,:)=P1;
    Hvalue(i,:)=H1;
end
% [H2,P2,CI2]=ttest2(featuresOfCancer',featuresOfOther');%This is wrong, t
% test need the same size of samples.

    