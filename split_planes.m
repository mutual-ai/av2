function [ left, right ] = split_planes( xyzrgb )
%SPLIT_PLANES splits the image of the bin into two planes, exploiting the
%shape of the bin to find the middle point.

    xyz = xyzrgb(:,:,1:3);
    BW = edge(xyz(:,:,3));
    [B, L] = bwboundaries(BW, 'noholes');
    points = cell2mat(B(1));
    ys = points(:,1);
    idx = find(ys == max(ys));
    center = mean(points(idx,:));
    center_x = center(2);
    
    %Create the masks
    [x, y, ~] = size(xyz);
    left_mask = zeros([x,y]);
    right_mask = zeros([x,y]);
    left_mask(:,1:center_x) = 1;
    right_mask(:,center_x:x) = 1;
    
    left = xyzrgb.*repmat(left_mask, [1, 1, 6]);
    right = xyzrgb.*repmat(right_mask, [1, 1, 6]);

end

