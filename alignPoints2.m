function [Ricp, Ticp, xyzrgblist2] = alignPoints2(isolated)
%% 
% TODO - accept edge points separately, and give their contribution greater
% weight, and use it to initialize the main ICP
% TODO - center the points first
% Ricp{i} and Ticp{i} are the rotation and translation matrices, that aim to transform the points
% in xyzlist{i} to the points in xyzlist{i+1}
% xyzlist2 comprises all of the points in xyzlist{1:20}, transformed and
% placed in a single 3D image
% Code adapted from the icp demo on www.mathworks.com/matlabcentral/fileexchange/27804-iterative-closest-point
[~,numFrames]=size(isolated);
totalPoints=0;
for i=1:numFrames
    fprintf('preparing frame %d\n',i);
    xyzrgblist{i}=imageToList(isolated{i})';
    [~,n{i}]=size(xyzrgblist{i});
    totalPoints=totalPoints+n{i};
end
%find the necessary rotation and transform matrices between each frame.
for i=1:numFrames
    if (i~=10)
        fprintf('integrating frame %d\n',i)
        j=1;
        [Ricp{i} Ticp{i} ER{i} t{i}] = icp(xyzrgblist{i}(1:3,:), xyzrgblist{10}(1:3,:), 'Matching', 'Delaunay');
    end
end
%transform the points so as to create a single 3D image containing all the
%points
for i=1:numFrames 
    if (i~=10)
        fprintf('transforming frame %d\n',i)
        fprintf('\tusing the transform from frame %d\n',j);
        xyzrgblist2{i}=Ricp{i}*xyzrgblist{i} + repmat(Ticp{i}, 1, n{i});
    end
end
end