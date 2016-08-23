
%% load and initialize the vars
load networkSave/KFoldResult_8938_5000_sim_50node_11;
correctRate=90.27;
%T_sim is the simulation result from the nerual network
T_sim=classResult(2,:);
validation_set_output=classResult(3,:);

%% output to class correct rate to txt for statistics
% fid = fopen('b.txt','w');
% for i=1:size(classResult,2)
%     fprintf(fid,'%g\n',classResult{4,i}.correctRate);
% end
% fclose(fid);
% return;

%% Get the 10-fold validation result 
c1=cell(1,size(T_sim,2));
c2=cell(1,size(T_sim,2));
for index=1:size(T_sim,2)
    classOutput=T_sim{1,index};
    label=validation_set_output{1,index};
    tempIndex=(label(1,:)==0.9);
    classTarget=cell(1,size(label,2));
    classTarget(1,tempIndex)=cellstr('melanoma');
    classTarget(1,~tempIndex)=cellstr('other');
    c1{index}=classTarget;
    c2{index}=classOutput(1,:);
    % bad polyfit for the roc,forget this
    %     [y1,~,mu]=polyfit(X,Y,4);
    %     X1=0:0.01:1;
    %     Y1=polyval(y1,X1,[],mu);
    %     plot(X,Y,'o--',X1,Y1,'g--');
    %     return;
    
    %     plot(X,Y,'o--');
    %     while size(X,1)<13
    % %         disp(X);
    %         for j=1:size(X,1)
    %             if(X(j,1)<X(j+1,1))
    %
    %             end
    %         end
    %     end
    %     newY=interp1(X,Y,newX,'spline');
end
%% plot the ROC curve
[X,Y,T,AUC,OPTROCPT,SUBY,SUBYNAMES] = perfcurve(c1,c2,'melanoma');
hold on;
%errorbar(X(:,1),Y(:,1),Y(:,3)-Y(:,1),'b');
%herrorbar(X(:,1),Y(:,1),X(:,3)-X(:,1),'r');
%[X2,Y2]=getOutterBoundOfXY(X,Y);
%[X3,Y3]=getInnerBoundOfXY(X,Y);
plot(X(:,1),Y(:,1),'bx-');
 %plot(X2,Y2,'ro-');
 %plot(X3,Y3,'rx-');
 legend('mean roc','outer bound of roc','inner bound of roc','Location','SouthEast');
% %errorbar(X(:,1),Y(:,1),ones(size(Y,1),1)*stderror,'rx');
xlabel('False positive rate(sensitivity)');
ylabel('True positive rate(specificity)');
title({sprintf('%d-fold vation ROC with a correct rate of %.2f%c'...
,index,correctRate);sprintf('AUC=%s (lower:%s,upper:%s)',num2str(AUC(1,1)),num2str(AUC(1,2)),num2str(AUC(1,3)))});
fprintf('1-specificity:%.4f , sensitivity:%.4f',1-OPTROCPT(1,1),OPTROCPT(1,2));
[X,Y,T,AUC,OPTROCPT,SUBY,SUBYNAMES] = perfcurve(c1,c2,'melanoma');
% [X5,Y5,T,AUC,OPTROCPT,SUBY,SUBYNAMES] = perfcurve(c1,c2,'melanoma','xCrit','sens','yCrit','spec');
