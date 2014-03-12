function [Ricp, Ticp, xyzlist2] = alignPoints(xyzlist)
%% 
% Ricp{i} and Ticp{i} are the rotation and translation matrices, that aim to transform the points
% in xyzlist{i} to the points in xyzlist{i+1}
% xyzlist2 comprises all of the points in xyzlist{1:20}, transformed and
% placed in a single 3D image
% Code adapted from the icp demo on www.mathworks.com/matlabcentral/fileexchange/27804-iterative-closest-point
[~,numFrames]=size(xyzlist);
Ricp=cell(19);
Ticp=cell(19);
ER=cell(19);
t=cell(19);
n=cell(19);
totalPoints=0;
%find the necessary rotation and transform matrices between each frame.
%TODO - also find the scale factor
for i=1:(numFrames-1)
    [Ricp{i} Ticp{i} ER{i} t{i}] = icp(xyzlist{i}, xyzlist{i+1}, 15, 'Matching', 'Delaunay', 'Extrapolation', true);
    [n{i},~]=size(xyzlist{i});
    totalPoints=totalPoints+n{i};
end
xyzlist2=zeros(totalPoints,3);
%transform the points so as to create a single 3D image containing all the
%points
a=1;
for i=1:(numFrames-1)
    b=a+n{i}-1;
    xyzlist2(:,a:b)=Ricp{i}*xyzlist{i} + repmat(Ticp{i}, 1, n{i});
    a=a+n{i};
end
end