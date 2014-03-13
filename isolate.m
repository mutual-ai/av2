function [ isolated ] = isolate( kinect_data )
%ISOLATE Accepts a cell array of kinect xyzrgb data matrices and returns a cell
%array of xyzrg matrices with background and non-bin data points removed.
%   Detailed explanation goes here

isolated = cell(size(kinect_data));

%Operate one the cells one by one (exclude the last 3 right now 
for i = 1 : 17
    xyzrgb = kinect_data{i};
    rgb = xyzrgb(:,:,4:6);
    
    %Exclude all the rgb data points associated with NaN range values
    rgb(isnan(xyzrgb)) = 0;
    
    %Use the color data to isolate the box further
    reds = rgb(:,:,1) > 120 & rgb(:,:,2) < 110 & rgb(:,:,3) < 110;
    
    cc = bwconncomp(reds);
    stats = regionprops(cc, 'Area', 'Orientation', 'BoundingBox');
    idx = find([stats.Area] > 200 & abs([stats.Orientation]) < 10);
    r_stats = stats(idx);
    red_edges = ismember(labelmatrix(cc), idx);
    
    %Fill in the gaps between the edges
    bb1 = [r_stats(1).BoundingBox];
    bb2 = [r_stats(2).BoundingBox];
    top = round(min([bb1(2) bb2(2)]));
    width = round(max([bb1(3) bb2(3)]));
    height = round(max([bb1(2) bb2(2)]) + bb2(4) - top);
    
    se = strel('rectangle', [height width]);
    %bin_bits is now a binary mask for data we want to keep
    bin_bits = imclose(red_edges, se);
    
    xyzrgb(:,:,4:6) = rgb;
    
    %Set all NaN range values to 0.
    xyzrgb(isnan(xyzrgb)) = 0;

    %Insert the isolated xyzrg into the return cell array
    %Repmat modifies xyzrgb to be 0 vals wherever bin_bits is a 0.
    isolated{i} = xyzrgb.*repmat(bin_bits,[1,1,6]);
end

