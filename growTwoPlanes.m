function [save] = growTwoPlanes(R)

%R = load('rngdata.asc');
figure(1)
clf
plot3(R(:,1),R(:,2),R(:,3),'k.')

[NPts,W] = size(R);
patchid = zeros(NPts,1);
planelist = zeros(20,4);

% find surface patches
remaining = R;
NRemaining=NPts;
firstCycle=1;
i=0;
while ((NRemaining/NPts)>0.15)
    i=i+1;
    %keep going till most points are assigned to a plane
    
    % select a random small surface patch
    [oldlist,plane] = select_patch(remaining);
    
    % grow patch
    stillgrowing = 1;
    oldstillgrowing=0;
    c=[];
    while stillgrowing>oldstillgrowing
        
        % find neighbouring points that lie in plane
        oldstillgrowing = stillgrowing;
        [newlist,remaining] = getallpoints(plane,oldlist,remaining,NPts);
        [NewL,~] = size(newlist);
        [OldL,~] = size(oldlist);
        save{i}=newlist;
        [numPointsInPlane(i),~]=size(save{i});
        clf;
        hold all;
        plot3(remaining(:,1),remaining(:,2),remaining(:,3),'.k');
        for p=1:i
            plot3(save{p}(:,1),save{p}(:,2),save{p}(:,3),'.');
        end
        c=[];
        pause(0.1);
        
        if NewL > OldL + 4
            % refit plane
            [newplane,fit] = fitplane(newlist);
            [newplane',fit,NewL];
            planelist(i,:) = newplane';
            if fit > 0.2*NewL       % bad fit - stop growing
                break
            end
            stillgrowing = 1+stillgrowing
            oldlist = newlist;
            size(newlist)
            plane = newplane;
            c = 1;
            pause(0.1);
        end
    end
    [NRemaining,~]=size(remaining);
    waiting=1
    pause(1)
end
savebackup=save;
numPointsInPlanebackup=numPointsInPlane;
remainingbackup=remaining;
ibackup=i;

while (i>2) %while still more than two planes, delete the smallest
    [~,minIndex]=min(numPointsInPlane);
    %delete the plane indexed by minIndex - it is the smallest
    %first free up it's points
    size(remaining)
    remaining=[remaining; save{minIndex}];
    disp 'deleting a plane'
    size(remaining)
    save(minIndex)=[];
    numPointsInPlane(minIndex)=[];
    i=i-1;
end

disp 'culled down to 2 planes'

%grow the two planes to their full extent, then collect any outliers
%separately
[NRemaining,~]=size(remaining);
for i=1:2
    % select a random small surface patch
    oldlist=save{i};
    [plane,~] = fitplane(oldlist);
    
    % grow patch
    stillgrowing = 1;
    oldstillgrowing=0;
    c=[];
    while stillgrowing>oldstillgrowing
        
        % find neighbouring points that lie in plane
        oldstillgrowing = stillgrowing;
        [newlist,remaining] = getallpoints(plane,oldlist,remaining,NPts);
        [NewL,~] = size(newlist);
        [OldL,~] = size(oldlist);
        save{i}=newlist;
        [numPointsInPlane(i),~]=size(save{i});
        clf;
        hold all;
        plot3(remaining(:,1),remaining(:,2),remaining(:,3),'.k');
        for p=1:i
            plot3(save{p}(:,1),save{p}(:,2),save{p}(:,3),'.');
        end
        c=[];
        pause(0.1);
        
        if NewL > OldL + 4
            % refit plane
            [newplane,fit] = fitplane(newlist);
            [newplane',fit,NewL];
            planelist(i,:) = newplane';
            if fit > 0.2*NewL       % bad fit - stop growing
                break
            end
            stillgrowing = 1+stillgrowing
            oldlist = newlist;
            size(newlist)
            plane = newplane;
            c = 1;
            pause(0.1);
        end
    end
    [NRemaining,~]=size(remaining);
    waiting=1
    pause(1)
end

%redraw the sole surviving planes
clf;
hold all;
plot3(remaining(:,1),remaining(:,2),remaining(:,3),'k.');
plot3(save{1}(:,1),save{1}(:,2),save{1}(:,3),'r.');
plot3(save{2}(:,1),save{2}(:,2),save{2}(:,3),'b.')

%output save{1} and save{2}, these are the pointlists for the two planes
%some points were outliers, and did not make it into either list
end
