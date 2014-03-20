function [ isolated ] = isolate( kinect_data )
%ISOLATE Accepts a cell array of kinect xyzrgb data matrices and returns a cell
%array of xyzrg matrices with background and non-bin data points removed.
%   Detailed explanation goes here

isolated = cell(size(kinect_data));

%Operate one the cells one by one (exclude the last 3 right now 
for i = 1 : length(kinect_data)
    xyzrgb = kinect_data{i};
    rgb = xyzrgb(:,:,4:6);
    
    %Exclude all the rgb data points associated with NaN range values
    rgb(isnan(xyzrgb)) = 0;
    
    %Use the color data to isolate the box further

    red_bits = rgb(:,:,1) > 120 & rgb(:,:,2) < 110 & rgb(:,:,3) < 110;

    cc = bwconncomp(red_bits);

    %Isolate the orange bin edge groups using Area and Orientation
    red_bits = rgb(:,:,1) > 120 & rgb(:,:,2) < 110 & rgb(:,:,3) < 110;

    cc = bwconncomp(red_bits);
    stats = regionprops(cc, 'Area', 'Orientation', 'BoundingBox');
    idx = find([stats.Area] > 200 & abs([stats.Orientation]) < 10);
    r_stats = stats(idx);
    red_edges = ismember(labelmatrix(cc), idx);
    
    
    %Fill in the gaps between the edges
    bb1 = [r_stats(1).BoundingBox];
   
    if length(idx) < 2
        %Fill right to the top
        left = round(bb1(1));
        right = round(bb1(1) + bb1(3));
        bottom = round(bb1(2) + (bb1(4)/2));
    else
        %Fill to the top edge of the bin
        bb2 = [r_stats(2).BoundingBox];
        bbheight = round(max([bb1(4) bb2(4)])/2);
        bottom = round(max([bb1(2) bb2(2)]) + bbheight/2);
        left = round(min([bb1(1) bb2(1)]));
        right = left + round(max([bb1(3) bb2(3)]));
    end

    bin_mask = zeros(size(red_edges));
    bin_mask(1:bottom, left:right) = 1;
    bin_cbits = (red_edges | bin_mask);

    %Close any small gaps in the mask
    se = strel('square', 10);
    bin_cbits = imclose(bin_cbits, se);
    
    %Reassign 0 vals where NaNs were
    xyzrgb(:,:,4:6) = rgb;
    
    %Set all NaN range values to 0.
    xyzrgb(isnan(xyzrgb)) = 0;
    
    xyzrgb_cbin = xyzrgb.*repmat(bin_cbits,[1,1,6]);
    
    outliers = outlier_idx(xyzrgb_cbin(:,:,3));
    bin_bits = bin_cbits - outliers;

    %Insert the isolated xyzrg into the return cell array
    %Repmat modifies xyzrgb to be 0 vals wherever bin_bits is a 0.
    isolated{i} = xyzrgb_cbin.*repmat(bin_bits,[1,1,6]);
end

