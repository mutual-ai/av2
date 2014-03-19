function [ rangeEdges ] = edgeRangeData( isolated )
%Function that exploits the color information of a 2d image to extract the
%range information of just the edges. Returns  both range and rgb values.
%   Works best if called with an already isolated dataset.
    rangeEdges = cell(size(isolated));
    for i = 1 : length(isolated)
        xyzrgb = isolated{i};
        [edges, ~] = find_s(xyzrgb);
        rangeEdges{i} = xyzrgb.*repmat(edges, [1,1,6]);
    end    
end

