function [ left, right ] = split_planes( xyzrgb )
%SPLIT_PLANES splits the image of the bin into two planes, exploiting the
%shape of the bin to find the middle point.
    
    %Extract the data points
    xyz = xyzrgb(:,:,1:3);
    %Get the boundary around the data points
    BW = edge(xyz(:,:,3));
    [B, L] = bwboundaries(BW, 'noholes');
    %Get the pixel location vectors
    points = cell2mat(B);
%     ys = points(:,1);
%     idx = find(ys == max(ys));
%     if length(idx) > 1
%         center = mean(points(idx,:));
%     else
%         center = points(idx,:);
%     end
    %Find the middle of the bin
    xs = points(:,2);
    center_x = floor((min(xs) + max(xs)) / 2);
%     center_x = center(2);
    %Create the masks
    [x, y, ~] = size(xyz);
    left_mask = zeros([x,y]);
    right_mask = zeros([x,y]);
    left_mask(:,1:center_x) = 1;
    right_mask(:,center_x:x) = 1;
    
    %Create the masked data sets
    left = xyzrgb.*repmat(left_mask, [1, 1, 6]);
    right = xyzrgb.*repmat(right_mask, [1, 1, 6]);

end

