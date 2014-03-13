function [ outliers ] = outlier_idx( M )
%returns a logical matrix of all the outliers (points that are 3*sigma from
%the mean(mu)
    vals = reshape(M, [], 1);
    %Get non zero elements
    vals = vals(find(vals));
    outliers = abs(M - median(vals)) >= (3*std(vals));
end

