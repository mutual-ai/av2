function play_frames( kinect_data )
%PLAY_FRAMES Summary of this function goes here
%   Detailed explanation goes here
    for i = 1: length(kinect_data)
        xyzrgb = kinect_data{i};
        rgb = xyzrgb(:, :, 4:6)/255;
        imshow(rgb);
        pause(0.1);
end