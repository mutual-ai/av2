function [pointlist2,meanPosition] = centreByMean(pointlist)
%% takes a point cloud, and translates it to have zero mean
pointlist2=pointlist';
meanPosition=mean(pointlist2,2);
[~,numPoints]=size(pointlist2);
pointlist2(1:3,:)=pointlist2(1:3,:) - repmat(meanPosition, 1, numPoints);
pointlist2=pointlist2';
end