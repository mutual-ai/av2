%main method to build everything from scratch
isolated=isolate(kinect_recyclebox_20frames);
[Ricp, Ticp, xyzlist2] = alignPoints(isolated);
plot3(xyzlist2(1,:),xyzlist2(2,:),xyzlist2(3,:),'k.','MarkerSize',0.1);