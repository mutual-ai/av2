%Load aligned data
load('xyzlist2');
%Set full screen
h = figure('units','normalized','outerposition',[0 0 1 1], 'Visible', 'off');
for i = 1 : 1;
    xyzrgb = horzcat(xyzlist2{1:i});
    xyz = xyzrgb(1:3,:);
%     rgb = xyzrgb(4:6, :);
    
    subplot(2,2,1);
    plot3(xyz(1,:),xyz(2,:),xyz(3,:),'k.', 'MarkerSize', 0.1);
    view(180, 0);
    
    subplot(2,2,2);
    scatter3_kinectxyzrgb(xyzrgb);
    view(0, 90);
    saveas(h, strcat('test', num2str(i)), 'jpg');
end