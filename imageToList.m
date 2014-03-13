function [list] = imageToList(img)
%Converts a 480*640 image to a list of points
[W,B,L]=size(img);
list = reshape(img(:,:,:),W*B,L);
list = list(any(list,2),:);
list=unique(list,'rows');
end