function [ isolated ] = isolate( kinect_data )
%ISOLATE Accepts a cell array of kinect xyzrgb data matrices and returns a cell
%array of xyzrg matrices with background and non-bin data points removed.
%   Detailed explanation goes here

isolated = cell(size(kinect_data));

%Operate one the cells one by one
for i = 1 : length(kinect_data)
    xyzrgb = kinect_data{i};
    rgb = xyzrgb(:,:,4:6);
    
    %Exclude all the rgb data points associated with NaN range values
    rgb(isnan(xyzrgb)) = 0;
    xyzrgb(:,:,4:6) = rgb;
    
    %Set all NaN range values to 0. This might be unnessecary
    xyzrgb(isnan(xyzrgb)) = 0;

    %Insert the isolated xyzrg into the return cell array
    isolated{i} = xyzrgb;
end

