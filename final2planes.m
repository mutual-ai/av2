%function [plane1,plane2] = final2planes(isolated)
for i=1:20
    listopoints=imageToList(isolated{i});
    %thin the point cloud, for quick testing
    [numPoints,~]=size(listopoints);
    %r=[];
    %for p=1:numPoints
    %    r(p)=rand()>0.05;
    %end
    %listopoints(logical(r),:)=[];
    points = growTwoPlanes(listopoints);
    planepoints{1,i} = points{1};
    planepoints{2,i} = points{2};
    bothPlanes{i}=[planepoints{1,i}; planepoints{2,i}];
end
%bothPlanes is the point set without outliers - but should still be
%re-split into better planes
[Ricp, Ticp, ~] = alignPoints2(bothPlanes,[]);
[~,numFrames]=size(bothPlanes);
midFrame=round(numFrames/2);
%transform the points so as to create a single 3D image containing all the
%points - but two sets, one for each plane
for p=1:2
    transformedPlanePoints{p}=[];
    numPointsPlane(p)=0;
    for i=1:numFrames
        [n{i},~]=size(planepoints{p,i});
        numPointsPlane(p)=numPointsPlane(p)+n{i};
    end
    for i=1:numFrames
        fprintf('transforming frame %d\n',i);  
        if (i~=midFrame)
            fprintf('\tusing the transform from frame %d\n',i);
            transformedPlanePoints{p}=[transformedPlanePoints{p}; (Ricp{i}*planepoints{p,i}(:,1:3)' + repmat(Ticp{i}, 1, n{i}))', planepoints{p,i}(:,4:6)];
        else
            transformedPlanePoints{p}=[transformedPlanePoints{p}; planepoints{p,i}(:,:)];
        end
    end
end

fprintf('Fitting two planes to the current set of two points\n');
for p=1:2
    [plane(p,:),resid(p)] = fitplane(transformedPlanePoints{p}(:,1:3));
end
transformedPlaneAllPoints=[transformedPlanePoints{1}; transformedPlanePoints{2}];
fprintf('Splitting the points between the final 2 planes\n');
[plane1points, plane2points] = split2Planes(plane(1,:), plane(2,:), transformedPlaneAllPoints);
transformedSplitPlanePoints{1}=plane1points;
transformedSplitPlanePoints{2}=plane2points;
for p=1:2
    fprintf('Printing plane %d\n',p);    
    %plot the planes, using code from
    %http://stackoverflow.com/questions/3461869/how-to-plot-a-plane-in-matlab-or-scipy-matplotlib
    normal = plane(p,1:3);    
    %# a plane is a*x+b*y+c*z+d=0
    %# [a,b,c] is the normal. Thus, we have to calculate
    %# d and we're set
    %d = -point*normal'; %'# dot product for less typing
    d=plane(p,4);    
    %# create x,y
    [xx,yy]=ndgrid(-40:20,-30:30);
    xx=xx/100;
    yy=yy/100;    
    %# calculate corresponding z
    z = (-normal(1)*xx - normal(2)*yy - d)/normal(3);
    %# plot the surface
    hold on;
    surf(xx,yy,z)
    fprintf('Projecting all points in plane %d to the plane\n',p);
    projectedPoints{p}=projectPoints(transformedSplitPlanePoints{p}, plane(p,:));
    fprintf('Displaying projected points in plane %d\n',p);
    scatter3_kinectxyzrgb(projectedPoints{p});
end
angle=angleBetweenPlanes(plane(1,:),plane(2,:));
fprintf('The angle between the two planes is %d\n',angle);
%end