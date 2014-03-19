function [ edges, filled ] = find_s( xyzrgb )
%FIND_SS given a single fram of xyzrgb values, return a bitmask that gives
%the location of the Ss in that image.
    rgb = xyzrgb(:,:,4:6);
    grey = rgb2gray(rgb/255);
    BW = edge(rgb(:,:,1), 'canny', 0.3);
    BW = bwmorph(BW, 'bridge'); 
    BW2 = imfill(BW, 'holes');
    cc1 = bwconncomp(BW);
    cc = bwconncomp(BW2);
    stats = regionprops(cc, grey, 'MeanIntensity', 'Area');
    [~, idx] = nSorted([stats.MeanIntensity], 4, 'descend');
    areaIdx = find([stats.Area] > 100);
    idx_all = intersect(idx, areaIdx);
    edges = ismember(labelmatrix(cc1), idx_all);
    filled = ismember(labelmatrix(cc), idx_all);
end

