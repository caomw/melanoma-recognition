function [OutputX,OutputY] = getInnerBoundOfXY( X,Y)
%GETINNERBOUNDOFXY Summary of this function goes here
%   Detailed explanation goes here
     OutputX=zeros(size(X,1),1);
    OutputY=zeros(size(Y,1),1);
    
    Xright=X(:,3);
    Ybottom=Y(:,2);
    
    rightPoint=[Xright(:,1),Y(:,1)];
    bottomPoint=[X(:,1),Ybottom(:,1)];
    
    rightBottomPoint=ones(size(X,1),2);
    rightBottomPoint(:,1)=max(X(:))+3;
    rightBottomPoint(:,2)=min(Y(:));%max(Y(:));
    rightDis=pdist2(rightPoint,rightBottomPoint);
    bottomDis=pdist2(bottomPoint,rightBottomPoint);
    for index=1:size(X,1)
        if rightDis(index,1)<=bottomDis(index,1)
            OutputX(index,1)=rightPoint(index,1);
            OutputY(index,1)=rightPoint(index,2);
        else
            OutputX(index,1)=bottomPoint(index,1);
            OutputY(index,1)=bottomPoint(index,2);
        end
    end
    [C,i,j]=unique(OutputY,'rows');
    for index=1:length(C)
        [m n]=find(OutputY==C(index));
        if length(m)>=2%duplicated of OutputY
            temp=OutputX([m n]);
            temp=max(temp(:));
            disp(temp);
            OutputX([m n])=temp;
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

