function [closex closey] = getPoint(newXs,newYs)
leaf=[49 95 72 36];
[x1 y1] = ginput(1);
plot(x1,y1);
min = 1;
max = numel(newXs);
mindist = 2^31-1;
minx = -1;
miny = -1;
for i=min:max
    x2 = newXs(i);
    y2 = newYs(i);
    xdist = x2-x1;
    ydist = y2-y1;
    dist = sqrt(xdist^2 + ydist^2);
    if(dist<mindist)
        mindist=dist;
        minx = x2;
        miny = y2;
    end
end
closex= minx;
closey= miny;
end
    