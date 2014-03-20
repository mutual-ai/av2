function [] = scatter3_kinectxyzrgb(xyzrgblist)
%modified

% convert from 640x480 image to 307200x6 point list 
xyz  = xyzrgblist(:,1:3);
rgb  = xyzrgblist(:,4:6);
xyzrgb_frame = [ xyz , rgb ];

% only plot valid points (strip out NaN rows)
ind          = ~any(isnan(xyzrgb_frame),2);
xyzrgb_frame = xyzrgb_frame(ind,:);
% set colourmap
colormap(gca,xyzrgb_frame(:,4:6)/255);
% unit^2 area per point to plot
scalar = 5;
S = ones(length(xyzrgb_frame),1) * scalar;
% scatter plot our coloured point cloud
scatter3(xyzrgb_frame(:,1),xyzrgb_frame(:,2),xyzrgb_frame(:,3),S(:),1:length(xyzrgb_frame),'filled');
% draw full screen
set(gcf, 'Position', [get( 0, 'ScreenSize' )]);

end

