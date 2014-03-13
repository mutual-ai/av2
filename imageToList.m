function [list] = imageToList(img)
%Converts a 480*640 image to a list of points
[W,B,L]=size(img);
list = reshape(img(:,:,:),W*B,L);
list=unique(list,'rows')';
list(:,all(list(1:3,:)==0,1))=[];
end