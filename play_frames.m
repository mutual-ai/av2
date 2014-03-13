function play_frames( kinect_data, mode )
%PLAY_FRAMES Summary of this function goes here
%   Detailed explanation goes here
if nargin < 2
    mode = 'rgb';
end
    for i = 1: length(kinect_data)
        xyzrgb = kinect_data{i};
        rgb = xyzrgb(:, :, 4:6);
        switch mode
            case 'rgb'
                imshow(rgb/255);
            case 'bool'
                imshow(rgb(:,:,1) > 120 & rgb(:,:,2) < 100);
            case 'depth'
                xyz = reshape(xyzrgb(:,:,1:3),640*480,3);
                xyz(find(xyz == 0)) = NaN;
                plot3(xyz(:,1),xyz(:,2),xyz(:,3), 'k.', 'MarkerSize', 0.1);
                view(180, 0);
                h=gca;
                axis(h,'tight');
        end
        pause();
    end
end