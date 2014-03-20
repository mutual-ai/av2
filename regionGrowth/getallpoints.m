% selects all points in pointlist P that fit the plane and are within
% TOL of a point already in the plane (oldlist)
function [newlist,remaining] = getallpoints(plane,oldlist,P,NP)

  pnt = ones(4,1);
  [N,W] = size(P);
  [Nold,W] = size(oldlist);
  DISTTOL = 0.025;
  PLANETOL = 0.15;
  tmpnewlist = zeros(NP,6);
  tmpnewlist(1:Nold,:) = oldlist;       % initialize fit list
  tmpremaining = zeros(NP,6);           % initialize unfit list
  countnew = Nold;
  countrem = 0;
 
  for i = 1 : N
    pnt(1:3) = P(i,1:3);
    notused = 1;

    % see if point lies in the plane
    if abs(pnt'*plane) < DISTTOL
      % see if an existing nearby point already in the set
      for k = 1 : Nold
        if norm(oldlist(k,1:3) - P(i,1:3)) < PLANETOL
          countnew = countnew + 1;
          tmpnewlist(countnew,:) = P(i,:);
          notused = 0;
          break;
        end
      end      
    end
  
    if notused
      countrem = countrem + 1;
      tmpremaining(countrem,:) = P(i,:);
    end
  end

  newlist = tmpnewlist(1:countnew,:);
  remaining = tmpremaining(1:countrem,:);
countnew;
countrem;
Nold;

