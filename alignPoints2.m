function [Ricp, Ticp, xyzrgblist2] = alignPoints2(isolated,edges)
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
midFrame=round(numFrames/2);
for i=1:numFrames
    fprintf('preparing frame %d\n',i);
    xyzrgblist{i} = isolated{i};
    xyzrgblist{i} = xyzrgblist{i}(any(xyzrgblist{i},2),:);
    %xyzrgblist{i}=unique(xyzrgblist{i},'rows')';
    [~,n{i}]=size(xyzrgblist{i});
    if (~isempty(edges))
        fprintf('preparing edges of frame %d\n',i);
        xyzrgblistedges{i} = edges{i};
        xyzrgblistedges{i} = xyzrgblistedges{i}(any(xyzrgblistedges{i},2),:);
        xyzrgblistedges{i}=unique(xyzrgblistedges{i},'rows')';
        %[xyzrgblistedges{i},meanPosition] = centreByMean(xyzrgblistedges{i});
        %xyzrgblist{i}(1:3,:)=xyzrgblist{i}(1:3,:) - repmat(meanPosition, 1, n{i});
    end
end
for i=1:numFrames
    xyzrgblist2{i}=xyzrgblist{i};
    if (~isempty(edges))
        xyzrgblistedges2{i}=xyzrgblistedges{i};
    end
    if (i~=midFrame)
        fprintf('integrating frame %d\n',i)
        %find the necessary rotation and transform matrices between each frame.
        [Ricp{i}, Ticp{i}, ~, ~] = icp(xyzrgblist{midFrame}(1:3,:), xyzrgblist{i}(1:3,:), 'Matching', 'Delaunay');
        %transform the points so as to create a single 3D image containing all the
        %points
        if (~isempty(edges))
            fprintf('integrating edges of frame %d\n',i)
            [Ricpedges{i}, Ticpedges{i}, ~, ~] = icp(xyzrgblistedges{midFrame}(1:3,:), xyzrgblistedges{i}(1:3,:), 'Matching', 'Delaunay');
            a=0.9;
            b=1-a;
            Ricp=Ricp*b+Ricpedges*a;
            Ticp=Ticp*b+Ticpedges*a;
        end
        fprintf('transforming frame %d\n',i)
        xyzrgblist2{i}(1:3,:)=Ricp{i}*xyzrgblist{i}(1:3,:) + repmat(Ticp{i}, 1, n{i});
    end
end
end