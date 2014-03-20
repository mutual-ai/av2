function [ vals, idx ] = nSorted( A, n, order )
%NSMALLEST returns the n sorted vals and index of the n smallest/largest elements 
%   Detailed explanation goes here
    [ASorted, AIdx] = sort(A, order);
    vals = ASorted(1:n);
    idx = AIdx(1:n);
end

