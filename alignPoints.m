function [Ricp, Ticp, xyzlist2] = alignPoints(isolated)
%% 
% Ricp{i} and Ticp{i} are the rotation and translation matrices, that aim to transform the points
% in xyzlist{i} to the points in xyzlist{i+1}
% xyzlist2 comprises all of the points in xyzlist{1:20}, transformed and
% placed in a single 3D image
% Code adapted from the icp demo on www.mathworks.com/matlabcentral/fileexchange/27804-iterative-closest-point
[~,numFrames]=size(isolated);
totalPoints=0;
for i=1:numFrames
    fprintf('preparing frame %n',i)
    xyzlist{i} = reshape(isolated{i}(:,:,1:3),640*480,3)';
    xyzlist{i}=unique(xyzlist{i}','rows')';
    [~,n{i}]=size(xyzlist{i});
    totalPoints=totalPoints+n{i};
end
%find the necessary rotation and transform matrices between each frame.
%TODO - also find the scale factor
%TODO - could perhaps use colour distance also
for i=1:(numFrames-1)
    fprintf('integrating frame %n',i)
    [Ricp{i} Ticp{i} ER{i} t{i}] = icp(xyzlist{i}, xyzlist{i+1}, 1, 'Matching', 'Delaunay');
end
xyzlist2=zeros(3,totalPoints);
%transform the points so as to create a single 3D image containing all the
%points
%TODO - %xyzlist2 should be coloured, use mean or median?
a=1;
for i=1:numFrames    
    fprintf('transforming frame %n',i)
    b=a+n{i}-1;
    xyzlist2(:,a:b)=xyzlist{i}(1:3,:);
    for j=1:(i-1)
        fprintf('\t using the transform from frame %n',i)
        xyzlist2(:,a:b)=Ricp{j}*xyzlist2(:,a:b) + repmat(Ticp{j}, 1, n{i});
    end
    a=a+n{i};
end
end