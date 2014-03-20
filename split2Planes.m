function [plane1points, plane2points] = split2Planes(plane1, plane2, pointlist)
[numPoints,~]=size(pointlist);
plane1points=[];
plane2points=[];
pnt = ones(4,1);
plane1points=zeros(size(pointlist));
plane2points=zeros(size(pointlist));
a=1;
b=1;
% splits a set of points between the two planes
for i=1:numPoints
    pnt(1:3) = pointlist(i,1:3);
    dist1=abs(pnt*plane1);
    dist2=abs(pnt*plane2);
    % see if point lies in the plane
    %if (dist1<dist2)
    if (rand()<rand())
        plane1points(a,:)=pointlist(i,:);
        a=a+1;
    else
        plane2points(b,:)=pointlist(i,:);
        b=b+1;
    end
end
plane1points( ~any(plane1points,2), :) = [];
plane2points( ~any(plane2points,2), :) = [];
end