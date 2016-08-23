function [OutputX,OutputY] = getOutterBoundOfXY(X,Y)
%   To combine with perfcurve,to get the outter bound of
%   that roc curve
    OutputX=zeros(size(X,1),1);
    OutputY=zeros(size(Y,1),1);
    
    Xleft=X(:,2);
    Ytop=Y(:,3);
    
    leftPoint=[Xleft(:,1),Y(:,1)];
    topPoint=[X(:,1),Ytop(:,1)];
    %% if the point has only Vertical error bar, then we should choose itself as the outer bound Otherwise the curve will become weird
    
    for index=1:size(X,1)
        if(X(index,2)==X(index,1))
            topPoint(index,2)=Y(index,1);
        end
    end
    
    leftTopPoint=ones(size(X,1),2);
    leftTopPoint(:,1)=min(X(:))-3;%-4
    leftTopPoint(:,2)=max(Y(:));%max(Y(:));
    leftDis=pdist2(leftPoint,leftTopPoint);
    topDis=pdist2(topPoint,leftTopPoint);
    for index=1:size(X,1)
        if leftDis(index,1)<=topDis(index,1)
            OutputX(index,1)=leftPoint(index,1);
            OutputY(index,1)=leftPoint(index,2);
        else
            OutputX(index,1)=topPoint(index,1);
            OutputY(index,1)=topPoint(index,2);
        end
    end
    [C,i,j]=unique(OutputY,'rows');
    for index=1:length(C)
        [m n]=find(OutputY==C(index));
        if length(m)>=2%duplicated of OutputY
            temp=OutputX(n);
            temp=min(temp(:));
            disp(temp);
            OutputX(n)=temp;
        end
    end
    [C,i,j]=unique([OutputX OutputY],'rows');
    for index=1:length(C)
        [m n]=find([OutputX OutputY]==C(index));
        if length(m)>=2%duplicated of OutputY
            OutputX(n)=NaN;
            OutputY(n)=NaN;
        end
    end
end

