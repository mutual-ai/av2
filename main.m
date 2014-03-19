%main method to build everything from scratch
%isolated=isolate(kinect_recyclebox_20frames);
[Ricp, Ticp, xyzlist2] = alignPoints2(isolated);
allpoints=[];
for i=1:20
    allpoints=[allpoints; xyzlist2{i}'];
end
allpoints=allpoints';
scatter3_kinectxyzrgb(allpoints);