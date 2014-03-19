%main method to build everything from scratch
%isolated=isolate(kinect_recyclebox_20frames);
for i=1:3
    isolist{i}=imageToList(iso{i});
end
[Ricp, Ticp, xyzlist2] = alignPoints2(isolist);
allpoints=[];
for i=1:3
    allpoints=[allpoints; xyzlist2{i}'];
end
allpoints=allpoints';
scatter3_kinectxyzrgb(allpoints);