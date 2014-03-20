function [angle] = angleBetweenPlanes(plane1,plane2)
a=plane1(1:3);
b=plane2(1:3);
angle=acos(dot(a,b)/(norm(a)*norm(b)));
end