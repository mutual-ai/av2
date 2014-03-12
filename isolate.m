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
    
    %Use the color data to isolate the box further
    reds = rgb(:,:,1) > 120 & rgb(:,:,2) < 100;
    reds_l = bwlabel(reds, 4);
    stats = regionprops(reds_l, 'Area', 'Orientation');
    
    %Get the largest four groups that are mostly oriented on the x axis
    [sorted_values, sort_idx] = sort([stats.Area], 'descend');
    max_idx = sort_idx(1:4);
    large_red_groups(max_idx) = stats(max_idx);
    
    %Now remove all groups that aren't aligned with the x axis
    for i = 1 : length(large_red_groups)
        if large_red_groups(i) == [] || abs(large_red_groups(i).Orientation) > 10
            large_red_groups(i) = [];
            continue;
        end
    end
    lrag = large_red_groups;
    
    %remove all pixels that aren't in the large red groups
    
    
    xyzrgb(:,:,4:6) = rgb;
    
    %Set all NaN range values to 0. This might be unnessecary
    xyzrgb(isnan(xyzrgb)) = 0;

    %Insert the isolated xyzrg into the return cell array
    isolated{i} = xyzrgb;
end

