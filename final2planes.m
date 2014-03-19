%function [plane1,plane2] = final2planes(isolated)
for i=1:20
    points = growTwoPlanes(isolated{i});
    planepoints{1,i} = points{1};
    planepoints{2,i} = points{2};
    bothPlanes{i}=[planepoints{1,i}; planepoints{2,i}];
end

[Ricp, Ticp, ~] = alignPoints(bothPlanes);
%transform the points so as to create a single 3D image containing all the
%points - but two sets, one for each plane
for p=1:2
    fprintf('Processing plane %d\n',p);
    a(p)=1;
    numPointsPlane(p)=0;
    for i=1:numFrames
        [~,n{i}]=size(planepoints{p,i});
        numPointsPlane(p)=numPointsPlane(p)+n{i};
    end
    for i=1:numFrames
        fprintf('transforming frame %d\n',i);
        transformedPlanePoints{p}=zeros(6,numPointsPlane(p));
        b(p)=a(p)+n{i}-1;
        transformedPlanePoints{p}(:,a(p):b(p))=planepoints{p,i}(:,:);
        for j=1:(i-1)
            fprintf('\tusing the transform from frame %d\n',j);
            transformedPlanePoints{p}(1:3,a(1):b(1))=Ricp{j}*transformedPlanePoints{p}(1:3,a(p):b(p)) + repmat(Ticp{j}, 1, n{i});
        end
        a(p)=a(p)+n{i};
    end
    [plane(p,:),resid(p)] = fitplane(transformedPlanePoints{p});
    
    %plot the planes, using code from
    %http://stackoverflow.com/questions/3461869/how-to-plot-a-plane-in-matlab-or-scipy-matplotlib
    %point = [1,2,3];
    %normal = [1,1,2];
    normal = plane(p,1:3);
    
    %# a plane is a*x+b*y+c*z+d=0
    %# [a,b,c] is the normal. Thus, we have to calculate
    %# d and we're set
    %d = -point*normal'; %'# dot product for less typing
    d=plane(p,4);
    
    %# create x,y
    [xx,yy]=ndgrid(-40:20,-30:30)/100;
    
    %# calculate corresponding z
    z = (-normal(1)*xx - normal(2)*yy - d)/normal(3);
    
    %# plot the surface
    hold all;
    figure
    surf(xx,yy,z)
end