function [projectedPoints] = projectPoints(pointslist, plane)
%projects the points to the plane
[numPoints,columns]=size(pointslist);
projectedPoints=zeros(numPoints,columns);
projectedPoints(:,4:6)=pointslist(:,4:6);
for i=1:numPoints
    %lets just hope this point is on the plane
    pointOnThePlane=[0,0,-plane(4)/plane(3)];
    projectedPoints(i,1:3)=pointslist(i,1:3) - dot(pointslist(i,1:3) - pointOnThePlane, plane(1:3)) * plane(1:3);
end
end