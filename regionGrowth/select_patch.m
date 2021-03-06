% find a candidate planar patch
function [fitlist,plane] = select_patch(points)

  [L,D] = size(points);
  tmpnew = zeros(L,D);
  tmprest = zeros(L,D);

  % pick a random point until a successful plane is found
  success = 0;
  while ~success
    idx = floor(L*rand);
    %idx=6861;
    pnt = points(idx,:);
  
    % find points in the neighborhood of the given point
    DISTTOL = 0.03;
    fitcount = 0;
    restcount = 0;
    for i = 1 : L
      dist = norm(points(i,1:3) - pnt(1:3));
      if dist < DISTTOL
        fitcount = fitcount + 1;
        tmpnew(fitcount,:) = points(i,:);
      else
        restcount = restcount + 1;
        tmprest(restcount,:) = points(i,:);
      end
    end
    oldlist = tmprest(1:restcount,:);
    
    if fitcount > 10
      % fit a plane
      [plane,resid] = fitplane(tmpnew(1:fitcount,:));
      if resid < 0.002
        fitlist = tmpnew(1:fitcount,:);
        return
      end
    end
  end  
