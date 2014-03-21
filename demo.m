%Load the data in all its glory
% load('kinect_recyclebox_20frames');
% load('isolated');
% load('xyzlist2');
% load('slow_grown_planes');
f1 = figure('Name', 'Raw 2D');
f2 = figure('Name', 'Raw 3D');
f3 = figure('Name', 'Isolated 2D');
f4 = figure('Name', 'Isolated 3D');
f5 = figure('Name', 'Colored 3D');
f6 = figure('Name', 'Merged 2D');
f7 = figure('Name', 'Merged 3D');
f8 = figure('Name', 'Colored Merged 3D');

%Loop through 20 frames
for i = 1: 20
    raw_xyzrgb = kinect_recyclebox_20frames{i};
    raw_rgb = raw_xyzrgb(:, :, 4:6);
%     
% %   1)The original data image in 2D
    figure(f1);
    imshow(raw_rgb/255);
%     
% %   2)The original data image in 3D
    figure(f2);
    raw_xyz=imageToList(raw_xyzrgb(:,:,1:3));
    axis tight;
    plot3(raw_xyz(:,1),raw_xyz(:,2),raw_xyz(:,3), 'k.', 'MarkerSize', 0.1);
    view(0, 90);
%     
% %   3)The bin's 2D points extracted for the current image
    figure(f3);
    isol = isolated{i};
    iso_rgb = isol(:,:,4:6);
    imshow(iso_rgb/255);
%     
% %   4)The bin's 3D points extracted for the current image, as range points
    figure(f4);
    iso_xyz = imageToList(isol(:,:,1:3));
    plot3(iso_xyz(:,1),iso_xyz(:,2),iso_xyz(:,3), 'k.', 'MarkerSize', 0.1);
    
%   5)The bin's 3D points extracted for the current image,
%   coloured with the original colour
    figure(f5);
    isol_list = imageToList(isol);
    scatter3_kinectxyzrgb(isol_list);
    
%   6)The merged bin 2D points after the current image
%     figure(f6);
    merged_data = horzcat(xyzlist2{1:i}); 
    
%   7) The merged bin 3D points after the current image, as uncoloured points
    figure(f7);
    m_xyz = merged_data(1:3,:);
    plot3(m_xyz(1,:), m_xyz(2,:), m_xyz(3,:), 'k.', 'MarkerSize', 0.1);
    
%   8) The merged bin 3D points after the current image,
%   coloured with the original colour
    figure(f8);
    scatter3_kinectxyzrgb(merged_data');
    
%   9) The zoomed image of the leftmost white square
%   and nearby black pixels after merging
    f9 = copyobj(gcf,0);
    set(f9, 'Name', 'Merged Square');
    view(0,90);
    zoomcenter(-.09, -0.023, 3);
    
    
    
    pause()
end