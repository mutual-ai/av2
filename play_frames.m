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
        end
        pause(0.1);
    end
end